// port of js library https://github.com/imoneoi/mistral-tokenizer

/// MIT LICENSE
///
/// Copyright 2024 nomtek.com
/// Copyright 2023 belladore.ai
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included
/// in all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.

library;

import 'dart:convert';

import 'package:characters/characters.dart';
import 'package:collection/collection.dart';

part 'merges_binary.dart';
part 'vocab_base64.dart';

Map<String, int> decompressMerges({
  required List<String> vocabById,
  String mergesBinaryInBase64 = mergesBinary,
}) {
  // decode base64
  final byteArray = base64.decode(mergesBinaryInBase64);

  // Each byte-pair represents a tokenId.
  // Convert byte-pairs to tokenIds (integers between 0 and 32000).
  final tokenIds = <int>[];
  for (var i = 0; i < byteArray.length; i += 2) {
    final byte1 = byteArray[i];
    final byte2 = byteArray[i + 1];
    final tokenId = byte1 + (byte2 << 8);
    tokenIds.add(tokenId);
  }

  String getMergeIdString(int tokenId1, int tokenId2) {
    return getMergeIdStringFromVocabulary(vocabById, tokenId1, tokenId2);
  }

  // Each pair of tokenIds represents a merge.
  final merges = <String, int>{};
  for (var i = 0; i < tokenIds.length; i += 2) {
    final tokenId1 = tokenIds[i];
    final tokenId2 = tokenIds[i + 1];
    final mergeIdString = getMergeIdString(tokenId1, tokenId2);
    merges[mergeIdString] = i + 1;
  }

  return merges;
}

String getMergeIdStringFromVocabulary(
  List<String> vocabById,
  int tokenId1,
  int tokenId2,
) =>
    '${vocabById[tokenId1]} ${vocabById[tokenId2]}';

/// Helper function to decode the vocabulary.
///
/// vocab_base64 is base64-encoded string of tokens delimited by '\n'
/// (line break) in utf-8.
/// The row number of the token (indexing from 0) represents the id
/// of the token in mistral tokenizer.
///
/// Most tokens look like this: "ic" (without the quotes)
/// (representing the "i" character followed by the "c" character)
/// Some tokens are special. In particular, spaces are replaced with
/// the "▁" character and line-break is represented as "<0x0A>".
///
/// This helper function returns the vocabulary as an array that
/// contains Strings representing tokens:
///
///  ```pre
///  "<unk>"   // Special token: unknown token
///  "<s>"     // Special token: beginning of string
///  "</s>"    // Special token: end of string
///  "<0x00>"  // Byte-level token representing the 0-byte
///  "<0x01>"  // Byte-level token ...
///  "<0x02>"  // Byte-level token ...
///  ...       // More byte-level tokens
///  "<0x0A>"  // Byte-level token representing '\n' (line break). This is one of the few byte-level tokens that appear to be actually needed in practice.
///  ...       // More byte-level tokens
///  "<0xFF>"  // Byte-level token ...
///  "▁▁"     // Token representing 2 consecutive spaces.
///  "▁t"     // Token representing the space character followed by the "t" character.
///  "er"      // Token representing the "e" character followed by the "r" character. Most tokens look like this.
///  ...       // 32000 tokens
///  ```
List<String> decodeVocabulary({String vocabularyInBase64 = vocabBase64}) {
  return utf8.decode(base64.decode(vocabularyInBase64)).split('\n');
}

// Converts text to tokens. 
// The exact tokens depend on the vocabulary used.
// The resulting tokens can differ from the tokens that are used by Mistral AI.
//
// It's best to not depend on the exact length of the resulting tokens.
class MistralTokenizer {
  MistralTokenizer(this.vocabById, this.vocabByString, this.merges);

  factory MistralTokenizer.fromBase64({
    String vocabBase64 = vocabBase64,
    String mergesBinaryInBase64 = mergesBinary,
  }) {
    final vocabById = decodeVocabulary(vocabularyInBase64: vocabBase64);
    final vocabByString = <String, int>{};
    for (var i = 0; i < vocabById.length; i++) {
      final token = vocabById[i];
      vocabByString[token] = i;
    }
    final merges = decompressMerges(
      vocabById: vocabById,
      mergesBinaryInBase64: mergesBinaryInBase64,
    );
    return MistralTokenizer(vocabById, vocabByString, merges);
  }

  // id is the index of the token in the vocabulary
  final List<String> vocabById;
  final Map<String, int> vocabByString;
  final Map<String, int> merges;
  String get _thickUnderscore => vocabById[28705];

  List<int> mapCharactersToTokenIds({
    required String prompt,
    required bool addBosToken,
    required bool addPrecedingSpace,
  }) {
    final tokenIds = <int>[];

    // Add beginning-of-string token.
    if (addBosToken) {
      tokenIds.add(1);
    }

    var promptAltered = prompt;
    // Add preceding space token.
    if (addPrecedingSpace) {
      promptAltered = ' $promptAltered';
    }

    // space is represented by "▁" (thick underscore, id 28705)
    promptAltered = promptAltered.replaceAll(' ', _thickUnderscore);
    final chars = promptAltered.characters;
    for (var i = 0; i < chars.length; i++) {
      final char = chars.elementAt(i);
      if (vocabByString.containsKey(char)) {
        // we have a token for this character so add it
        tokenIds.add(vocabByString[char]!);
      } else {
        // we don't have a token for this character so add the byte-level tokens
        final bytes = utf8.encode(char);
        for (var j = 0; j < bytes.length; j++) {
          final utf8Byte = bytes[j];
          final hex = vocabByString[_utf8ByteToHex(utf8Byte)];
          if (hex != null && hex >= 0) {
            tokenIds.add(hex);
          } else {
            // shouldn't happen because mistral vocab should
            // have all byte-level tokens
            //
            // if it does happen, let's follow the js implementation
            // and add <UNK> token instead of crash
            print(
              'Encountered unknown character: $char '
              '(partial utf8 byte $utf8Byte, hex: ${_utf8ByteToHex(utf8Byte)})',
            );
            tokenIds.add(0);
          }
        }
      }
    }
    return tokenIds;
  }

  String _utf8ByteToHex(int byte) {
    final hexValue = byte.toRadixString(16).toUpperCase().padLeft(2, '0');
    return '<0x$hexValue>';
  }

  List<int> encode(
    String prompt, {
    bool addBosToken = true,
    bool addPrecedingSpace = true,
  }) {
    if (prompt.isEmpty ||
        vocabById.isEmpty ||
        vocabByString.isEmpty ||
        merges.isEmpty) {
      return [];
    }

    // initially each character is transformed into a tokenId, later on these
    // will be merged
    final tokenIds = mapCharactersToTokenIds(
      prompt: prompt,
      addBosToken: addBosToken,
      addPrecedingSpace: addPrecedingSpace,
    );

    // set up priority queue to efficiently iterate over
    // all merges possibilities
    final mergeQueue = PriorityQueue<TokenNode>((a, b) {
      return a.mergePriority!.compareTo(b.mergePriority!);
    });

    void addToMergeQueue(TokenNode leftNode) {
      final mergeIdString = getMergeIdString(
        leftNode.tokenId,
        leftNode.next!.tokenId,
      );

      // Merge priority is primarily determined by the location
      // of the merge in the "merges" data,
      // secondarily determined by the relative position of the node
      // in the linked list
      // (We want to perform equal merges from left to right)
      final merge = merges[mergeIdString];
      if (merge != null) {
        // If mergePriority not found in merges,
        // that means this merge is not possible according to vocabulary.
        final mergePriority = merge + (leftNode.origPos) / prompt.length;
        leftNode
          ..mergePriority = mergePriority
          ..mergeToString = mergeIdString.replaceAll(' ', '');
        mergeQueue.add(leftNode);
      }
    }

    // Fill merge queue from initial merge possibilities
    // and construct linked list
    var firstTokenNode = TokenNode(origPos: 0, tokenId: tokenIds[0]);
    var prevTokenNode = firstTokenNode;
    for (var i = 1; i < tokenIds.length; i++) {
      final tokenNode =
          TokenNode(origPos: i, tokenId: tokenIds[i], prev: prevTokenNode);
      prevTokenNode.next = tokenNode;
      addToMergeQueue(prevTokenNode);
      prevTokenNode = tokenNode;
    }

    // Perform merges in priority order
    while (mergeQueue.isNotEmpty) {
      final leftOfMerge = mergeQueue.removeFirst();
      // Check that this merge is still possible
      if (leftOfMerge.deleted) continue;
      if (leftOfMerge.next == null) continue;
      if (leftOfMerge.next!.deleted) continue;

      // Mark leftOfMerge and rightOfMerge as being deleted,
      // because they are actually being replaced by a merged token.
      leftOfMerge.deleted = true;
      leftOfMerge.next!.deleted = true;
      // It's a little bit more complicated to fix the prev of leftOfMerge.
      if (leftOfMerge.prev != null) {
        final oldPrev = leftOfMerge.prev!
          // Mark oldPrev as deleted, to avoid erroneous merges later
          // (ref to this node might exist in priority queue)
          ..deleted = true;
        // Replace oldPrev within the linked list with a copy of itself
        final newPrev = TokenNode(
          origPos: oldPrev.origPos,
          tokenId: oldPrev.tokenId,
          prev: oldPrev.prev,
          next: leftOfMerge,
        );
        leftOfMerge.prev = newPrev;
        // Update linked list reference of "prev of prev"
        if (newPrev.prev != null) {
          newPrev.prev!.next = newPrev;
        } else {
          // If "prev of prev" does not exist, that means newPrev
          // must be the new firstNode
          firstTokenNode = newPrev;
        }
      }

      // Create node representing merge result
      final resultOfMerge = TokenNode(
        origPos: leftOfMerge.origPos,
        tokenId: vocabByString[leftOfMerge.mergeToString]!,
        prev: leftOfMerge.prev,
        next: leftOfMerge.next?.next,
      );
      // Consider adding to merge queue: prev-->resultOfMerge
      if (resultOfMerge.prev != null) {
        resultOfMerge.prev?.next = resultOfMerge;
        addToMergeQueue(resultOfMerge.prev!);
      } else {
        // If prev does not exist then this is the new firstNode
        firstTokenNode = resultOfMerge;
      }
      // Consider adding to merge queue: resultOfMerge-->next
      if (resultOfMerge.next != null) {
        resultOfMerge.next?.prev = resultOfMerge;
        addToMergeQueue(resultOfMerge);
      }
    }

    // Get final tokenIds by traversing the linked list
    final mergeTokenIds = <int>[];
    for (TokenNode? currentTokenNode = firstTokenNode;
        currentTokenNode != null;
        currentTokenNode = currentTokenNode.next) {
      mergeTokenIds.add(currentTokenNode.tokenId);
    }

    return mergeTokenIds;
  }

  String getMergeIdString(int tokenId1, int tokenId2) {
    return getMergeIdStringFromVocabulary(vocabById, tokenId1, tokenId2);
  }

  String decode(
    List<int> tokenIds, {
    bool addBosToken = true,
    bool addPrecedingSpace = true,
  }) {
    final utf8ByteValues = <int>[];
    final startIndex = addBosToken ? 1 : 0;
    for (var i = startIndex; i < tokenIds.length; i++) {
      final tokenId = tokenIds[i];
      final tokenString = vocabById[tokenId];
      if (tokenString.startsWith('<0x') && tokenString.endsWith('>')) {
        final utf8Byte = _hexToUtf8Byte(tokenString);
        utf8ByteValues.add(utf8Byte);
      } else {
        final utf8Bytes = utf8.encode(tokenString);
        utf8ByteValues.addAll(utf8Bytes);
      }
    }
    final decodedString = utf8.decode(utf8ByteValues);
    final spaceFixed = decodedString.replaceAll(_thickUnderscore, ' ');
    // Note that preceding space must be removed here at string level,
    // not earlier at token level, because multiple consecutive spaces
    // are represented as single token.
    return addPrecedingSpace ? spaceFixed.substring(1) : spaceFixed;
  }

  int _hexToUtf8Byte(String hex) {
    final strippedHex = hex.replaceAll(RegExp('<0x|>'), '');
    return int.parse(strippedHex, radix: 16);
  }
}

class TokenNode {
  TokenNode({
    required this.origPos,
    required this.tokenId,
    this.mergePriority,
    this.mergeToString,
    this.deleted = false,
    this.prev,
    this.next,
  });

  final int origPos;
  final int tokenId;
  num? mergePriority;
  String? mergeToString;
  bool deleted;

  TokenNode? prev;
  TokenNode? next;
}

import 'package:langchain/langchain.dart';

class TextToChunkSplitter {
  // splits text into smaller chunks based on the number of tokens per chunk
  List<String> split(
    String text, {
    int chunkSize = 1000,
    int chunkOverlap = 100,
  }) {
    final textSplitter = RecursiveCharacterTextSplitter(
      chunkSize: chunkSize,
      chunkOverlap: chunkOverlap,
    );
    final splitText = textSplitter.splitText(text);
    return splitText;
  }
}

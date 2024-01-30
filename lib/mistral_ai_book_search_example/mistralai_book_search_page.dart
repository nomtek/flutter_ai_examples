import 'package:flutter/material.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/book_text_search.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_book_search_example/models.dart';
import 'package:mistral_ai_chat_example_app/mistral_ai_chat_example/mistral_client.dart';
import 'package:mistral_ai_chat_example_app/mistral_tokenizer/mistral_tokenizer.dart';
import 'package:provider/provider.dart';

final mistralTokenizer = MistralTokenizer.fromBase64();

class MistralAIBookSearchPage extends StatelessWidget {
  const MistralAIBookSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => BookTextSearch(
        client: mistralAIClient,
        tokenizer: mistralTokenizer,
      ),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<BookTextSearch>().init(),
      builder: (context, snapshot) {
        debugPrint('BookTextSearch init: ${snapshot.connectionState}');
        Widget body;
        final actions = <Widget>[];
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            body = Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            body = const SearchForm();
            actions.add(
              IconButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) {
                      return Provider.value(
                        value: context.read<BookTextSearch>(),
                        builder: (_, __) {
                          return const Dialog(child: BookFragmentsList());
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.book),
              ),
            );
          }
        } else {
          body = const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Book search'),
            actions: actions,
          ),
          body: body,
        );
      },
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({
    super.key,
  });

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  (String query, List<SearchResult> similarFragments)? result;
  bool isSearching = false;
  void search(String query) {
    debugPrint('Searching for $query');
    setState(() {
      result = null;
      isSearching = true;
    });
    final textSearch = context.read<BookTextSearch>();
    textSearch.searchFragment(query).then(
      (value) {
        if (!mounted) return;
        setState(() {
          result = (query, value);
          isSearching = false;
        });
      },
    ).onError(
      (error, stackTrace) {
        debugPrint('Search error: $error');
        debugPrint(stackTrace.toString());
        if (!mounted) return;
        setState(() {
          isSearching = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Search for a sentence in the book'),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a search term',
          ),
          onSubmitted: search,
        ),
        const SizedBox(height: 16),
        if (isSearching) const LinearProgressIndicator(),
        if (result != null) ...[
          ListTile(title: Text('Results for "${result!.$1}"')),
          const Divider(),
          for (final result in result!.$2)
            ListTile(
              title: Text(result.text),
              subtitle: Text('Similarity: ${result.similarity}'),
              leading: const Icon(Icons.text_snippet),
              isThreeLine: true,
            ),
        ],
      ],
    );
  }
}

// displays the list of fragments
class BookFragmentsList extends StatelessWidget {
  const BookFragmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final textSearch = context.read<BookTextSearch>();
    final fragments = textSearch.fragments();
    final tokens = textSearch.fragmentsTokens();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: fragments.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final sentence = fragments[index];
        final sentenceLength = sentence.runes.length;

        return ListTile(
          title: Text(fragments[index]),
          subtitle: Text(
            'length: $sentenceLength, tokens: ${tokens[index].length}',
          ),
        );
      },
    );
  }
}

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
      create: (_) => BookSearch(
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
      future: context.read<BookSearch>().init(),
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
                onPressed: () => showBookFragments(context),
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

  // display dialog with the whole book text divided into fragments
  Future<void> showBookFragments(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return Provider.value(
          // it's important to read the value from outside context
          // and not the builder context
          value: context.read<BookSearch>(),
          builder: (_, __) {
            return const Dialog(child: BookFragmentsList());
          },
        );
      },
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  Answer? result;
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Align(
          child: Text(
            context.read<BookSearch>().bookTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ask question about book...',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: search,
          ),
        ),
        const SizedBox(height: 16),
        if (isSearching) const LinearProgressIndicator(),
        if (result != null) ...[
          ListTile(
            title: Text('Results for "${result!.question}"'),
            titleAlignment: ListTileTitleAlignment.titleHeight,
            leading: const Icon(Icons.question_mark),
          ),
          const Divider(),
          ListTile(
            title: Text(result!.text),
            titleAlignment: ListTileTitleAlignment.titleHeight,
            leading: const Icon(Icons.question_answer),
          ),
          const Divider(),
          ListTile(
            title: Text('Keywords: ${result!.keywords.join(', ')}'),
            titleAlignment: ListTileTitleAlignment.titleHeight,
            leading: const Icon(Icons.text_snippet),
          ),
          const Divider(),
          ListTile(
            title: const Text('Fragments used for search'),
            titleAlignment: ListTileTitleAlignment.titleHeight,
            leading: const Icon(Icons.text_snippet),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: FragmentSimilarityList(
                      similarities: result!.fragmentSimilarities,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }

  void search(String question) {
    debugPrint('Searching for $question');
    setState(() {
      result = null;
      isSearching = true;
    });
    final textSearch = context.read<BookSearch>();
    textSearch.findAnswer(question).then(
      (value) {
        if (!mounted) return;
        setState(() {
          result = value;
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
}

// display list of fragments most relevant to the question
class FragmentSimilarityList extends StatelessWidget {
  const FragmentSimilarityList({required this.similarities, super.key});

  final List<FragmentSimilarity> similarities;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: similarities.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = similarities[index];
        final fragment = item.text;
        final fragmentTextLength = fragment.runes.length;
        final similarity = item.similarity;

        return ListTile(
          titleAlignment: ListTileTitleAlignment.titleHeight,
          leading: CircleAvatar(child: Text('${item.fragmentIndex + 1}')),
          title: Text(fragment),
          subtitle: Text(
            'Similarity to question: $similarity, length: $fragmentTextLength',
          ),
        );
      },
    );
  }
}

// displays the list of fragments
class BookFragmentsList extends StatelessWidget {
  const BookFragmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    final textSearch = context.read<BookSearch>();
    final fragments = textSearch.fragments();
    final tokens = textSearch.fragmentsTokens();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: fragments.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final fragment = fragments[index];
        final fragmentTextLength = fragment.runes.length;

        return ListTile(
          titleAlignment: ListTileTitleAlignment.titleHeight,
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(fragments[index]),
          subtitle: Text(
            'Text length: $fragmentTextLength, tokens: ${tokens[index].length}',
          ),
        );
      },
    );
  }
}

## Book search example

### Data
Example book is `Twenty Thousand Leagues under the Sea` by Jules Verne

Based on the book we generated a [json file](../../assets/20k_leages_under_the_sea_verne.json) with embeddings and tokenized fragments of text.

Format of file is (data is just a sample data to showcase the structure):
```json
{
    "fragments":[
        "fragment1",
        "fragment2"
    ],
    "fragmentTokens":[
        [1,2,3,4],
        [2,3,4,5],
        [6,7,8,9]
    ],
    "fragmentEmbeddings":[
        [1.0, 2.3, 46.6],
        [21.0, 23.1, 46.6],
        [1.0, 2.3, 46.6],
    ]
}
```

The tokens are generated with [mistral tokenizer](../mistral_tokenizer/mistral_tokenizer.dart).
Embedding are generated with [mistral client](https://pub.dev/packages/mistralai_client_dart).

To generate new data for search use [prepare data script](prepare_data.dart).
Inside just change the file name you want to generate new data for.

## Prompts and embeddings

TODO:
- write about embeddings and why we calculate the embedding based on question and keywords
- describe why prompts are looking the way they are

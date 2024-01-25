# mistral_ai_chat_example_app

Example app showcasing the Mistral AI chat client app.

## Getting Started

### Install dependencies

```shell
dart pub get
```

### Generate code

```shell
dart run build_runner build -d 
```

### Setup Mistral AI api key

1. Add `env.env` file in the root project
2. Add `MISTRAL_AI_API_KEY=your api key` to the file.

### Run example

#### VS code

Just use ready to use [vscode configurations](.vscode/launch.json)

#### Terminal

```shell
flutter run --dart-define-from-file=env.env
```

or use script that contains above snippet

**unix**
```shell
./tool/flutter_run.sh
```

you can also pass parameters for `flutter run` command to the script
```shell
./tool/flutter_run.sh -d chrome
```

**windows**
```shell
tool\flutter_run.bat
```

pass parameters to `flutter run` like this:
```shell
tool\flutter_run.bat -d chrome
```

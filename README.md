# mistral_ai_chat_example_app

Example app showcasing the Mistral AI chat client.

## Getting Started

### Install dependencies

```shell
dart pub get
```

### Generate code

```shell
dart run build_runner build -d 
```

### Setup Mistral AI API key

1. Open the `env.env` file in the root project
2. Replace `your api key` with your Mistral AI API key.

### Run the example app

#### Using the Visual Studio Code

We've prepared some ready to use [launch configurations](.vscode/launch.json) for VSC.

In most cases, you should choose the regular `mistral_ai_chat_example_app` configuration.

#### Using the terminal

You can either use the `flutter run` command directly

```shell
flutter run --dart-define-from-file=env.env
```

or use a script that contains the above snippet

**Linux/MacOS**
```shell
./tool/flutter_run.sh
```

**Windows**
```shell
tool\flutter_run.bat
```

You can pass parameters to the script by appending them at the end like this:
```shell
// Linux/MacOS
./tool/flutter_run.sh -d chrome

// Windows
tool\flutter_run.bat -d chrome
```

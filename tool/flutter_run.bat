@echo off
REM script to run flutter app with environment variables
REM it is recommended to use this script instead of flutter run for development
REM
REM run 'tool\flutter_run.bat -h' for help
REM run 'tool\flutter_run.bat -d chrome' for web

REM "%*" allows you to pass arguments to the script
REM e.g. tool\flutter_run.bat -d chrome
flutter run --dart-define-from-file=env.env %*

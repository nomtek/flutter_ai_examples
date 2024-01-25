#!/bin/sh

# script to run flutter app with environment variables
# it is recommended to use this script instead of flutter run for development
#
# run './tool/flutter_run.sh -h' for help
# run './tool/flutter_run.sh -d' chrome for web

# "$@" allows you to pass arguments to the script
# e.g. ./tool/flutter_run.sh -d chrome
flutter run --dart-define-from-file=env.env "$@"

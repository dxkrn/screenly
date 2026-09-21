#!/bin/bash
flutter clean
flutter pub get
flutter run -t lib/main_$1.dart

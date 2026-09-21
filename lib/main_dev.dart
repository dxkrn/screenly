import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig(
    name: "DEV",
    color: Colors.red,
    location: BannerLocation.topStart,
    variables: {
      "baseUrl": "https://dev.api.example.com",
      "env": "development",
      // NOTE: Add more env variables here
    },
  );

  app.main();
}

import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig(
    name: "PROD",
    color: Colors.transparent,
    variables: {
      "baseUrl": "https://api.example.com",
      "env": "production",
      // NOTE: Add more env variables here
    },
  );

  app.main();
}

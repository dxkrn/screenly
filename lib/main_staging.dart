import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig(
    name: "STAGING",
    color: Colors.red,
    location: BannerLocation.topEnd,
    variables: {
      "baseUrl": "https://staging.api.example.com",
      "env": "Staging",
      // NOTE: Add more env variables here
    },
  );

  app.main();
}

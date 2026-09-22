import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'ProfileView is working',
          style: heading4TextStyle.copyWith(color: whiteColor),
        ),
      ),
    );
  }
}

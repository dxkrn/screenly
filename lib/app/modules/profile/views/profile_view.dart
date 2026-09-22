import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'sections/awaiting_approval_section.dart';
import 'sections/logged_in_section.dart';
import 'sections/profile_header_section.dart';
import 'sections/web_auth_section.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeaderSection(),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isCheckingAuth.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFFE50914),
                      ),
                    ),
                  );
                }

                if (controller.isLoggedIn.value) {
                  return const LoggedInSection();
                }

                if (controller.isAwaitingApproval.value) {
                  return const AwaitingApprovalSection();
                }

                return const WebAuthSection();
              }),
            ],
          ),
        ),
      ),
    );
  }
}

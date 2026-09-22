import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/data/models/tmdb_account_model.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';
import '../../controllers/profile_controller.dart';
import '../components/disconnect_dialog.dart';
import '../components/profile_info_row.dart';

class LoggedInSection extends GetView<ProfileController> {
  const LoggedInSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileCard(user),
          const SizedBox(height: 20),
          _buildAccountInfoCard(user),
          const SizedBox(height: 24),
          _buildDisconnectButton(context),
        ],
      );
    });
  }

  Widget _buildProfileCard(TmdbAccountModel? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: ClipOval(
              child: user?.avatarUrl.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: user!.avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFE50914),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildDefaultAvatar(user),
                    )
                  : _buildDefaultAvatar(user),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'TMDB User',
            style: heading5TextStyle.copyWith(color: whiteColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '@${user?.username ?? ""}',
            style: paragraphRegulerTextStyle.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Status Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'TMDB Session Active',
                  style: paragraphSmallTextStyle.copyWith(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard(TmdbAccountModel? user) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: heading6TextStyle.copyWith(color: whiteColor),
          ),
          const SizedBox(height: 14),
          ProfileInfoRow(
            icon: Icons.tag_rounded,
            label: 'Account ID',
            value: user?.id.toString() ?? '-',
          ),
          const Divider(color: Colors.white10, height: 20),
          // ProfileInfoRow(
          //   icon: Icons.language_rounded,
          //   label: 'Language',
          //   value: user?.iso6391?.toUpperCase() ?? 'EN',
          // ),
          // const Divider(color: Colors.white10, height: 20),
          // ProfileInfoRow(
          //   icon: Icons.public_rounded,
          //   label: 'Country',
          //   value: user?.iso31661 ?? '-',
          // ),
          // const Divider(color: Colors.white10, height: 20),
          ProfileInfoRow(
            icon: Icons.lock_outline_rounded,
            label: 'Include Adult',
            value: (user?.includeAdult ?? false) ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectButton(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: () => DisconnectDialog.show(
        context,
        onConfirm: controller.logout,
      ),
      icon: const Icon(Icons.logout_rounded, size: 20),
      label: Text(
        'Disconnect TMDB Account',
        style: heading6TextStyle.copyWith(
          color: Colors.redAccent,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(TmdbAccountModel? user) {
    return Container(
      color: const Color(0xFF2C2C2C),
      child: Center(
        child: Text(
          user?.displayName.isNotEmpty == true
              ? user!.displayName[0].toUpperCase()
              : 'U',
          style: heading3TextStyle.copyWith(color: primaryColor),
        ),
      ),
    );
  }
}

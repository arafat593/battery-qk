import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/account_settings_screen/provider/account_settings_provider.dart';
import 'package:olabisiolai_flutter_app/screens/account_settings_screen/widget/account_setting_switch_tile.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/login_screen/provider/login_provider.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget_tow.dart';
import '../../../../widgets/texts/app_text.dart';
import '../../../utils/gap.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountSettingsProvider.notifier).fetchSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountSettingsProvider);
    final notifier = ref.read(accountSettingsProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: "Account Settings"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: "Account Settings",
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
            const Gap(height: 8),
            AppText(
              text:
                  "Manage your curated preferences, security settings, and personal identity.",
              fontSize: 16,
              color: AppColors.instance.deepHintText,
            ), 

            const Gap(height: 25),

            AppText(
              text: "COMMUNICATION",
              color: AppColors.instance.success,
              fontSize: 12,
            ),
            const Gap(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AccountSettingSwitchTile(
                    icon: Icons.chat_bubble_outline,
                    title: "SMS Notifications",
                    subtitle: "Real-time alerts for booking updates",
                    value: state.smsNotifications,
                    onChanged: (val) => notifier.updateSmsNotifications(val),
                  ),
                  const Divider(height: 30),
                  AccountSettingSwitchTile(
                    icon: Icons.email_outlined,
                    title: "Email Preferences",
                    subtitle: "Weekly curation & newsletter",
                    value: state.emailNotifications,
                    onChanged: (val) => notifier.updateEmailNotifications(val),
                  ),
                  const Divider(height: 30),
                  AccountSettingSwitchTile(
                    icon: Icons.chat_outlined,
                    title: "WhatsApp",
                    subtitle: "Direct concierge assistance",
                    value: state.pushNotifications,
                    onChanged: (val) => notifier.updatePushNotifications(val),
                  ),
                ],
              ),
            ),

            const Gap(height: 30),

            // --- Action Buttons ---
            AppButton(
              title: state.isSaving ? "Saving..." : "Save Changes",
              onTap: state.isSaving ? null : () => notifier.saveSettings(),
            ),
            const Gap(height: 12),
            AppButton(
              title: "Sign Out",
              backgroundColor: AppColors.instance.transparent,
              titleColor: AppColors.instance.red,
              leading: Icons.logout,
              iconColor: AppColors.instance.red,
              onTap: () async {
                final success = await ref.read(loginProvider.notifier).logOut();
                if (success) {
                  AppRoutes.instance.goNamed(AppRoutesKey.instance.loginScreen);
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout failed")),
                  );
                }
              },
            ),
            const Gap(height: 20),
          ],
        ),
      ),
    );
  }
}

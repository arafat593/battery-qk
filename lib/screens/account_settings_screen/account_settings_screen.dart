import 'package:flutter/material.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/screens/account_settings_screen/widget/account_setting_switch_tile.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget_tow.dart';
import '../../../../widgets/texts/app_text.dart';
import '../../../utils/gap.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool smsNotifications = true;
  bool emailPreferences = true;
  bool whatsAppConcierge = false;

  @override
  Widget build(BuildContext context) {
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

            // --- Identity Section ---
            AppText(
              text: "IDENTITY",
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
                  AppInputWidgetTwo(
                    title: "FULL NAME",
                    hintText: "Adeshola Balogun",
                  ),
                  Gap(height: 15),
                  AppInputWidgetTwo(
                    title: "EMAIL ADDRESS",
                    hintText: "adeshola.b@gidira.com",
                  ),
                  Gap(height: 15),
                  AppInputWidgetTwo(
                    title: "PHONE NUMBER",
                    hintText: "+234 801 234 5678",
                  ),
                ],
              ),
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
                    value: smsNotifications,
                    onChanged: (val) => setState(() => smsNotifications = val),
                  ),
                  const Divider(height: 30),
                  AccountSettingSwitchTile(
                    icon: Icons.email_outlined,
                    title: "Email Preferences",
                    subtitle: "Weekly curation & newsletter",
                    value: emailPreferences,
                    onChanged: (val) => setState(() => emailPreferences = val),
                  ),
                  const Divider(height: 30),
                  AccountSettingSwitchTile(
                    icon: Icons.chat_outlined,
                    title: "WhatsApp",
                    subtitle: "Direct concierge assistance",
                    value: whatsAppConcierge,
                    onChanged: (val) => setState(() => whatsAppConcierge = val),
                  ),
                ],
              ),
            ),

            const Gap(height: 30),

            // --- Action Buttons ---
            AppButton(title: "Save Changes"),
            const Gap(height: 12),
            AppButton(
              title: "Sign Out",
              backgroundColor: AppColors.instance.transparent,
              titleColor: AppColors.instance.red,
              leading: Icons.logout,
              iconColor: AppColors.instance.red,
            ),
            const Gap(height: 20),
          ],
        ),
      ),
    );
  }
}

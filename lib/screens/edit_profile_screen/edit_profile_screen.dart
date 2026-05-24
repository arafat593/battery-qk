import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image_circular.dart';
import 'package:olabisiolai_flutter_app/widgets/inputs/app_input_widget_tow.dart';
import '../../../widgets/texts/app_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/gap.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../account_settings_screen/provider/account_settings_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool _obscureCurrent = true;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accountSettingsProvider);
    final notifier = ref.read(accountSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: "Edit Profile",
        actions: [
          TextButton(
            onPressed: state.isSaving
                ? null
                : () async {
                    final success = await notifier.saveSettings();
                    if (success && context.mounted) {
                      Navigator.pop(context);
                    }
                  },
            child: AppText(
              text: state.isSaving ? "Saving" : "Save",
              color: AppColors.instance.blue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Profile Picture Update ---
            GestureDetector(
              onTap: state.isSaving
                  ? null
                  : () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () {
                                  Navigator.pop(context);
                                  notifier.pickImage(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                  notifier.pickImage(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        AppImageCircular(
                          borderRadius: 100,
                          height: 120,
                          width: 120,
                          filePath: state.pickedImagePath.isNotEmpty
                              ? state.pickedImagePath
                              : null,
                          url:
                              state.pickedImagePath.isEmpty &&
                                  state.photo.isNotEmpty
                              ? state.photo
                              : (state.pickedImagePath.isEmpty
                                    ? "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                                    : null),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (state.isSaving)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Gap(height: 10),
                    AppText(
                      text: state.isSaving ? "SAVING..." : "UPDATE LOGO",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(height: 30),

            // --- Personal Information Section ---
            SectionCard(
              icon: Icons.person_outline,
              title: "Personal Information",
              children: [
                AppInputWidgetTwo(
                  title: "FULL NAME",
                  controller: notifier.fullNameController,
                ),
                AppInputWidgetTwo(
                  title: "EMAIL ADDRESS",
                  controller: notifier.emailController,
                ),
                AppInputWidgetTwo(
                  title: "PHONE NUMBER",
                  controller: notifier.phoneController,
                ),
                AppInputWidgetTwo(
                  title: "LOCATION / ADDRESS",
                  prefix: Icon(Icons.location_on_outlined),
                  controller: notifier.locationController,
                ),
              ],
            ),

            const Gap(height: 20),

            SectionCard(
              icon: Icons.lock_outline,
              title: "Security",
              children: [
                AppInputWidgetTwo(
                  title: "CURRENT PASSWORD",
                  hintText: "Enter your current password",
                ),
                AppInputWidgetTwo(
                  title: "NEW PASSWORD",
                  hintText: "Enter your new password",
                ),
                AppInputWidgetTwo(
                  title: "CONFIRM NEW PASSWORD",
                  hintText: "Enter your confirm new password",
                ),
              ],
            ),
            const Gap(height: 40),
          ],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: 20),
              const Gap(width: 8),
              AppText(text: title, fontSize: 16, fontWeight: FontWeight.bold),
            ],
          ),
          const Gap(height: 20),
          ...children,
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/screens/auth_screen/otp_verification_screen/provider/otp_verification_provider.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import 'package:olabisiolai_flutter_app/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';
import '../../../services/repository/auth_repository.dart';
import '../../../utils/app_snack_bar.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  late TextEditingController otpController;
  String email = "";

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();

    /// GET EMAIL FROM PREVIOUS SCREEN
    Future.microtask(() {
      email = GoRouterState.of(context).extra as String? ?? "";
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      AppSnackBar.instance.error("Enter OTP");
      return;
    }

    if (email.isEmpty) {
      AppSnackBar.instance.error("Invalid session");
      return;
    }

    final success = await ref
        .read(otpVerificationProvider.notifier)
        .verifyOtp(email: email, otp: int.parse(otpController.text.trim()));

    if (success) {
      AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
    } else {
      AppSnackBar.instance.error("Invalid OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(otpVerificationProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(
        title: "",
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: AppSize.size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraNameLogo,
                    width: 116,
                  ),
  
                  Gap(height: 40),
  
                  AppText(
                    text: 'OTP Verification',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
  
                  Gap(height: 12),
  
                  AppText(
                    text: 'Enter the 6-digit code sent to your email',
                    textAlign: TextAlign.center,
                    fontSize: 18,
                  ),
  
                  Gap(height: 30),
  
                  /// OTP INPUT
                  AppInputWidgetTwo(
                    title: "OTP Code",
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter OTP";
                      }
                      if ((value ?? '').length < 4) {
                        return "Invalid OTP";
                      }
                      return null;
                    },
                  ),
  
                  Gap(height: 30),
  
                  /// BUTTON
                  AppButton(
                    title: "Verify",
                    trailing: Icons.arrow_forward,
                    onTap: isLoading ? null : verifyOtp,
                    isLoading: isLoading,
                  ),
  
                  Gap(height: 20),
  
                  /// RESEND
                  TextButton(
                    onPressed: () async {
                      if (email.isEmpty) return;
  
                      final success = await AuthRepository.instance.authResendOTP(
                        email: email,
                      );
  
                      if (success) {
                        AppSnackBar.instance.success("OTP resent");
                      } else {
                        AppSnackBar.instance.error("Failed to resend");
                      }
                    },
                    child: const Text("Resend Code"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

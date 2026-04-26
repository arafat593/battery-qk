import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:olabisiolai_flutter_app/constant/app_asserts_icons_path.dart';
import 'package:olabisiolai_flutter_app/constant/app_colors.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes.dart';
import 'package:olabisiolai_flutter_app/routes/app_routes_key.dart';
import 'package:olabisiolai_flutter_app/utils/app_size.dart';
import 'package:olabisiolai_flutter_app/utils/gap.dart';
import 'package:olabisiolai_flutter_app/widgets/app_image/app_image.dart';
import 'package:olabisiolai_flutter_app/widgets/buttons/app_button.dart';
import 'package:olabisiolai_flutter_app/widgets/texts/app_text.dart';
import '../../../../utils/app_snack_bar.dart';
import '../../../../widgets/inputs/app_input_widget_tow.dart';
import '../provider/forget_password_gmail_provider.dart';

class ForgetPasswordGmail extends ConsumerStatefulWidget {
  const ForgetPasswordGmail({super.key});

  @override
  ConsumerState<ForgetPasswordGmail> createState() =>
      _ForgetPasswordGmailState();
}

class _ForgetPasswordGmailState extends ConsumerState<ForgetPasswordGmail> {
  late TextEditingController emailController;
  late TextEditingController otpController;
  late GlobalKey<FormState> formKey;

  String token = "";

  int secondsRemaining = 0;
  Timer? timer;
  bool isResend = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    otpController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  /// ================= SEND CODE =================
  Future<void> sendCode() async {
    if (emailController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Enter email or phone");
      return;
    }

    final responseToken = await ref
        .read(forgetPasswordGmailProvider.notifier)
        .sendOtp(emailController.text.trim());

    if (responseToken.isNotEmpty) {
      token = responseToken;
      startTimer();
      AppSnackBar.instance.success("OTP sent successfully");
    } else {
      AppSnackBar.instance.error("Failed to send OTP");
    }
  }

  /// ================= VERIFY CODE =================
  Future<void> verifyCode() async {
    final otpText = otpController.text.trim();

    if (otpText.isEmpty) {
      AppSnackBar.instance.error("Enter OTP");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Email not found");
      return;
    }

    if (token.isEmpty) {
      AppSnackBar.instance.error("Session expired. Try again.");
      return;
    }

    final responseToken = await ref
        .read(forgetPasswordGmailProvider.notifier)
        .verifyOtp(
          email: emailController.text.trim(),
          token: token,
          otp: int.parse(otpController.text.trim()),
        );

    if (responseToken.isNotEmpty) {
      token = responseToken;

      AppRoutes.instance.pushNamed(AppRoutesKey.instance.recoverPassword);
    } else {
      AppSnackBar.instance.error("Invalid OTP");
    }
  }

  Future<void> resendCode() async {
    if (emailController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Enter email first");
      return;
    }

    final responseToken = await ref
        .read(forgetPasswordGmailProvider.notifier)
        .sendOtp(emailController.text.trim());

    if (responseToken.isNotEmpty) {
      token = responseToken;
      startTimer();
      AppSnackBar.instance.success("OTP resent successfully");
    } else {
      AppSnackBar.instance.error("Failed to resend OTP");
    }
  }

  /// ================= TIMER =================
  void startTimer() {
    setState(() {
      secondsRemaining = 180;
      isResend = true;
    });

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining <= 1) {
        t.cancel();
        setState(() {
          secondsRemaining = 0;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  /// ================= FORMAT =================
  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forgetPasswordGmailProvider);

    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          width: double.infinity,
          height: AppSize.size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDEE9F7), Colors.white, Color(0xFFDEE9F7)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Gap(height: 100),

                  AppImage(
                    path: AppAssertsIconsPath.instance.gidiraNameLogo,
                    width: 116,
                  ),

                  Gap(height: 40),

                  AppText(
                    text: 'Forget Password',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),

                  Gap(height: 12),

                  AppText(
                    text:
                        'Enter the email address or mobile phone number associated with your account.',
                    textAlign: TextAlign.center,
                    fontSize: 18,
                  ),

                  Gap(height: 30),

                  /// EMAIL
                  AppInputWidgetTwo(
                    title: "phone number/email",
                    controller: emailController,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter email or phone";
                      }
                      return null;
                    },
                  ),

                  /// SEND / RESEND
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (!isLoading)
                              ? () {
                                  if (token.isEmpty) {
                                    sendCode(); // প্রথমবার send
                                  } else {
                                    resendCode(); // resend OTP
                                  }
                                }
                              : null,
                          child: AppText(
                            text: secondsRemaining > 0
                                ? "Resend in ${formatTime(secondsRemaining)}"
                                : (token.isEmpty ? "SEND CODE" : "RESEND CODE"),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.instance.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// OTP
                  AppInputWidgetTwo(
                    title: "Code",
                    controller: otpController,
                    keyboardType: TextInputType.number,
                  ),

                  Gap(height: 30),

                  /// CONTINUE
                  AppButton(
                    title: "Continue",
                    trailing: Icons.arrow_forward,
                    onTap: isLoading ? null : verifyCode,
                    isLoading: isLoading,
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

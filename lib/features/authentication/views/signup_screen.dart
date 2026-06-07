import 'package:batteryqk_web_app/data/services/api_services.dart';
import 'package:batteryqk_web_app/features/authentication/models/user_data.dart';
import 'package:get/get.dart'; // add for .tr
import 'package:batteryqk_web_app/common/widgets/custom_text_button.dart';
import 'package:batteryqk_web_app/features/authentication/views/login_screen.dart';
import 'package:batteryqk_web_app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/widgets/built_social_button.dart';
import '../../../common/widgets/show_snack_bar.dart';
import '../../../data/services/firebase_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _fNameTEController = TextEditingController();
  final TextEditingController _lNameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthControllers authController = Get.put(AuthControllers());

  @override
  void dispose() {
    _fNameTEController.dispose();
    _lNameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    _confirmPTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'create_account'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColor.blackColor,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'create_account_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _fNameTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'FastName_required'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'first_name'.tr,
                    filled: true,
                    fillColor: Colors.blue.shade50,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lNameTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'LastName_required'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'last_name'.tr,
                    filled: true,
                    fillColor: Colors.blue.shade50,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email_required'.tr;
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(value)) {
                      return 'email_invalid'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'email'.tr,
                    filled: true,
                    fillColor: Colors.blue.shade50,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordTEController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'password_required'.tr;
                    }
                    if (value.length < 6) {
                      return 'password_length'
                          .tr; // Update your translation for this key
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'password'.tr,
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.blueColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPTEController,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'confirm_password_required'.tr;
                    }
                    if (value != _passwordTEController.text) {
                      return 'passwords_not_match'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'confirm_password'.tr,
                    filled: true,
                    fillColor: Colors.blue.shade50,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.blueColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleSignup(context);
                        final user = UserCreate(
                          fname: _fNameTEController.text,
                          lname: _lNameTEController.text,
                          email: _emailTEController.text.trim(),
                          password: _passwordTEController.text,
                          uid: UserCreate.generateUID(),
                        );
                        ApiService.createUser(user, context);
                        Get.to(() => LogInScreen());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      backgroundColor: AppColor.blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'sign_up'.tr,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: MyCustomTextButton(
                    text: 'already_have_account'.tr,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LogInScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    'or_continue_with'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSocialButton(
                      icon: FontAwesomeIcons.google,
                      onTap: () {
                        authController.googleSignIn();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSignup(BuildContext context) async {
    final email = _emailTEController.text.trim();
    final password = _passwordTEController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackbar(context, "error".tr, "email_pass_wrong".tr);
      return;
    }

    bool success = await authController.signUp(email, password, context);

    if (success) {
      Get.to(() => LogInScreen());
    }
  }
}

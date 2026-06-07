import 'dart:convert';

import 'package:batteryqk_web_app/common/widgets/show_snack_bar.dart';
import 'package:batteryqk_web_app/data/services/utility/urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/custom_bottom_navigation_bar.dart';
import '../../features/authentication/controllers/auth_controller.dart';

class AuthControllers extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Rxn<User> firebaseUser = Rxn<User>();
  RxBool isLoggedIn = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());

    ever(firebaseUser, (User? user) {
      isLoggedIn.value = user != null;
    });
  }

  Future<bool> signUp(String email,
      String password,
      BuildContext context,) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      showSnackbar(context, 'Sign Up Error'.tr, e
          .toString()
          .split('] ')
          .last);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email,
      String password,
      BuildContext context,) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showSnackbar(context, 'Success'.tr, 'login_success'.tr);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.'.tr;
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email.'.tr;
          break;
        case 'wrong-password':
          errorMessage = 'The password you entered is incorrect.'.tr;
          break;
        default:
          errorMessage = 'Login failed. Please try again.'.tr;
      }
      showSnackbar(context, 'Sign In Error'.tr, errorMessage);
    } catch (e) {
      showSnackbar(
        context,
        'Error'.tr,
        'Something went wrong. Please try again later.'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      isLoading.value = true;
      await _auth.signOut();
    } catch (e) {
      showSnackbar(context, 'Logout Error'.tr, e
          .toString()
          .split('] ')
          .last);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        showSnackbar(
          Get.context!,
          'Cancelled'.tr,
          'Google sign-in was cancelled'.tr,
        );
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String? email = user.email;
        final String? name = user.displayName;
        final String uid = user.uid;

        if (email == null || name == null) {
          showSnackbar(Get.context!, 'Error'.tr, 'Missing user information'.tr);
          return false;
        }

        final String fname = name
            .split(' ')
            .first;
        final String lname =
        name
            .split(' ')
            .length > 1
            ? name.split(' ').sublist(1).join(' ')
            : '';

        final String tempPassword =
            'E#1234'; // You can set a fixed or random password

        /// 1. Create User API
        final createResponse = await http.post(
          Uri.parse(Urls.userCreate),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "fname": fname,
            "lname": lname,
            "email": email,
            "password": tempPassword,
            "uid": uid,
          }),
        );

        final loginResponse = await http.post(
          Uri.parse(Urls.userLogin),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"email": email, "password": tempPassword}),
        );

        if (loginResponse.statusCode == 200) {
          final responseData = jsonDecode(loginResponse.body);
          final String? apiToken = responseData['token'];

          if (apiToken != null) {
            await AuthController.saveToken(apiToken);

            showSnackbar(
              Get.context!,
              'Success'.tr,
              'Logged in with Google'.tr,
            );
            Get.offAll(() => CustomBottomNavigationBar());
            return true;
          } else {
            showSnackbar(
              Get.context!,
              'Error'.tr,
              'Token missing in API response'.tr,
            );
          }
        } else {
          showSnackbar(
            Get.context!,
            'Login Failed'.tr,
            'Invalid credentials'.tr,
          );
        }
      } else {
        showSnackbar(Get.context!, 'Error'.tr, 'Firebase user not found'.tr);
      }
    } catch (e) {
      showSnackbar(Get.context!, 'Google Sign-In Error'.tr, e.toString());
    }

    return false;
  }
}

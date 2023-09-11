// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import 'package:timeless_love_app/services/focus_scope_service.dart';
import 'package:timeless_love_app/services/progress_indicator_service.dart';
import 'package:timeless_love_app/services/snackbar_service.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/app_title_widget.dart';
import '../widgets/input_widget.dart';
import '../services/navigator_service.dart';
import '../widgets/page_title_widget.dart';
import '../widgets/primary_text_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        showSnackbar(
            context: context,
            text: appLocale(context).snackbar_password_notmatch,
            type: SnackbarType.error);
        return;
      }
      showCircularProgressIndicator(context);
      unfocus(context);

      try {
        await AuthService.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        UserModel user = UserModel(
            uid: AuthService.currentUser!.uid,
            displayName: _nameController.text,
            email: _emailController.text);
        await ApiService.updateUserDetails(user: user);
        await AuthService.updateUserDisplayName(_nameController.text);
        // context.read<CurrentUserProvider>().userWithoutNotify = user;
        navigatorPop(context);

        showSnackbar(
          context: context,
          text: appLocale(context).snackbar_signedup_successful,
          type: SnackbarType.info,
        );

        navigatorPop(context);
      } on FirebaseAuthException catch (e) {
        navigatorPop(context);
        if (e.message != null) {
          showSnackbar(
            context: context,
            text: e.message.toString(),
            type: SnackbarType.error,
          );
        }
      } on FirebaseException catch (e) {
        if (e.message != null) {
          showSnackbar(
            context: context,
            text: e.message.toString(),
            type: SnackbarType.error,
          );
        }
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitleWidget(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const VerticalSpace(20),
                      PageTitleWidget(
                        text: appLocale(context).signup_title,
                      ),
                      const VerticalSpace(10),
                      InputWidget(
                        controller: _emailController,
                        hintText: appLocale(context).enter_email_hint,
                        labelText: appLocale(context).email,
                        icon: const Icon(Icons.mail),
                        obscureText: false,
                        required: true,
                      ),
                      const VerticalSpace(10),
                      InputWidget(
                        controller: _nameController,
                        hintText: appLocale(context).enter_name_hint,
                        labelText: appLocale(context).name,
                        icon: const Icon(Icons.lock),
                        obscureText: false,
                        required: true,
                      ),
                      const VerticalSpace(10),
                      InputWidget(
                        controller: _passwordController,
                        hintText: appLocale(context).enter_password_hint,
                        labelText: appLocale(context).password,
                        icon: const Icon(Icons.lock),
                        obscureText: true,
                        required: true,
                      ),
                      const VerticalSpace(10),
                      InputWidget(
                        controller: _confirmPasswordController,
                        hintText: appLocale(context).confirm_password_hint,
                        labelText: appLocale(context).confirm_password,
                        icon: const Icon(Icons.lock),
                        obscureText: true,
                        required: true,
                      ),
                      const VerticalSpace(10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _handleSignUp,
                          child: Text(
                            appLocale(context).signup_button,
                            style: GoogleFonts.raleway(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      appLocale(context).already_have_account,
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => navigatorPop(context),
                      child: PrimaryTextWidget(
                        text: appLocale(context).login_button_navigate,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

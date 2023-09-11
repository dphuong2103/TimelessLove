// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/screens/reset_password_screen.dart';
import 'package:timeless_love_app/screens/signup_screen.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/widgets/app_title_widget.dart';
import '../widgets/input_widget.dart';
import '../widgets/page_title_widget.dart';
import '../widgets/primary_text_widget.dart';
import '../widgets/vertical_space_widget.dart';

class LoginScreen extends StatefulWidget {
  final Function handleGoogleLogin;
  final Function(GlobalKey<FormState> formKey, String email, String password)
      handleLogin;

  const LoginScreen({
    super.key,
    required this.handleGoogleLogin,
    required this.handleLogin,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordRevealed = false;

  void _handleLogin() {
    widget.handleLogin(
        _formKey, _emailController.text, _passwordController.text);
  }

  Future _handleGoogleLogin() async {
    widget.handleGoogleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const AppTitleWidget(),
        centerTitle: true,
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
                        text: appLocale(context).login_title,
                      ),
                      const VerticalSpace(20),
                      InputWidget(
                        controller: _emailController,
                        hintText: appLocale(context).enter_email_hint,
                        labelText: appLocale(context).email,
                        icon: const Icon(Icons.mail),
                        obscureText: false,
                        required: true,
                      ),
                      const VerticalSpace(15),
                      InputWidget(
                        controller: _passwordController,
                        hintText: appLocale(context).enter_password_hint,
                        labelText: appLocale(context).password,
                        icon: const Icon(Icons.lock),
                        obscureText: !_passwordRevealed,
                        required: true,
                        suffixIcon: IconButton(
                          icon: !_passwordRevealed
                              ? const Icon(Icons.remove_red_eye_outlined)
                              : const Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _passwordRevealed = !_passwordRevealed;
                            });
                          },
                        ),
                      ),
                      const VerticalSpace(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => navigatorPush(
                              context,
                              const ResetPasswordScreen(),
                            ),
                            child: PrimaryTextWidget(
                              text: appLocale(context).forgot_password,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _handleLogin,
                            child: Text(
                              appLocale(context).login_button,
                              style: GoogleFonts.raleway(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 10.0),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  height: 36,
                                )),
                          ),
                          Text(
                            appLocale(context).or,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 20.0),
                                child: Divider(
                                  color: Colors.grey.shade700,
                                  height: 36,
                                )),
                          ),
                        ],
                      ),
                      const VerticalSpace(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          onTap: _handleGoogleLogin,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'lib/assets/images/google_logo.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  appLocale(context).google_login,
                                  style: GoogleFonts.raleway(
                                    fontSize: 18,
                                    // color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
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
                      appLocale(context).do_not_have_account,
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => navigatorPush(context, const SignUpScreen()),
                      child: PrimaryTextWidget(
                        text: appLocale(context).signup_button,
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

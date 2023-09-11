import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/services/progress_indicator_service.dart';
import 'package:timeless_love_app/services/snackbar_service.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';

import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailEditingController = TextEditingController();
  var _isButtonDisabled = true;

  Future<void> _sendPasswordResetEmail() async {
    showCircularProgressIndicator(context);
    try {
      await AuthService.sendPasswordResetEmail(_emailEditingController.text);
      if (context.mounted) {
        showSnackbar(
            context: context,
            text: 'Confirm email sent! Please check your Email',
            type: SnackbarType.info);
        navigatorPop(context);
        navigatorPop(context);
      }
    } on FirebaseException catch (e) {
      navigatorPop(context);
      showSnackbar(
        context: context,
        text: e.toString(),
        type: SnackbarType.error,
      );
    } catch (e) {
      navigatorPop(context);
      showSnackbar(
        context: context,
        text: e.toString(),
        type: SnackbarType.error,
      );
    }
  }

  @override
  void initState() {
    _emailEditingController.addListener(() {
      _emailEditingController.text.isEmpty
          ? setState(() {
              _isButtonDisabled = true;
            })
          : setState(() {
              _isButtonDisabled = false;
            });
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please enter the email you used to register',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const VerticalSpace(10),
              TextFormField(
                controller: _emailEditingController,
                decoration: InputDecoration(
                  hintText: 'Input Email',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const VerticalSpace(10),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _isButtonDisabled ? null : _sendPasswordResetEmail,
                  child: const Text(
                    'Send confirmation email',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

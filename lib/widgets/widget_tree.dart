import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeless_love_app/screens/login_screen.dart';
import 'package:timeless_love_app/widgets/home_screen_widget_tree.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/focus_scope_service.dart';
import '../services/navigator_service.dart';
import '../services/progress_indicator_service.dart';
import '../services/snackbar_service.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  Future<void> _handleGoogleLogin() async {
    {
      try {
        await AuthService.signInWithGoogle();
        UserModel user = UserModel(
          uid: AuthService.currentUser!.uid,
          displayName: AuthService.currentUser!.displayName,
          email: AuthService.currentUser!.email!,
          photoURL: AuthService.currentUser!.photoURL,
        );
        await ApiService.updateUserUserDetailField(user.toJson());
      } on FirebaseAuthException catch (e) {
        if (e.message != null && e.message!.isNotEmpty) {
          showSnackbar(
            context: context,
            text: e.message.toString(),
            type: SnackbarType.error,
          );
        }
      } catch (e) {
        debugPrint('Error $e');
        if (context.mounted) {
          showSnackbar(
            context: context,
            text: e.toString(),
            type: SnackbarType.error,
          );
        }
      } finally {}
    }
  }

  Future<void> _handleLogin(
      GlobalKey<FormState> formKey, String email, String password) async {
    if (formKey.currentState!.validate()) {
      unfocus(context);
      showCircularProgressIndicator(context);
      try {
        await AuthService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (context.mounted) {
          navigatorPop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (e.message != null) {
          navigatorPop(context);
          showSnackbar(
            context: context,
            text: e.message.toString(),
            type: SnackbarType.error,
          );
        }
      } catch (e) {
        navigatorPop(context);
        showSnackbar(
          context: context,
          text: e.toString(),
          type: SnackbarType.error,
        );
      } finally {}
    }
  }

  final _authStateChange = AuthService.authStateChanges;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _authStateChange,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text('Loading...');
            case ConnectionState.done:
            case ConnectionState.active:
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return LoginScreen(
                  handleGoogleLogin: _handleGoogleLogin,
                  handleLogin: _handleLogin,
                );
              } else if (snapshot.data != null) {
                return const HomeScreenWidgetTree();
              } else {
                return const Text('Loading...');
              }
            case ConnectionState.none:
              return ElevatedButton(
                child: const Text('Error'),
                onPressed: () {
                  AuthService.signOut(context);
                },
              );
            default:
              return ElevatedButton(
                child: Text(snapshot.connectionState.toString()),
                onPressed: () {
                  AuthService.signOut(context);
                },
              );
          }
        });
  }
}

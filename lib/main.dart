import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timeless_love_app/providers/current_user_provider.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import 'package:timeless_love_app/screens/select_language_screen.dart';

import 'package:timeless_love_app/theme/theme_manager.dart';
import 'package:timeless_love_app/widgets/share_preference.dart';
import 'package:timeless_love_app/widgets/widget_tree.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'models/language.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'TimelessLove Channel id',
  'TimelessLove Notifications',
  description: 'This channel is used for sending new question notification',
  importance: Importance.defaultImportance,
  playSound: true,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharePreference.initiatePreference();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RelationshipProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentUserProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initAwesomeNotification() async {
  Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == 'true') {
      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => const WidgetTree()));
    }
  }

  await AwesomeNotifications()
      .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  await AwesomeNotifications()
      .setListeners(onActionReceivedMethod: onActionReceivedMethod);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  Language _language = Language.english;
  Locale? _locale;

  void _handleSelectLanguage(Language? selectedLanguage) {
    setState(() {
      if (selectedLanguage != null) {
        _language = selectedLanguage;
      }
    });
  }

  void setLocale(Locale newLocale) {
    SharePreference.pref
        .setString(SharePreference.prefNameLocale, newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  Future<void> _handleFinishAnswering() async {
    await SharePreference.pref
        .setString(SharePreference.prefNameLocale, _language.code);
    setState(() {});
  }

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    var languageString =
        SharePreference.pref.getString(SharePreference.prefNameLocale);
    if (languageString != null) {
      _locale = Locale(languageString, '');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var languageString =
        SharePreference.pref.getString(SharePreference.prefNameLocale);
    if (languageString != null) {
      _locale = Locale(languageString, '');
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timeless Love',
      theme: ThemeManager().lightTheme,
      themeMode: ThemeManager().themeMode,
      home: _locale == null
          ? SelectLanguageScreen(
              handleSelectLanguage: _handleSelectLanguage,
              handleFinishAnswering: _handleFinishAnswering,
              language: _language)
          : const WidgetTree(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: _locale,
    );
  }
}

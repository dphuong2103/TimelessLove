import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:timeless_love_app/screens/home_screen_tabs/home_screen_list_tab.dart';
import 'package:timeless_love_app/screens/home_screen_tabs/home_screen_main_tab.dart';
import 'package:timeless_love_app/screens/home_screen_tabs/home_screen_setting_tab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import 'package:timeless_love_app/widgets/app_title_widget.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import '../services/get_language_text.dart';
import '../services/navigator_service.dart';
import '../services/snackbar_service.dart';
import '../widgets/answer_question_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _questionNumber;

  int _selectedIndex = 0;
  _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future getToken() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      debugPrint('Token: $token');
      await ApiService.updateUserUserDetailField({'fmToken': token});
    });
  }

  String? _appTitle() {
    switch (_selectedIndex) {
      case 0:
        return null;
      case 1:
        return appLocale(context).homescreen_tab_title_list;
      case 2:
        return appLocale(context).homescreen_tab_title_setting;
      default:
        return null;
    }
  }

  late final List<Widget> _tabs;

  final List<String> _bottomNavigationBarItemPaths = [
    'lib/assets/images/heart.svg',
    'lib/assets/images/note-book.svg',
    'lib/assets/images/many-hearts.svg'
  ];
  Future<void> initFirebaseMessage(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
      announcement: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined permission');
    }

    FirebaseMessaging.onMessage.listen(
        (message) => {_firebaseMessagingForegroundHandler(message, context)});
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message, BuildContext context) async {
    showSnackbar(
        context: context,
        text: appLocale(context).homescreen_question_new_question_summary,
        type: SnackbarType.info);

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
    }
  }

  void _setQuestionNumber(int questionNumber) {
    _questionNumber = questionNumber;
  }

  @override
  void initState() {
    _tabs = [
      const HomeScreenMainTab(),
      HomeScreenListTab(
        setQuestionNumber: _setQuestionNumber,
      ),
      const HomeScreenSettingTab()
    ];
    initFirebaseMessage(context);
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleFloatingActionButtonClick() {
    navigatorPush(
        context,
        AnswerQuestionWidget(
          type: UpdateQuestionType.add,
          questionNumber: _questionNumber ?? 1,
          question: Question(
            question: '',
            createdAt: DateTime.now(),
            createdBy: AuthService.currentUser?.uid ?? '',
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTitleWidget(
          appTitle: _appTitle(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _handleFloatingActionButtonClick,
              backgroundColor: const Color.fromRGBO(127, 209, 174, 1),
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            )
          : Container(),
    );
  }

  BottomNavigationBar _bottomNavigationBar() => BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: _bottomNavigationBarItemPaths.map((itemPath) {
          return BottomNavigationBarItem(
            label: '',
            icon: SvgPicture.asset(
              itemPath,
              width: 25,
              height: 25,
              colorFilter: _selectedIndex !=
                      _bottomNavigationBarItemPaths.indexOf(itemPath)
                  ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                  : null,
            ),
          );
        }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _navigateBottomBar,
      );
}

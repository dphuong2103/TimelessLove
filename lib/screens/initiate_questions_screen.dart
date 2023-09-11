import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timeless_love_app/screens/initiate_question_tabs/dating_time_question_tab.dart';
import 'package:timeless_love_app/screens/initiate_question_tabs/gender_question_tab.dart';
import 'package:timeless_love_app/services/format_datetime.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import 'package:timeless_love_app/widgets/app_title_widget.dart';
import '../models/user.dart';
import 'initiate_question_tabs/birthdate_question_tab.dart';
import 'initiate_question_tabs/initiate_screen_question_tab.dart';

class InitiateScreen extends StatefulWidget {
  final Function(DateTime startDate, DateTime birthDate, String gender)
      handleFinishAnswering;
  const InitiateScreen({
    super.key,
    required this.handleFinishAnswering,
  });

  @override
  State<InitiateScreen> createState() => _InitiateScreenState();
}

class _InitiateScreenState extends State<InitiateScreen> {
  DateTime _birthDate = DateTime.now();
  DateTime _startDatingDate = DateTime.now();
  Gender _gender = Gender.male;
  int _pageIndex = 0;
  final _pageController = PageController(
    initialPage: 0,
  );
  final double _arrowVerticalPosition = 250;
  final double _arrowHorizontalPosition = 30;

  void _nextPage() {
    _pageController.animateToPage(
      _pageController.page!.toInt() + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void _previousPage() {
    _pageController.animateToPage(
      _pageController.page!.toInt() - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void _onPageChange(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  void _handleSelectBirthDay(DateTime newDate, List<int> int) {
    setState(() {
      _birthDate = newDate;
    });
  }

  void _handleSelectStartDatingDate(DateTime newDate, List<int> int) {
    setState(() {
      _startDatingDate = newDate;
    });
  }

  void _handleFinishAnswering() {
    // UserModel? currentUser = context.read<CurrentUserProvider>().currentUser;
    // if (currentUser != null) {
    //   currentUser.birthDate = _birthDate;
    //   context.read<CurrentUserProvider>().currentUser = currentUser;
    // }
    widget.handleFinishAnswering(_startDatingDate, _birthDate, _gender.name);
  }

  void _handleSelectGender(Gender? selectedGender) {
    if (selectedGender != null) {
      setState(() {
        _gender = selectedGender;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pageViewChildren = [
      InitiateScreenQuestionTab(
        mainQuestion: appLocale(context).birthday_question,
        description: appLocale(context).display_on_anniversary,
        child: BirthDateQuestionTab(
          birthDay: formatDateVnLocale(_birthDate),
          handleSelectBirthDay: _handleSelectBirthDay,
        ),
      ),
      InitiateScreenQuestionTab(
          mainQuestion: appLocale(context).start_dating_day_question,
          description: appLocale(context).display_on_anniversary,
          child: DatingTimeQuestionTab(
            handleSelectStartDatingDate: _handleSelectStartDatingDate,
            startDatingDate: formatDateVnLocale(_startDatingDate),
          )),
      InitiateScreenQuestionTab(
        mainQuestion: appLocale(context).gender_question,
        child: GenderQuestionTab(
          handleSelectGender: _handleSelectGender,
          gender: _gender,
          handleFinishAnswering: _handleFinishAnswering,
        ),
      ),
    ];

    Widget rightArrow() {
      if (_pageIndex != pageViewChildren.length - 1) {
        return Positioned(
          right: _arrowHorizontalPosition,
          bottom: _arrowVerticalPosition,
          child: GestureDetector(
            onTap: _nextPage,
            child: SvgPicture.asset(
              'lib/assets/images/right-arrow.svg',
              width: 30,
              height: 30,
            ),
          ),
        );
      }
      return Container();
    }

    Widget leftArrow() {
      if (_pageIndex != 0) {
        return Positioned(
          left: _arrowHorizontalPosition,
          bottom: _arrowVerticalPosition,
          child: Transform.scale(
            scaleX: -1,
            child: GestureDetector(
              onTap: _previousPage,
              child: SvgPicture.asset(
                'lib/assets/images/right-arrow.svg',
                width: 30,
                height: 30,
              ),
            ),
          ),
        );
      }
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: const AppTitleWidget(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: _onPageChange,
              children: pageViewChildren,
            ),
            rightArrow(),
            leftArrow(),
          ],
        ),
      ),
    );
  }
}

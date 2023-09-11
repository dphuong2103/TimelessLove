// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/providers/current_user_provider.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import 'package:timeless_love_app/screens/initiate_question_tabs/initiate_screen_question_tab.dart';
import 'package:timeless_love_app/services/alert_dialog_service.dart';
import 'package:timeless_love_app/services/api_service.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import 'package:timeless_love_app/services/get_relationship_service.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/services/progress_indicator_service.dart';
import 'package:timeless_love_app/widgets/app_title_widget.dart';
import 'package:provider/provider.dart';
import 'package:timeless_love_app/widgets/edit_birthday_widget.dart';
import 'package:timeless_love_app/widgets/edit_datingdate_widget.dart';
import 'package:timeless_love_app/widgets/edit_display_name_widget.dart';
import 'package:timeless_love_app/widgets/horizontal_space_widget.dart';

import '../models/user.dart';
import '../services/focus_scope_service.dart';
import '../services/format_datetime.dart';
import '../services/get_language_text.dart';

class CoupleSettingScreen extends StatefulWidget {
  final Function(DateTime, BuildContext) handleSubmitStartDateChange;
  const CoupleSettingScreen(
      {super.key, required this.handleSubmitStartDateChange});

  @override
  State<CoupleSettingScreen> createState() => _CoupleSettingScreenState();
}

class _CoupleSettingScreenState extends State<CoupleSettingScreen> {
  String _userDisplayName = '';

  void _showDatePicker() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: InitiateScreenQuestionTab(
            mainQuestion: appLocale(context).screen_couple_select_start_date,
            child: EditDatingDateWidget(
              handleSubmitStartDateChange: widget.handleSubmitStartDateChange,
              startDate:
                  context.watch<RelationshipProvider>().relationship!.startDate,
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmitBirthdayChange(
      DateTime newBirthDay, BuildContext context) async {
    unfocus(context);
    try {
      showCircularProgressIndicator(context);
      var currentUser = context.read<CurrentUserProvider>().currentUser;
      if (currentUser != null) {
        debugPrint('Birthday change');
        currentUser.birthDate = newBirthDay;
        context.read<CurrentUserProvider>().currentUser = currentUser;
      }
      await ApiService.updateUserUserDetailField(
          {'birthDate': currentUser!.birthDate});
      navigatorPop(context);
      unfocus(context);
      navigatorPop(context);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  void _showBirthdayPicker() {
    navigatorPop(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: InitiateScreenQuestionTab(
            mainQuestion: appLocale(context).screen_couple_change_birthday,
            child: EditBirthdayWidget(
              handleSubmitBirthDayChange: _handleSubmitBirthdayChange,
              birthDay:
                  context.watch<CurrentUserProvider>().currentUser?.birthDate ??
                      DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  void _handleDisconnectionFromRelationship() {
    Future<void> saveAnswer() async {
      if (context.mounted) {
        var disConnectFromRelationshipStatus =
            await ApiService.disconnectionFromRelationship(context);
        switch (disConnectFromRelationshipStatus) {
          case DisconnectFromRelationship.done:
            {
              context.read<RelationshipProvider>().relationshipWithoutNotify =
                  null;
              AuthService.signOut(context);
              navigatorPop(context);
              navigatorPop(context);
              break;
            }
          case DisconnectFromRelationship.error:
            break;
        }
      }
    }

    handleShowConfirmDialog(
      context,
      text: appLocale(context).dialog_confirm_disconnection_from_relationship,
      handleOkClick: saveAnswer,
    );
  }

  void _handleUserDisplayNameOnChange(String newUserName) {
    setState(() {
      _userDisplayName = newUserName;
    });
  }

  Future _handleSubmitChangeName() async {
    if (_userDisplayName.isEmpty) {
      return null;
    }
    unfocus(context);
    try {
      showCircularProgressIndicator(context);
      var currentUser = context.read<CurrentUserProvider>().currentUser;
      if (currentUser != null) {
        debugPrint('Name change');
        currentUser.displayName = _userDisplayName;
        context.read<CurrentUserProvider>().currentUser = currentUser;
      }
      await ApiService.updateUserUserDetailField(
          {'displayName': _userDisplayName});
      navigatorPop(context);
      unfocus(context);
      navigatorPop(context);
    } catch (err) {
      navigatorPop(context);
      debugPrint(err.toString());
    }
  }

  void _showBottomModalOnEdit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(children: [
          ListTile(
            title: Text(appLocale(context).screen_couple_change_name),
            onTap: _showBottomModalEitUserDisplayName,
          ),
          ListTile(
            title: Text(appLocale(context).screen_couple_change_birthday),
            onTap: _showBirthdayPicker,
          ),
          ListTile(
            title: Text(appLocale(context).cancel),
            onTap: () => navigatorPop(context),
          ),
        ]);
      },
    );
  }

  void _showBottomModalEitUserDisplayName() {
    navigatorPop(context);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: InitiateScreenQuestionTab(
            mainQuestion: appLocale(context).screen_couple_change_display_name,
            child: EditDisplayNameWidget(
              userName: _userDisplayName,
              handleUserNameOnChange: _handleUserDisplayNameOnChange,
              handleSubmitChangeName: _handleSubmitChangeName,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _userDisplayName =
        context.read<CurrentUserProvider>().currentUser?.displayName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var partner = watchRelationship(context)?.partner;
    var currentUser = context.watch<CurrentUserProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTitleWidget(
          appTitle: appLocale(context).screen_couple_title,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: _showDatePicker,
              title: Text(
                appLocale(context).screen_couple_anniversary,
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: SvgPicture.asset(
                'lib/assets/images/2rings.svg',
                width: 30,
                height: 30,
              ),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    formatDateVnLocale(
                      context
                          .watch<RelationshipProvider>()
                          .relationship!
                          .startDate,
                    ),
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const HorizontalSpace(10),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: _handleDisconnectionFromRelationship,
              title: Text(
                appLocale(context).screen_couple_disconnect_from_relationship,
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: Image.asset(
                'lib/assets/images/broken-heart.png',
                width: 30,
                height: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                appLocale(context).information,
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              onTap: null,
              title: Text(
                currentUser?.displayName ?? '',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: currentUser!.birthDate != null
                  ? Text(formatDateVnLocale(currentUser.birthDate!))
                  : null,
              leading: Icon(
                currentUser.gender == Gender.male ? Icons.male : Icons.female,
                size: 30,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _showBottomModalOnEdit,
              ),
            ),
            partner != null
                ? ListTile(
                    onTap: null,
                    title: Text(
                      partner.displayName ?? '',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(formatDateVnLocale(partner.birthDate!)),
                    leading: Icon(
                      partner.gender == Gender.male ? Icons.male : Icons.female,
                      size: 30,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

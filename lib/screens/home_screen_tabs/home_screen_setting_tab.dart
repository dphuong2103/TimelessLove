import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/main.dart';
import 'package:timeless_love_app/providers/current_user_provider.dart';
import 'package:timeless_love_app/screens/couple_setting_screen.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import 'package:timeless_love_app/services/confirm_dialog_service.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/services/progress_indicator_service.dart';
import 'package:timeless_love_app/widgets/horizontal_space_widget.dart';
import '../../models/language.dart';
import '../../providers/relationship_provider.dart';
import '../../services/api_service.dart';
import '../../services/connection_info_modal.dart';
import '../../services/snackbar_service.dart';
import '../../widgets/vertical_space_widget.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';

class HomeScreenSettingTab extends StatefulWidget {
  const HomeScreenSettingTab({super.key});

  @override
  State<HomeScreenSettingTab> createState() => _HomeScreenSettingTabState();
}

class _HomeScreenSettingTabState extends State<HomeScreenSettingTab> {
  Future<void> _handleSignOut(BuildContext context) async {
    var okToSignOut = await confirmDialog(context,
        text: appLocale(context).dialog_confirm_logout);
    if (okToSignOut != null) {
      switch (okToSignOut) {
        case ConfirmDialogResult.ok:
          if (context.mounted) {
            showCircularProgressIndicator(context);
            await AuthService.signOut(context);
            // ignore: use_build_context_synchronously
            navigatorPop(context);
          }

          break;
        case ConfirmDialogResult.cancel:
          return;
      }
    }
  }

  Future<void> _handleSubmitStartDateChange(
      DateTime startDate, BuildContext modalContext) async {
    try {
      var relationship = context.read<RelationshipProvider>().relationship;
      relationship!.startDate = startDate;
      await ApiService.updateRelationshipDetails(relationship);
      if (context.mounted) {
        context.read<RelationshipProvider>().relationship = relationship;
        showSnackbar(
            context: context,
            text: appLocale(context).snackbar_startdate_changed,
            type: SnackbarType.info);
        navigatorPop(modalContext);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _selectLanguageDialog(BuildContext context) async {
    List<SimpleDialogOption> languageListOptions = Language.languageList()
        .map((language) => SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, language);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${language.icon}   ${language.name}'),
              ),
            ))
        .toList();
    var language = await showDialog<Language>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: languageListOptions,
          );
        });
    if (language != null) {
      if (context.mounted) {
        MyApp.setLocale(context, Locale(language.code, ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var daysInRelationship = DateTime.now()
            .difference(
                context.watch<RelationshipProvider>().relationship!.startDate)
            .inDays +
        1;

    var partnerName = context
        .watch<RelationshipProvider>()
        .relationship
        ?.partner
        ?.displayName;

    var currentUser = context.watch<CurrentUserProvider>().currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'lib/assets/images/love-potion.jpg',
              width: 100,
              height: 100,
            ),
          ),
        ),
        const VerticalSpace(20),
        Stack(
          children: [
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inconsolata(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: appLocale(context).homescreen_together_for),
                      TextSpan(text: ' ${daysInRelationship.toString()}'),
                      TextSpan(text: ' ${appLocale(context).homescreen_days}'),
                    ],
                  ),
                ),
                const VerticalSpace(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentUser?.displayName ?? '',
                      style: GoogleFonts.inconsolata(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const HorizontalSpace(10),
                    Image.asset(
                      'lib/assets/images/heart.png',
                      width: 30,
                      height: 30,
                    ),
                    const HorizontalSpace(10),
                    GestureDetector(
                      onTap: () => showConnectionInfo(context),
                      child: Text(
                        partnerName ?? 'My love',
                        style: GoogleFonts.inconsolata(
                          fontSize: 24,
                          color: Colors.black,
                          decoration: partnerName == null
                              ? TextDecoration.underline
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () => navigatorPush(
                  context,
                  CoupleSettingScreen(
                    handleSubmitStartDateChange: _handleSubmitStartDateChange,
                  ),
                ),
              ),
            )
          ],
        ),
        const VerticalSpace(20),
        Flexible(
          child: SettingsList(
            sections: [
              SettingsSection(
                // title: const Text('Contact us'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.contact_emergency),
                    title: Text(
                      appLocale(context).homescreen_setting_tab_contact_us,
                      style: GoogleFonts.inconsolata(fontSize: 20),
                    ),
                    onPressed: (context) {},
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(
                      Icons.language,
                    ),
                    title: Text(
                      appLocale(context).homescreen_setting_tab_change_language,
                      style: GoogleFonts.inconsolata(fontSize: 20),
                    ),
                    onPressed: _selectLanguageDialog,
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.logout),
                    title: Text(
                      appLocale(context).homescreen_setting_tab_sign_out,
                      style: GoogleFonts.inconsolata(fontSize: 20),
                    ),
                    onPressed: _handleSignOut,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

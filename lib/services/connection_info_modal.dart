import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import 'package:timeless_love_app/services/api_service.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/services/snackbar_service.dart';
import 'package:share_plus/share_plus.dart';
import 'get_relationship_service.dart';
import 'package:provider/provider.dart';

Future<void> _handleCopyConnectionCode(BuildContext context) async {
  debugPrint('copied start');
  await Clipboard.setData(
    ClipboardData(text: readRelationship(context)?.id ?? ''),
  );
  debugPrint('copied done');
}

void handleSendInvitation(BuildContext context) {
  Share.share(
      "Check out Timeless Love https://play.google.com/store/apps/details?id=com.midouz.timeless_love_app, let' store memories together!. My connection code: ${readRelationship(context)?.id}");
}

void showConnectionInfo(BuildContext context) {
  if (context.read<RelationshipProvider>().relationship?.partner != null) {
    return;
  }
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                appLocale(context).screen_connection_info_title,
                textAlign: TextAlign.center,
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  color: Colors.grey.shade500,
                  letterSpacing: 1,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'lib/assets/images/love-box.png',
                height: 300,
              ),
              Text(
                appLocale(context).screen_connection_info_copy_couple_code,
                style: GoogleFonts.raleway(
                  fontSize: 17,
                  color: Colors.grey.shade500,
                  letterSpacing: 1,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _handleCopyConnectionCode(context);
                },
                child: Text(
                  readRelationship(context)?.id ?? '',
                  style: GoogleFonts.raleway(
                    fontSize: 17,
                    color: Colors.grey.shade700,
                    letterSpacing: 1,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(197, 182, 151, 1),
                ),
                onPressed: () => handleSendInvitation(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 50,
                  ),
                  child: Text(
                    appLocale(context)
                        .screen_connection_info_button_send_invitation,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
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
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.grey.shade700,
                          height: 36,
                        )),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Color.fromRGBO(197, 182, 151, 1),
                    ),
                  ),
                ),
                onPressed: () {
                  _showInputConnectionModal(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Text(
                    appLocale(context)
                        .screen_connection_info_button_connect_partner_code,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showInputConnectionModal(BuildContext context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext modalContext) {
      String connectionCode = '';
      bool connectionButtonDisable = true;
      return Scaffold(
        //StatefulBuilder to allow setState function
        body: StatefulBuilder(builder: (modalContext, setInnerState) {
          void handleInputCodeChange(String? text) {
            debugPrint(text);
            if (text != null) {
              if (text.isNotEmpty) {
                connectionCode = text;
                setInnerState(() {
                  connectionButtonDisable = false;
                });
              } else {
                setInnerState(() {
                  connectionButtonDisable = true;
                });
              }
            }
          }

          Future<void> handleConnect(BuildContext builderContext) async {
            var connectionResult =
                await ApiService.connectionRequest(connectionCode, context);
            debugPrint(connectionResult.name);
            switch (connectionResult) {
              case ConnectionRequestResult.relationshipNotFound:
                {
                  if (context.mounted) {
                    showSnackbarWithoutFloating(
                        context: builderContext,
                        text:
                            appLocale(context).snackbar_invalid_connection_code,
                        type: SnackbarType.error);
                  }
                  break;
                }
              case ConnectionRequestResult.error:
                {
                  if (context.mounted) {
                    showSnackbarWithoutFloating(
                        context: builderContext,
                        text:
                            appLocale(context).snackbar_invalid_connection_code,
                        type: SnackbarType.error);
                  }
                  break;
                }
              case ConnectionRequestResult.alreadyInRelationship:
                {
                  if (context.mounted) {
                    showSnackbarWithoutFloating(
                        context: context,
                        text:
                            appLocale(context).snackbar_partner_in_relationship,
                        type: SnackbarType.warning);
                  }
                  break;
                }

              case ConnectionRequestResult.inputSelfRelationship:
                {
                  if (context.mounted) {
                    showSnackbarWithoutFloating(
                        context: context,
                        text: appLocale(context).snackbar_self_connection_code,
                        type: SnackbarType.warning);
                  }
                  break;
                }
              case ConnectionRequestResult.done:
                {
                  if (context.mounted) {
                    showSnackbarWithoutFloating(
                        context: context,
                        text: appLocale(context).snackbar_connected,
                        type: SnackbarType.info);
                    navigatorPop(modalContext);
                    navigatorPop(context);
                  }
                  break;
                }
            }
          }

          //Builder to allow snackbar to be displayed
          return Builder(builder: (builderContext) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    appLocale(context).screen_enter_connection_title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      letterSpacing: 1,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: TextFormField(
                      initialValue: connectionCode,
                      onChanged: handleInputCodeChange,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText:
                            appLocale(context).screen_enter_connection_hint,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: GoogleFonts.raleway(
                          fontSize: 20,
                          color: Colors.grey.shade500,
                          letterSpacing: 1,
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Color.fromRGBO(197, 182, 151, 1),
                        ),
                      ),
                    ),
                    onPressed: connectionButtonDisable
                        ? null
                        : () => handleConnect(builderContext),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: Text(
                        appLocale(context)
                            .screen_enter_connection_button_connect,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        }),
      );
    },
  );
}

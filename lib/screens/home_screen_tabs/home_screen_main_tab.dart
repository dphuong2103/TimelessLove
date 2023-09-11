import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/widgets/horizontal_space_widget.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/relationship_provider.dart';
import '../../services/connection_info_modal.dart';
import '../../services/get_language_text.dart';

class HomeScreenMainTab extends StatefulWidget {
  const HomeScreenMainTab({
    super.key,
  });

  @override
  State<HomeScreenMainTab> createState() => _HomeScreenMainTabState();
}

class _HomeScreenMainTabState extends State<HomeScreenMainTab> {
  late int _daysInRelationship;
  late String? _partnerName;

  @override
  Widget build(BuildContext context) {
    var currentUser = context.watch<CurrentUserProvider>().currentUser;
    _daysInRelationship = DateTime.now()
            .difference(
                context.watch<RelationshipProvider>().relationship!.startDate)
            .inDays +
        1;

    _partnerName = context
        .watch<RelationshipProvider>()
        .relationship!
        .partner
        ?.displayName;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(26),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(194, 221, 230, 1),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Text(
                        currentUser?.displayName ?? '',
                        style: GoogleFonts.inconsolata(
                          fontSize: 24,
                        ),
                      ),
                      const HorizontalSpace(16),
                      SvgPicture.asset(
                        'lib/assets/images/heart2.svg',
                        width: 40,
                        height: 40,
                      ),
                      const HorizontalSpace(16),
                      GestureDetector(
                        onTap: () => showConnectionInfo(context),
                        child: Text(
                          _partnerName ?? 'My love',
                          style: GoogleFonts.inconsolata(
                            fontSize: 24,
                            decoration: _partnerName == null
                                ? TextDecoration.underline
                                : null,
                            fontStyle:
                                _partnerName == null ? FontStyle.italic : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(15),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: appLocale(context).homescreen_together_for,
                          style: GoogleFonts.inconsolata(
                            fontSize: 32,
                          ),
                        ),
                        TextSpan(
                          text: ' ${_daysInRelationship.toString()} ',
                          style: GoogleFonts.dancingScript(
                            fontSize: 32,
                          ),
                        ),
                        TextSpan(
                          text: appLocale(context).homescreen_days,
                          style: GoogleFonts.inconsolata(
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            'lib/assets/images/smiley-heart.png',
            width: 70,
            scale: 1,
          ),
        ],
      ),
    );
  }
}

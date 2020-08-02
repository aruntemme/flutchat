import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mdi/mdi.dart';
import 'package:flutchat/Layout/themeSettingsPage.dart';
import 'package:flutchat/consts/theme.dart';
import 'package:flutchat/message/imageFullScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../user/editProfile.dart';
import '../mainRepo.dart';
import '../user/user.dart';
import '../data/sharedPrefs.dart';
import '../Layout/signOutConfirmationDialog.dart';
import '../appData.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var height, width;
  User user;
  bool isLoading = true;
  _getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    print("getting user ");
    user = await mainRepo
        .getUserFromUid(sharedPrefs.getValueFromSharedPrefs('uid'));
    setUser(user);
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return BottomAppBar(
      elevation: 0,
      color: AppTheme.accentColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 56.0,
        child: Row(children: <Widget>[
          IconButton(
            onPressed: showMenu,
            icon: Icon(Icons.menu),
            color: AppTheme.iconColor,
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
            color: AppTheme.iconColor,
          )
        ]),
      ),
    );
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(color: AppTheme.accentColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 36,
                ),
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: AppTheme.defaultColor,
                        ),
                        child: Stack(
                          alignment: Alignment(0, 0),
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              top: -36,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(120)),
                                    border: Border.all(
                                        color: AppTheme.accentColor,
                                        width: 10)),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (user != null) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageFullScreen(
                                                        user.imageUrl)));
                                      }
                                    },
                                    child: _buildUserImage(context),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Inbox",
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    leading: Icon(
                                      Icons.inbox,
                                      color: AppTheme.textColor,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Starred",
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    leading: Icon(
                                      Icons.star_border,
                                      color: AppTheme.textColor,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Sent",
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    leading: Icon(
                                      Icons.send,
                                      color: AppTheme.textColor,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Trash",
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    leading: Icon(
                                      Icons.delete_outline,
                                      color: AppTheme.textColor,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Spam",
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    leading: Icon(
                                      Icons.error,
                                      color: AppTheme.textColor,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Drafts",
                                      style:
                                          TextStyle(color: AppTheme.textColor),
                                    ),
                                    leading: Icon(
                                      Icons.mail_outline,
                                      color: AppTheme.textColor,
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
                Container(
                  height: 56,
                  color: Color(0xff4a6572),
                )
              ],
            ),
          );
        });
  }

  _buildUserImage(BuildContext context) {
    return user != null
        ? ValueListenableBuilder(
            valueListenable: userData,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(120.0),
                child: Container(
                  height: 60,
                  width: 60,
                  color: AppTheme.mainColor,
                  child: CachedNetworkImage(
                      fadeInDuration: Duration(microseconds: 100),
                      imageUrl: value != null ? value.imageUrl : " ",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          Icon(Mdi.alert, color: AppTheme.iconColor),
                      placeholder: (context, url) => Shimmer.fromColors(
                          child: Container(
                            color: Colors.red,
                          ),
                          baseColor: AppTheme.shimmerBaseColor,
                          highlightColor: AppTheme.shimmerEndingColor)),
                ),
              );
            },
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(120.0),
            child: Shimmer.fromColors(
              baseColor: AppTheme.shimmerBaseColor,
              highlightColor: AppTheme.shimmerEndingColor,
              child: Container(
                height: 60,
                width: 60,
                color: Colors.red,
              ),
            ),
          );
  }
}

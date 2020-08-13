import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutchat/user/userInfoPage.dart';
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
    setState(() {
      isLoading = false;
    });
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
      shape: CircularNotchedRectangle(),
      elevation: 5,
      color: AppTheme.accentColor,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        height: 55,
        child: Row(children: <Widget>[
          IconButton(
            onPressed: showMenu,
            icon: Icon(Mdi.menuUpOutline),
            color: AppTheme.iconHome,
          ),
          Spacer(),
          Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(120.0),
                  child: Container(
                      height: 0.06 * height,
                      width: 0.06 * height,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(120.0),
                          child: Stack(children: <Widget>[
                            Positioned.fill(
                              child: ValueListenableBuilder(
                                valueListenable: userData,
                                builder: (context, User value, child) {
                                  return Hero(
                                    tag: 'userImage',
                                    child: Container(
                                      //color: Theme.of(context).cardColor,
                                      child: Icon(
                                        Mdi.accountEditOutline,
                                        color: AppTheme.iconHome,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => EditProfile(),
                                    ));
                                  },
                                ),
                              ),
                            )
                          ])))))
        ]),
      ),
    );
  }

  _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Mdi.informationOutline,
        color: AppTheme.iconColor,
      ),
      title: Text('About'),
      onTap: () {
        showAboutDialog(
            context: context,
            applicationIcon: Image.asset(
              'assets/msg.png',
              height: 50.0,
              width: 50.0,
            ),
            children: [
              SizedBox(
                height: 30.0,
              ),
              Text(
                  "Copyright 2020 Arun. All rights reserved.* Redistributions of source code must retain the above copyrightnotice, this list of conditions and the following disclaimer.\n\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS\n\n             Made with 💛 by Arun")
            ],
            applicationName: 'FlutChat',
            applicationVersion: '0.0.1 (Beta version)',
            applicationLegalese: '@2020 Arun');
      },
    );
  }

  ListTile _buildThemeSettingsTile(BuildContext context) {
    return ListTile(
      title: Text(
        "Themes",
        style: TextStyle(color: AppTheme.textColor),
      ),
      leading: Icon(
        MdiIcons.themeLightDark,
        color: AppTheme.iconColor,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ThemeSettingsPage(),
        ));
      },
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
                              top: -50,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(120)),
                                    border: Border.all(
                                        color: AppTheme.accentColor, width: 5)),
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
                                // physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  SizedBox(
                                    height: 28,
                                  ),
                                  ListTile(
                                    title: Text(
                                      '${user != null ? user.userName : ''}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppTheme.textColor,
                                      ),
                                    ),
                                    onTap: () {},
                                  ),
                                  Divider(),
                                  _buildThemeSettingsTile(context),
                                  Divider(),
                                  _buildAboutTile(context),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(
                                      Mdi.logout,
                                      color: AppTheme.iconColor,
                                    ),
                                    title: Text("Sign out"),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) =>
                                            SignOutConfirmationDialog(),
                                      );
                                    },
                                  ),
                                  Divider(),
                                  ListTile(
                                    leading: Icon(
                                      Mdi.bugCheckOutline,
                                      color: AppTheme.iconColor,
                                    ),
                                    title: Text('Found bugs? Ping me'),
                                    subtitle: Text(
                                        'Include screenshot with a well detailed description'),
                                    onTap: () {
                                      _launchURL(
                                          "arungauthamk@gmail.com",
                                          "Suggestion of an feature / Reporting bugs",
                                          "Type Here...");
                                    },
                                  ),
                                  Divider(),
                                ],
                              ),
                            )
                          ],
                        ))),
                Container(
                  height: 20,
                  color: AppTheme.defaultColor,
                )
              ],
            ),
          );
        });
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

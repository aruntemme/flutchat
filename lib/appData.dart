import 'package:flutter/cupertino.dart';
import 'package:flutchat/data/strings.dart';
import 'package:flutchat/user/user.dart';

ValueNotifier<User> userData = ValueNotifier<User>(User(imageUrl: demoImage));

setUser(User user) {
  userData.value = user;
}

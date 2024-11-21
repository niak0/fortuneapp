

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/current_user.dart';
import '../../core/models/user_model.dart';


class ProfileViewModel extends ChangeNotifier {

  late UserModel _user;

  ProfileViewModel(BuildContext context) {
    _user = Provider.of<CurrentUser>(context, listen: false).currentUser!;
  }

  UserModel get user => _user;
}
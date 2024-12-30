import 'package:flutter/foundation.dart';
class UserProvider with ChangeNotifier {
  String _username = '';
  String _username1= '';

  // Getter for the username
  String get username => _username;
  String get username1 => _username1;

  // Setter for the username that updates the value and notifies listeners
  void setUsername(String username) {
    _username = username;
    notifyListeners();  // Notifies listeners to rebuild widgets that depend on this provider
  }

  void setUsername1(String username1) {
    _username1 = username1;
    notifyListeners();
  }
}

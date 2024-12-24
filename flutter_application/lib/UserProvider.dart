import 'package:flutter/foundation.dart';
class UserProvider with ChangeNotifier {
  String _username = '';

  // Getter for the username
  String get username => _username;

  // Setter for the username that updates the value and notifies listeners
  void setUsername(String username) {
    _username = username;
    notifyListeners();  // Notifies listeners to rebuild widgets that depend on this provider
  }
}

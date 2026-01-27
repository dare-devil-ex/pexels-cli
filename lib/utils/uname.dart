import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Username extends ChangeNotifier {
  String defaultUsername = 'Guest';
  static const _key = 'pixora';

  Username() {
    getName();
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();
    defaultUsername = prefs.getString(_key) ?? defaultUsername;
    notifyListeners();
  }

  Future<void> setName(String name) async {
    defaultUsername = name;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, name);
  }
}

class Avatar extends ChangeNotifier {
  String avatarUrl =
      "https://imgs.search.brave.com/9DJisuyu-7sPZxsJyclWw1nETKOMez4ihK4WUd__I7k/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pLnBp/bmltZy5jb20vb3Jp/Z2luYWxzL2U1L2Ni/L2RlL2U1Y2JkZWM1/ZDYzMTFlNzJhM2Zi/ZDA5N2M4ZWRlZWQ3/LmpwZw";

  static const _key = 'avatar_url';

  Avatar() {
    getAvatar();
  }

  Future<void> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    avatarUrl = prefs.getString(_key) ?? avatarUrl;
    notifyListeners();
  }

  Future<void> setAvatar(String url) async {
    avatarUrl = url;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, url);
  }
}
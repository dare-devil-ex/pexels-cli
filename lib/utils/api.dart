import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Api extends ChangeNotifier {
  List images = [];
  List videos = [];
  int pages = 1;
  bool? isConnected;
  int loadMorePics = 80;
  String authKey = "<API_KEY>";

  // tmree
  Future<void> networkStatus() async {
    isConnected = await InternetConnectionChecker.instance.hasConnection;
    notifyListeners();
  }

  Future<void> fetchPhotos(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.pexels.com/v1/curated?page=$pages&per_page=$loadMorePics",
        ),
        headers: {"Authorization": authKey},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        images.addAll(result["photos"]);
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> fetchVideo(BuildContext context) async {
    try {
      final responseVid = await http.get(
        Uri.parse(
          "https://api.pexels.com/videos/popular?page=$pages&per_page=$loadMorePics",
        ),
        headers: {"Authorization": authKey},
      );

      if (responseVid.statusCode == 200) {
        // final result = jsonDecode(responseVid.body);
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void loadMore(BuildContext context) async {
    pages++;
    loadMorePics += 80;
    await fetchPhotos(context);
    notifyListeners();
  }
}

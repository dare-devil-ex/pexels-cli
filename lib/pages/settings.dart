import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/uname.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final avatar = context.watch<Avatar>().avatarUrl;
    TextEditingController usernameController = TextEditingController();
    TextEditingController avatarController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text("Settings", style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Hero(
              tag: "avatar",
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(avatar, scale: 1),
              ),
            ),
          ),

          // Username change
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<Username>().setName(usernameController.text);
                    SnackBar snackbar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Username updated"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    usernameController.clear();
                  },
                  child: Text("change"),
                ),
              ],
            ),
          ),

          // Avatar change
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: avatarController,
                    decoration: InputDecoration(
                      hintText: 'Avatar Url',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<Avatar>().setAvatar(avatarController.text);
                    SnackBar snackbar = SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Avatar updated"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    avatarController.clear();
                  },
                  child: Text("change"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

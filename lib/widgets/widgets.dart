import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Customtext {
  Text sheet(String pic) {
    return Text(
      pic,
      style: TextStyle(fontFamily: GoogleFonts.afacad().fontFamily),
    );
  }
}

Widget backDropButton(IconData icon) {
  return RepaintBoundary(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 25, color: Colors.white),
        ),
      ),
    ),
  );
}

Widget menu(IconData icon, String category, Color pageColor) {
  return ListTile(
    leading: Icon(icon, color: pageColor),
    title: Text(category, style: TextStyle(color: pageColor)),
  );
}

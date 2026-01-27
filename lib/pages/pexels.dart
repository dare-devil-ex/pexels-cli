import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pexels_cli/category/photos.dart';
import 'package:pexels_cli/category/videos.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/api.dart';
import '../widgets/widgets.dart';
import '../utils/uname.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  int pageIndex = 0;
  bool isLoading = true;
  bool sheetOpen = false;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    final api = context.read<Api>();
    // api.fetchVideo(context);
    api.fetchPhotos(context).then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if ((isLoading)) {
      return Center(child: CircularProgressIndicator.adaptive());
    } else {
      return Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    // Grid
                    child: PageView(
                      onPageChanged: (value) {
                        setState(() {
                          pageIndex = value;
                        });
                      },
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      children: [Photos(), Videos()],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Buttons
            Positioned(
              child: Row(
                children: [
                  SizedBox(width: 15),
                  // settings button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/settings");
                    },
                    child: backDropButton(Icons.settings),
                  ),

                  // Swap more button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      child: RepaintBoundary(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Stack(
                              alignment: AlignmentGeometry.center,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    alignment: Alignment.center,
                                    foregroundColor:
                                        WidgetStateColor.resolveWith(
                                          (states) => Colors.white,
                                        ),
                                    backgroundColor:
                                        WidgetStateColor.resolveWith(
                                          (colors) => Colors.transparent,
                                        ),
                                    elevation: WidgetStatePropertyAll(0),
                                  ),
                                  onPressed: () {},
                                  child: Text('S E A R C H'),
                                ),

                                Positioned(
                                  right: 7.8,
                                  child: SmoothPageIndicator(
                                    controller: pageController,
                                    count: 2,
                                    axisDirection: Axis.horizontal,
                                    effect: ExpandingDotsEffect(
                                      dotHeight: 6,
                                      spacing: 4,
                                      dotWidth: 6,
                                      activeDotColor: Colors.white70,
                                      dotColor: Colors.white30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Categories
                  GestureDetector(
                    onTap: () {
                      setState(() => sheetOpen = true);
                      showModalBottomSheet(
                        context: context,
                        elevation: 0,
                        useSafeArea: true,
                        showDragHandle: true,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    pageController.animateToPage(
                                      0,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInExpo,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: menu(
                                    Icons.photo,
                                    "Photos",
                                    (pageIndex == 0)
                                        ? Colors.lightBlue
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    pageController.animateToPage(
                                      1,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInExpo,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: menu(
                                    Icons.video_collection_outlined,
                                    "Videos",
                                    (pageIndex == 1)
                                        ? Colors.lightBlue
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: backDropButton(Icons.menu),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),

            // Top Positioned User Info
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 12.5,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // User Avatar
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(2, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.white, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                      child: Hero(
                        tag: "avatar",
                        child: GestureDetector(
                          onLongPress: () =>
                              Navigator.pushNamed(context, "/settings"),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(
                              context.watch<Avatar>().avatarUrl,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    // Username
                    RepaintBoundary(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              context.watch<Username>().defaultUsername,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../utils/api.dart';
import '../utils/fonts.dart';
import 'widgets.dart';

class DownloadSheet extends StatefulWidget {
  final int index;
  const DownloadSheet(this.index, {super.key});

  @override
  State<DownloadSheet> createState() => _DownloadSheetState();
}

class _DownloadSheetState extends State<DownloadSheet> {
  bool isDownloading = false;
  final progress = ValueNotifier<double>(0.0);

  Future<void> downloadImage({required String url}) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = url.split('/').last.replaceFirst("pexels", "lmods");
      final savedPath = "${dir.path}/$fileName";
      await Dio().download(
        url,
        savedPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress.value = received / total;
            });
          }
        },
      );
      GallerySaver.saveImage(savedPath, albumName: 'pixora');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Api>().images;
    final desc = images[widget.index]["alt"];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  scale: 2,
                  imageUrl: images[widget.index]["src"]["medium"].toString(),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  children: [
                    // Photographer information
                    Text(
                      "Photographer: ${images[widget.index]["photographer"]}",
                      style: TextStyle(fontFamily: aBeeZee),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 9,
                    ),
                    Divider(),
                    Text(
                      // Description
                      desc.isEmpty ? 'No description available!' : desc,
                      style: TextStyle(fontFamily: lato),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          children: [
            // Download text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "download space",
                style: TextStyle(fontSize: 11, fontFamily: quicksand),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 18.0, top: 5),
          child: Row(
            children: [
              // portrait
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => isDownloading = true);

                    try {
                      final imageUrl = images[widget.index]["src"]["portrait"];
                      await downloadImage(url: imageUrl);

                      setState(() {
                        isDownloading = false;
                        progress.value = 0.0;
                      });
                    } catch (e) {
                      setState(() => isDownloading = false);
                    }
                  },

                  child: Customtext().sheet("portrait"),
                ),
              ),
              SizedBox(width: 9),

              // landscape
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() => isDownloading = true);

                    try {
                      final imageUrl = images[widget.index]["src"]["landscape"];
                      await downloadImage(url: imageUrl);

                      setState(() {
                        isDownloading = false;
                        progress.value = 0.0;
                      });
                    } catch (e) {
                      setState(() => isDownloading = false);
                    }
                  },
                  child: Customtext().sheet("landscape"),
                ),
              ),
            ],
          ),
        ),

        // Progression bar
        Padding(
          padding: EdgeInsets.all(1.0),
          child: ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (_, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 2,
                color: Colors.white,
              );
            },
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

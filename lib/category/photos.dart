import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/api.dart';
import '../widgets/download_sheet.dart';

class Photos extends StatelessWidget {
  const Photos({super.key});

  @override
  Widget build(BuildContext context) {
    final images = context.watch<Api>().images;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 200) {
          context.read<Api>().loadMore(context);
        }
        return false;
      },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imageUrl = images[index]["src"]["medium"] ?? '';
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.black38,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.dangerous_outlined, color: Colors.red),
                  ),
                ),

                // Download overlay
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => DownloadSheet(index),
                    ),
                    child: Icon(
                      Icons.download,
                      size: 20,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.blue, blurRadius: 3)],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

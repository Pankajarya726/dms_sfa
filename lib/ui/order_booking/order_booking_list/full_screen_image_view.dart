import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatefulWidget {
  final String productImage;
  const FullScreenImageView({Key? key, required this.productImage})
      : super(key: key);

  @override
  _FullScreenImageViewState createState() => _FullScreenImageViewState();
}

class _FullScreenImageViewState extends State<FullScreenImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leadingWidth: 70,
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Image(
            width: 55,
            image: AssetImage("assets/rounded_back.png"),
          ),
        ),
      ),
      body: Center(
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: Colors.white,
          ),
          imageProvider: NetworkImage(widget.productImage),
        ),
      ),
    );
  }
}

import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RetailerDetailScreen extends StatefulWidget {
  const RetailerDetailScreen({Key? key}) : super(key: key);

  @override
  _RetailerDetailScreenState createState() => _RetailerDetailScreenState();
}

class _RetailerDetailScreenState extends State<RetailerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            toolbarHeight: 54,
            floating: true,
            pinned: true,
            stretch: false,
            centerTitle: true,

            // title: const Text(""),
            backgroundColor: MColor.colorPrimary,
            systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_back_ios),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                height: 100,
                color: MColor.colorPrimary,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      color: MColor.colorPrimary,
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.white,
                    ))
                  ],
                ),
              ),
              collapseMode: CollapseMode.none,
              title: Material(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 40,
                  alignment: Alignment.centerLeft,
                  child: Text("Retaioler name"),
                ),
              ),
            ),
          ),
          SliverFillRemaining()
        ],
      ),
    );
  }
}

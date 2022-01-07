import 'package:cached_network_image/cached_network_image.dart';
import 'package:dms/utils/colors.dart';
import 'package:dms/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RetailerDetailScreen extends StatefulWidget {
  const RetailerDetailScreen({Key? key}) : super(key: key);

  @override
  _RetailerDetailScreenState createState() => _RetailerDetailScreenState();
}

class _RetailerDetailScreenState extends State<RetailerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(AppBar().preferredSize.height),
      backgroundColor: const Color(0xffF7F7F7),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
              delegate: SliverChildListDelegate([
                DetailGritItem(
                  value: DateFormat("dd-MM-yyyy").format(DateTime.now()),
                  image: "assets/store.png",
                  name: "Last visit",
                  type: 1,
                ),
                const DetailGritItem(
                  value: "3",
                  image: "assets/task.png",
                  name: "Task",
                  type: 1,
                ),
                const DetailGritItem(
                  value: "No Order",
                  image: "assets/phone.png",
                  name: "TC Status",
                  type: 1,
                ),
                const DetailGritItem(
                  value: "Potential",
                  image: "assets/experience.png",
                  name: "₹5,000",
                  type: 1,
                ),
              ]),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2.5, mainAxisSpacing: 15, crossAxisSpacing: 0)),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Store Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      splashRadius: 15,
                      icon: Container(
                        height: 25,
                        width: 25,
                        decoration:
                            const BoxDecoration(color: MColor.colorSecondary, borderRadius: BorderRadius.all(Radius.circular(15))),
                        child: const Center(
                            child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 18,
                        )),
                      ))
                ],
              ),
            ),
          ]))
        ],
      ),
    );
  }

  _appBar(height) => PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, height + 60),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 50,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.home_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                color: MColor.colorPrimary,
                height: height + 20,
                width: MediaQuery.of(context).size.width,
              ),
            ),

            Container(), // Required some widget in between to float AppBar

            Positioned(
              // To take AppBar Size only
              top: 60.0,
              left: 50.0,
              right: 50.0,
              child: AppBar(
                  elevation: 5,
                  toolbarHeight: 60,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.white,
                  primary: false,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          imageUrl: Constants.image,
                          imageBuilder: (context, imageProvider) {
                            return Image(
                              image: imageProvider,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            );
                          },
                          errorWidget: (context, url, error) => Image.asset("assets/placeholder.png"),
                          placeholder: (context, url) => Image.asset("assets/placeholder.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Constants.name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            Constants.designation,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      );
}

class DetailGritItem extends StatefulWidget {
  final String image;
  final String name;
  final String value;
  final int type;

  const DetailGritItem({Key? key, required this.image, required this.name, required this.value, required this.type}) : super(key: key);

  @override
  _DetailGritItemState createState() => _DetailGritItemState();
}

class _DetailGritItemState extends State<DetailGritItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)), boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(237, 237, 237, 0.25),
          blurRadius: 10,
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(
              widget.image,
            ),
            width: 40,
            height: 40,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(color: Color(0xff303030), fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.value,
                style: const TextStyle(color: Color(0xff555555), fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }
}

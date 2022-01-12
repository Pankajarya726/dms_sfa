import 'package:dms/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';

class EndDayScreen extends StatefulWidget {
  const EndDayScreen({Key? key}) : super(key: key);

  @override
  _EndDayScreenState createState() => _EndDayScreenState();
}

class _EndDayScreenState extends State<EndDayScreen> {
  TextEditingController edtRemark = TextEditingController();
  TextEditingController edtTc = TextEditingController();
  TextEditingController edtPc = TextEditingController();
  TextEditingController edtTotalSale = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 15,
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {},
        ),
        elevation: 1,
        title: const Text(
          "End My Day",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Primary Tag",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Tags(
              itemCount: 1,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: "Retailing",
                  active: true,
                  textActiveColor: Colors.black,
                  textColor: const Color(0xff555555),
                  elevation: 0,
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.normal),

                  // textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: Border.all(color: MColor.colorPrimary),
                  singleItem: true,
                  activeColor: const Color(0xffFFC9CC),
                  color: const Color(0xffFFC9CC),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Secondary Tag",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Tags(
              itemCount: 2,
              itemBuilder: (index) {
                return ItemTags(
                  index: index,
                  title: "Retailing",
                  active: true,
                  textActiveColor: Colors.black,
                  elevation: 0,
                  textStyle: const TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.normal),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: Border.all(color: MColor.colorPrimary),
                  activeColor: const Color(0xffFFC9CC),
                  color: const Color(0xffFFC9CC),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TC *",
                        style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PC *",
                        style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        keyboardType: TextInputType.number,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Total Sale *",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Remark",
              style: TextStyle(letterSpacing: 0.5, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: MaterialButton(
          onPressed: () {},
          height: 50,
          elevation: 0,
          color: MColor.colorSecondary,
          shape: const RoundedRectangleBorder(),
          child: const Text(
            "END DAY",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}

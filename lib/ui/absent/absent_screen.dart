import 'package:flutter/material.dart';
import 'package:sfa/utility/colors.dart';

class AbsentScreen extends StatelessWidget {
  const AbsentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Reason",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          TextFormField(
            maxLines: 4,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Color(0xff303030),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorPrimary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xff555555),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: MaterialButton(
                height: 45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: colorPrimary,
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:too/helpers/api_url.dart';
import '../../constants.dart';
import '../../data.dart';
import '../../helpers/app_preferences.dart';
import '../../helpers/components.dart';

class AddMailPage extends StatefulWidget {
  const AddMailPage({Key? key}) : super(key: key);

  @override
  State<AddMailPage> createState() => _AddMailPageState();
}

class _AddMailPageState extends State<AddMailPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final _titleTEC = TextEditingController();
  final _contentTEC = TextEditingController();
  bool _isLoad = false;

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });

    final response = await https.post(
      Uri.parse(mainApiUrl + "post-mail"),
      body: {
        "title": _titleTEC.text,
        "content": _contentTEC.text,
        "owner_id": user["id"].toString(),
        "owner_name": user["name"].toString(),
        "owner_phone": user["phone"].toString(),
      },
    );

    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        mailItems.add(body["mail"]);
        showSnackBar("Амжилттай илгээлээ", globalKey);
        Future.delayed(
          const Duration(seconds: 1),
          () {
            back(context);
          },
        );
      } else {
        showSnackBar(body["message"].toString(), globalKey);
      }
    } else {
      showSnackBar("Сервер алдаа гарлаа", globalKey);
    }

    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Ctext(
          text: "Захидал илгээх",
          large: true,
          color: Colors.white,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.04,
              right: width * 0.04,
              bottom: height * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _titleTEC,
                  decoration: InputDecoration(hintText: "Гарчиг.."),
                ),
                SizedBox(height: height * 0.01),
                TextField(
                  controller: _contentTEC,
                  decoration: InputDecoration(hintText: "Энд захидал бичих.."),
                ),
                SizedBox(height: height * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: Cbutton(
                    isLoad: _isLoad,
                    onPress: () {
                      if (!_isLoad) {
                        _request();
                      }
                    },
                    text: "Илгээх",
                    normal: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

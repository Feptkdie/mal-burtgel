import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:too/constants.dart';
import 'package:too/helpers/app_preferences.dart';
import 'package:too/helpers/components.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final _phoneTEC = TextEditingController();
  bool _isLoad = false;

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
      () {
        showSnackBar(
          "Амжилттай хүсэлт илгээгдлээ, Та манайхтай холбоо барина уу 88809843",
          globalKey,
        );
      },
    );

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
        title: Ctext(
          text: "Нууц үг сэргээх",
          large: true,
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            back(context);
          },
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.2,
                  left: width * 0.08,
                  right: width * 0.08,
                ),
                child: TextField(
                  controller: _phoneTEC,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(hintText: "Утасны дугаар"),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.06,
                    top: height * 0.02,
                  ),
                  child: Cbutton(
                    text: "Илгээх",
                    onPress: () {
                      if (!_isLoad) {
                        if (_phoneTEC.text.isNotEmpty) {
                          _request();
                        } else {
                          showSnackBar(
                            "Та утасны дугаараа оруулна уу",
                            globalKey,
                          );
                        }
                      }
                    },
                    normal: true,
                    isLoad: _isLoad,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

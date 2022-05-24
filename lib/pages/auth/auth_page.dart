import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:too/helpers/api_url.dart';
import 'package:too/helpers/app_preferences.dart';
import 'package:too/helpers/components.dart';
import 'package:http/http.dart' as https;
import 'package:too/pages/auth/register_page.dart';
import 'package:too/pages/home_page.dart';

import '../../data.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final _nameTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  bool _isLoad = false;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("name") != null) {
      _nameTEC.text = prefs.getString("name").toString();
    }
    if (prefs.getString("password") != null) {
      _passwordTEC.text = prefs.getString("password").toString();
    }
    setState(() {});
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", _nameTEC.text);
    prefs.setString("password", _passwordTEC.text);
  }

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });

    if (_nameTEC.text.isNotEmpty && _passwordTEC.text.isNotEmpty) {
      final response = await https.post(
        Uri.parse(mainApiUrl + "login"),
        body: {
          "name": _nameTEC.text,
          "password": _passwordTEC.text,
        },
      );
      print(response.body);
      if (response.statusCode == 201) {
        var body = json.decode(response.body);
        if (body["status"]) {
          await _saveUserData();
          user = body["user"];
          token = body["user"]["token"];
          goAndClear(context, const HomePage());
        } else {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("name", "");
          prefs.setString("password", "");
          showSnackBar(body["message"].toString(), globalKey);
        }
      } else {
        showSnackBar("Сервер алдаа гарлаа!", globalKey);
      }
    } else {
      showSnackBar("Бүх хэсэгийг бөглөнө үү", globalKey);
    }

    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.03),
                Ctext(
                  text: "Мал бүртгэл",
                  normal: true,
                  bold: true,
                ),
                SizedBox(height: height * 0.26),
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.1,
                    right: width * 0.1,
                  ),
                  child: TextFormField(
                    controller: _nameTEC,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      labelText: "Нэвтрэх нэр",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    left: width * 0.1,
                    right: width * 0.1,
                  ),
                  child: TextFormField(
                    controller: _passwordTEC,
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 8.0),
                      labelText: "Нүүц үг",
                    ),
                  ),
                ),
                SizedBox(height: height * 0.1),
                Cbutton(
                  text: "Нэвтрэх",
                  normal: true,
                  onPress: () {
                    if (!_isLoad) {
                      _request();
                    }
                  },
                  isLoad: _isLoad,
                ),
                SizedBox(height: height * 0.01),
                TextButton(
                  onPressed: () {
                    go(context, const RegisterPage());
                  },
                  child: const Text("БҮРТГҮҮЛЭХ"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

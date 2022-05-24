import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:too/constants.dart';
import 'package:too/data.dart';
import 'package:too/helpers/api_url.dart';
import 'package:too/helpers/components.dart';
import 'package:http/http.dart' as https;
import '../../helpers/app_preferences.dart';
import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final _nameTEC = TextEditingController();
  final _surnameTEC = TextEditingController();
  final _phoneTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _rePasswordTEC = TextEditingController();
  var _selectedOwner;
  String _status = "Малчин";
  bool _isLoad = false, _mainLoad = false;

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", _nameTEC.text);
    prefs.setString("password", _passwordTEC.text);
  }

  Future<void> _request() async {
    if (_passwordTEC.text == _rePasswordTEC.text) {
      setState(() {
        _isLoad = true;
      });

      String ownerId = "", ownerName = "", ownerPhone = "";

      if (_selectedOwner != null) {
        ownerId = _selectedOwner["id"].toString();
        ownerName = _selectedOwner["surname"].toString();
        ownerPhone = _selectedOwner["phone"].toString();
      }

      final response = await https.post(
        Uri.parse(mainApiUrl + "register"),
        body: {
          "name": _nameTEC.text,
          "surname": _surnameTEC.text,
          "password": _passwordTEC.text,
          "phone": _phoneTEC.text,
          "status": _status,
          "owner_id": ownerId,
          "owner_name": ownerName,
          "owner_phone": ownerPhone,
        },
      );

      if (response.statusCode == 201) {
        var body = json.decode(response.body);
        if (body["status"]) {
          await _saveUserData();
          user = body["user"];
          token = body["user"]["token"];
          goAndClear(context, const HomePage());
        } else {
          showSnackBar(body["message"].toString(), globalKey);
        }
      } else {
        showSnackBar("Сервер алдаа гарлаа!", globalKey);
      }

      if (mounted) {
        setState(() {
          _isLoad = false;
        });
      }
    } else {
      showSnackBar("Нууц үг давхцахгүй байна!", globalKey);
    }
  }

  Future<void> _loadOwner() async {
    setState(() {
      _mainLoad = true;
    });

    final response = await https.get(Uri.parse(mainApiUrl + "get-login"));

    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      ownerItems.clear();
      body["users"].forEach((value) {
        ownerItems.add(value);
      });
      if (ownerItems.isEmpty) {
        _status = "Засаг дарга";
        showSnackBar(
          "Засаг дарга олдсонгүй, Та малчингаар бүртгүүлэх боломжгүй",
          globalKey,
        );
      }
    } else {
      showSnackBar("Сервер алдаа гарлаа!", globalKey);
    }

    if (mounted) {
      setState(() {
        _mainLoad = false;
      });
    }
  }

  @override
  void initState() {
    _loadOwner();
    super.initState();
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
          text: "Бүртгүүлэх",
          large: true,
          color: Colors.white,
        ),
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_mainLoad)
                Padding(
                  padding: EdgeInsets.only(top: height * 0.4),
                  child: SizedBox(
                    height: height * 0.04,
                    width: height * 0.04,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              if (!_mainLoad) _body(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(double height, double width) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.03,
              left: width * 0.1,
              right: width * 0.1,
            ),
            child: DropdownButton(
              isExpanded: true,
              hint: Text(
                'Статусаа сонгоно уу',
              ),
              value: _status,
              onChanged: (newValue) {
                setState(() {
                  _status = newValue.toString();
                });
              },
              items: <String>["Малчин", "Засаг дарга"].map((value) {
                return DropdownMenuItem(
                  child: new Text(value),
                  value: value,
                );
              }).toList(),
            ),
          ),
          if (_status == "Малчин")
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.01,
                left: width * 0.1,
                right: width * 0.1,
              ),
              child: DropdownButton(
                hint: _selectedOwner == null
                    ? Text(
                        'Засаг даргаа сонгох',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      )
                    : Text(
                        _selectedOwner["surname"].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                items: ownerItems.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: json.encode(val),
                      child: Text(val["surname"].toString()),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _selectedOwner = json.decode(val.toString());
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
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
              top: height * 0.01,
              left: width * 0.1,
              right: width * 0.1,
            ),
            child: TextFormField(
              controller: _surnameTEC,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8.0),
                labelText: "Таны нэр",
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
              controller: _phoneTEC,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8.0),
                labelText: "Утасны дугаар",
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
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
              left: width * 0.1,
              right: width * 0.1,
            ),
            child: TextFormField(
              controller: _rePasswordTEC,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8.0),
                labelText: "Нүүц үг давтах",
              ),
            ),
          ),
          SizedBox(height: height * 0.1),
          Cbutton(
            text: "Бүртгүүлэх",
            normal: true,
            onPress: () {
              if (!_isLoad) {
                _request();
              }
            },
            isLoad: _isLoad,
          ),
        ],
      );
}

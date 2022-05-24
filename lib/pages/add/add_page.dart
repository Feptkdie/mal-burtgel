import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:too/constants.dart';
import 'package:too/helpers/api_url.dart';
import 'package:too/helpers/app_preferences.dart';
import 'package:too/helpers/components.dart';
import 'package:http/http.dart' as https;

import '../../data.dart';

class AddPage extends StatefulWidget {
  final VoidCallback onChange;
  const AddPage({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final _amountTEC = TextEditingController();
  final _commentTEC = TextEditingController();
  final _addressTEC = TextEditingController();
  late final AudioCache _audioCache;
  String _selectedCategory = "Хонь";
  bool _isLoad = false;

  Future<void> _request() async {
    setState(() {
      _isLoad = true;
    });
    print(user);
    final response = await https.post(
      Uri.parse(mainApiUrl + "register-animal"),
      body: {
        "name": _selectedCategory,
        "amount": _amountTEC.text,
        "address": _addressTEC.text,
        "comment": _commentTEC.text,
        "user_id": user["id"].toString(),
        "user_name": user["surname"].toString(),
        "user_phone": user["phone"].toString(),
        "owner_id": user["owner_id"].toString(),
        "owner_name": user["owner_name"].toString(),
        "owner_phone": user["owner_phone"].toString(),
        "token": token,
      },
    );

    print(response.body);
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        historyItems.clear();
        body["animals"].forEach((value) {
          historyItems.add(value);
        });
        allHorseCount = body["horseCount"];
        allCattleCount = body["cattleCount"];
        allCamelCount = body["camelCount"];
        allSheepCount = body["sheepCount"];
        allGoatCount = body["goatCount"];
        allAllAnimalCount = body["allAnimalCount"];
        nowItems.clear();
        historyItems.forEach((value) {
          if (value["created_at"] != null) {
            DateTime valueDate = DateTime.parse(value["created_at"].toString());
            if (valueDate.year == DateTime.now().year &&
                valueDate.month == DateTime.now().month &&
                valueDate.day == DateTime.now().day) {
              nowItems.add(value);
              if (value["name"] == "Хонь") {
                sheepCount += int.parse(value["amount"].toString());
              } else if (value["name"] == "Ямаа") {
                goatCount += int.parse(value["amount"].toString());
              } else if (value["name"] == "Үхэр") {
                cattleCount += int.parse(value["amount"].toString());
              } else if (value["name"] == "Тэмээ") {
                camelCount += int.parse(value["amount"].toString());
              } else if (value["name"] == "Морь") {
                horseCount += int.parse(value["amount"].toString());
              }
              allAnimalCount += int.parse(value["amount"].toString());
            }
          }
        });
        widget.onChange.call();
        _addressTEC.clear();
        _commentTEC.clear();
        _amountTEC.clear();
        showSnackBar(body["message"], globalKey);
      } else {
        showSnackBar(body["message"], globalKey);
      }
    } else {
      showSnackBar(
        "Сервер алдаа гарлаа, Та дахин оролдоно уу",
        globalKey,
      );
    }

    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  void _preferAudio() {
    _audioCache = AudioCache(
      prefix: 'assets/audio/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  @override
  void initState() {
    _preferAudio();
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
        leading: IconButton(
          onPressed: () {
            back(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Ctext(
          text: "Мал бүртгэх",
          large: true,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              SizedBox(height: height * 0.016),
              Padding(
                padding: EdgeInsets.only(
                  right: width * 0.04,
                  left: width * 0.04,
                ),
                child: Row(
                  children: [
                    DropdownButton<String>(
                      value: _selectedCategory,
                      elevation: 16,
                      underline: Container(
                        height: 1.0,
                        color: kPrimaryColor,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue == "Хонь") {
                          _audioCache.play('sheep.mp3');
                        } else if (newValue == "Ямаа") {
                          _audioCache.play('goat.mp3');
                        } else if (newValue == "Үхэр") {
                          _audioCache.play('cow.mp3');
                        } else if (newValue == "Морь") {
                          _audioCache.play('horse.mp3');
                        } else if (newValue == "Тэмээ") {
                          _audioCache.play('camel.mp3');
                        }
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                      items: <String>['Хонь', 'Ямаа', 'Үхэр', 'Морь', 'Тэмээ']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                (value == "Хонь")
                                    ? "assets/images/sheep.png"
                                    : (value == "Ямаа")
                                        ? "assets/images/goat.png"
                                        : (value == "Үхэр")
                                            ? "assets/images/cattle.png"
                                            : (value == "Морь")
                                                ? "assets/images/horse.png"
                                                : "assets/images/camel.png",
                                height: height * 0.024,
                                width: height * 0.024,
                              ),
                              SizedBox(width: width * 0.02),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(width: width * 0.04),
                    SizedBox(
                      height: height * 0.038,
                      width: width * 0.15,
                      child: TextField(
                        controller: _amountTEC,
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ], // Only numbe
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 8.0),
                          hintText: "1..",
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: SizedBox(
                        height: height * 0.038,
                        child: TextField(
                          controller: _commentTEC,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 8.0),
                            hintText: "Шалтгаан..",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                height: height * 0.038,
                width: width * 0.92,
                child: TextField(
                  controller: _addressTEC,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 8.0),
                    hintText: "Мал тооллого хийсэн газар..",
                  ),
                ),
              ),
              SizedBox(height: height * 0.1),
              Cbutton(
                text: "Бүртгэх",
                normal: true,
                color:
                    (_amountTEC.text.isNotEmpty && _addressTEC.text.isNotEmpty)
                        ? kPrimaryColor
                        : Colors.grey[400],
                onPress: () {
                  if (_amountTEC.text.isNotEmpty &&
                      _addressTEC.text.isNotEmpty) {
                    if (!_isLoad) {
                      _request();
                    }
                  } else {
                    showSnackBar(
                      "Тоо ширхэг, Хаяг оруулна уу!",
                      globalKey,
                    );
                  }
                },
                isLoad: _isLoad,
              ),
              SizedBox(height: height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

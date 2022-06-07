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
  final _alive1TEC = TextEditingController();
  final _alive2TEC = TextEditingController();
  final _alive3TEC = TextEditingController();
  final _dead1TEC = TextEditingController();
  final _dead2TEC = TextEditingController();
  final _dead3TEC = TextEditingController();
  late final AudioCache _audioCache;
  String _selectedCategory = "Хонь";
  bool _isLoad = false;
  String _status = "Шинээр төлөлсөн";
  var _lastHistory;
  String valueTemp = "";

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
        "alive1": _alive1TEC.text,
        "alive2": _alive2TEC.text,
        "alive3": _alive3TEC.text,
        "dead1": _dead1TEC.text,
        "dead2": _dead2TEC.text,
        "dead3": _dead3TEC.text,
        "token": token,
      },
    );

    print(response.body);
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        historyItems.clear();
        body["animals"].reversed.forEach((value) {
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
          if (value["name"] == "Хонь") {
            allSheepCount = int.parse(value["amount"].toString());
          } else if (value["name"] == "Ямаа") {
            allGoatCount = int.parse(value["amount"].toString());
          } else if (value["name"] == "Үхэр") {
            allCattleCount = int.parse(value["amount"].toString());
          } else if (value["name"] == "Тэмээ") {
            allCamelCount = int.parse(value["amount"].toString());
          } else if (value["name"] == "Морь") {
            allHorseCount = int.parse(value["amount"].toString());
          }
          allAllAnimalCount = allSheepCount +
              allGoatCount +
              allCamelCount +
              allCattleCount +
              allHorseCount;
          if (value["created_at"] != null) {
            DateTime valueDate = DateTime.parse(value["created_at"].toString());
            if (valueDate.year == DateTime.now().year &&
                valueDate.month == DateTime.now().month &&
                valueDate.day == DateTime.now().day) {
              nowItems.add(value);
              if (value["name"] == "Хонь") {
                sheepCount = int.parse(value["amount"].toString());
              } else if (value["name"] == "Ямаа") {
                goatCount = int.parse(value["amount"].toString());
              } else if (value["name"] == "Үхэр") {
                cattleCount = int.parse(value["amount"].toString());
              } else if (value["name"] == "Тэмээ") {
                camelCount = int.parse(value["amount"].toString());
              } else if (value["name"] == "Морь") {
                horseCount = int.parse(value["amount"].toString());
              }
              allAnimalCount += int.parse(value["amount"].toString());
            }
            if (valueDate.year == DateTime.now().year &&
                valueDate.month == DateTime.now().month) {
              month1Items.add(value);
              if (value["name"] == "Хонь") {
                sheepCount2 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Ямаа") {
                goatCount2 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Үхэр") {
                cattleCount2 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Тэмээ") {
                camelCount2 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Морь") {
                horseCount2 = int.parse(value["amount"].toString());
              }
              allAnimalCount2 = int.parse(value["amount"].toString());
            }
            if (valueDate.year == DateTime.now().year &&
                valueDate.month <= DateTime.now().month &&
                valueDate.month >= (DateTime.now().month - 3)) {
              month3Items.add(value);
              if (value["name"] == "Хонь") {
                sheepCount3 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Ямаа") {
                goatCount3 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Үхэр") {
                cattleCount3 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Тэмээ") {
                camelCount3 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Морь") {
                horseCount3 = int.parse(value["amount"].toString());
              }
              allAnimalCount3 = int.parse(value["amount"].toString());
            }
            if (valueDate.year == DateTime.now().year) {
              year1Items.add(value);
              if (value["name"] == "Хонь") {
                sheepCount4 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Ямаа") {
                goatCount4 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Үхэр") {
                cattleCount4 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Тэмээ") {
                camelCount4 = int.parse(value["amount"].toString());
              } else if (value["name"] == "Морь") {
                horseCount4 = int.parse(value["amount"].toString());
              }
              allAnimalCount4 = int.parse(value["amount"].toString());
            }
          }
        });
        widget.onChange.call();
        _addressTEC.clear();
        _commentTEC.clear();
        _amountTEC.clear();
        showSnackBar(body["message"], globalKey);
        back(context);
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

  void _checkHistory() {
    _lastHistory = null;
    _amountTEC.clear();
    for (int i = 0; i < historyItems.length; i++) {
      if (historyItems[i]["name"] == _selectedCategory) {
        _lastHistory = historyItems[i];
      }
    }
    setState(() {
      if (_lastHistory != null) {
        _amountTEC.text = _lastHistory["amount"].toString();
      }
    });
  }

  @override
  void initState() {
    _preferAudio();
    _checkHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.grey[100],
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
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _pervius(height, width),
              _form(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pervius(double height, double width) => AnimatedSize(
        duration: const Duration(milliseconds: 275),
        curve: Curves.easeInOutBack,
        child: Column(
          children: [
            SizedBox(height: height * 0.02),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.04),
                child: Text(
                  "Өмнөх тооллого",
                  style: TextStyle(
                    fontSize: height * 0.022,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            if (_lastHistory == null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.04),
                  child: Text(
                    "Өмнөх тооллого " + _selectedCategory + " дээр олдсонгүй",
                    style: TextStyle(
                      fontSize: height * 0.017,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            if (_lastHistory != null)
              Container(
                height: height * 0.174,
                width: width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1.0,
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0.0, 3.0),
                      ),
                    ]),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.01,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Тоо/ш: " + _lastHistory["amount"].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _lastHistory["name"].toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Шинэ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.017,
                              ),
                            ),
                            Text(
                              "Айлаас",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.017,
                              ),
                            ),
                            Text(
                              "Тавиур",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.017,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _lastHistory["alive1"] ?? "0",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _lastHistory["alive2"] ?? "0",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _lastHistory["alive3"] ?? "0",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Үхсэн",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.017,
                              ),
                            ),
                            Text(
                              "Зарсан",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.017,
                              ),
                            ),
                            Text(
                              "Идсэн",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.017,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: width * 0.04,
                          right: width * 0.04,
                          top: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _lastHistory["dead1"] ?? "0",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _lastHistory["dead2"] ?? "0",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _lastHistory["dead3"] ?? "0",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _form(double height, double width) => Column(
        children: [
          SizedBox(height: height * 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.04),
              child: Text(
                "Малын төрөл",
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
            ),
            child: DropdownButton<String>(
              value: _selectedCategory,
              elevation: 16,
              isExpanded: true,
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
                _checkHistory();
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
          ),
          SizedBox(height: height * 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.04),
              child: Text(
                "Тоо ширхэг",
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(
              right: width * 0.04,
              left: width * 0.04,
            ),
            child: Row(
              children: [
                if (_lastHistory != null)
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showSnackBar(
                          "Өмнөх тооллого байгаа тул та энэ хэсэгт бичих шаардлагагүй",
                          globalKey,
                        );
                      },
                      child: SizedBox(
                        height: height * 0.038,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _amountTEC.text.toString(),
                            style: TextStyle(
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_lastHistory == null)
                  Expanded(
                    child: SizedBox(
                      height: height * 0.038,
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
                  ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.04),
              child: Text(
                "Хаяг",
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          SizedBox(
            width: width * 0.92,
            child: TextField(
              controller: _addressTEC,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                ),
                hintText: "Мал тооллого хийсэн газар..",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.04,
              right: width * 0.04,
              left: width * 0.04,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Нэмэгдэл",
                    style: TextStyle(
                      fontSize: height * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Text(
                      "Шинээр төлөлсөн:",
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      if (_alive1TEC.text.isNotEmpty) {
                        _amountTEC.text =
                            (int.parse(_amountTEC.text.toString()) +
                                    int.parse(_alive1TEC.text.toString()))
                                .toString();
                      }
                      setState(() {});
                    }
                  },
                  child: TextField(
                    controller: _alive1TEC,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.green),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Айлаас ирсэн:",
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      if (_alive2TEC.text.isNotEmpty) {
                        _amountTEC.text =
                            (int.parse(_amountTEC.text.toString()) +
                                    int.parse(_alive2TEC.text.toString()))
                                .toString();
                      }
                      setState(() {});
                    }
                  },
                  child: TextField(
                    controller: _alive2TEC,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.green),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Тавиур:",
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      if (_alive3TEC.text.isNotEmpty) {
                        _amountTEC.text =
                            (int.parse(_amountTEC.text.toString()) +
                                    int.parse(_alive3TEC.text.toString()))
                                .toString();
                      }
                      setState(() {});
                    }
                  },
                  child: TextField(
                    controller: _alive3TEC,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.green),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(height: height * 0.03),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Хорогдол",
                    style: TextStyle(
                      fontSize: height * 0.022,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Row(
                  children: [
                    Text(
                      "Үхсэн:",
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      if (_dead1TEC.text.isNotEmpty) {
                        _amountTEC.text =
                            (int.parse(_amountTEC.text.toString()) -
                                    int.parse(_dead1TEC.text.toString()))
                                .toString();
                      }
                      setState(() {});
                    }
                  },
                  child: TextField(
                    controller: _dead1TEC,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.red),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Зарсан:",
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      if (_dead2TEC.text.isNotEmpty) {
                        _amountTEC.text =
                            (int.parse(_amountTEC.text.toString()) -
                                    int.parse(_dead2TEC.text.toString()))
                                .toString();
                      }
                      setState(() {});
                    }
                  },
                  child: TextField(
                    controller: _dead2TEC,
                    style: TextStyle(color: Colors.red),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Идсэн:",
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Focus(
                  onFocusChange: (value) {
                    if (!value) {
                      if (_dead3TEC.text.isNotEmpty) {
                        _amountTEC.text =
                            (int.parse(_amountTEC.text.toString()) -
                                    int.parse(_dead3TEC.text.toString()))
                                .toString();
                      }
                      setState(() {});
                    }
                  },
                  child: TextField(
                    controller: _dead3TEC,
                    style: TextStyle(color: Colors.red),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.04),
              child: Text(
                "Шалтгаан",
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.04,
              right: width * 0.04,
            ),
            child: TextField(
              controller: _commentTEC,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 8.0),
                hintText: "Шалтгаан..",
              ),
            ),
          ),
          SizedBox(height: height * 0.06),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: width * 0.06),
              child: Cbutton(
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
            ),
          ),
          SizedBox(height: height * 0.1),
        ],
      );
}

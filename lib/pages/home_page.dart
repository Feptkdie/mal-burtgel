import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:too/constants.dart';
import 'package:too/data.dart';
import 'package:too/helpers/api_url.dart';
import 'package:too/helpers/app_preferences.dart';
import 'package:too/helpers/components.dart';
import 'package:too/pages/add/add_page.dart';
import 'package:too/pages/auth/auth_page.dart';
import 'package:too/pages/history/history_page.dart';
import 'package:http/http.dart' as https;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  late final AudioCache _audioCache;
  bool _isLoad = false;
  DateTime _now = DateTime.now();

  Future<void> _loadData() async {
    setState(() {
      _isLoad = true;
    });

    final response = await https.post(
      Uri.parse(mainApiUrl + "get-data"),
      body: {"token": token},
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
        sheepCount = 0;
        goatCount = 0;
        camelCount = 0;
        horseCount = 0;
        allAnimalCount = 0;
        historyItems.forEach((value) {
          if (value["created_at"] != null) {
            DateTime valueDate = DateTime.parse(value["created_at"].toString());
            if (valueDate.year == _now.year &&
                valueDate.month == _now.month &&
                valueDate.day == _now.day) {
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
      } else {
        showSnackBar(body["message"].toString(), globalKey);
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
    if (isHomeFirstTime) {
      _loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.026,
                    left: width * 0.02,
                    right: width * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Гарах"),
                              content:
                                  const Text("Та гарахдаа итгэлтэй байна уу?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    back(context);
                                  },
                                  child: const Text("Үгүй"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    token = null;
                                    user = null;
                                    historyItems.clear();
                                    nowItems.clear();
                                    goAndClear(context, const AuthPage());
                                  },
                                  child: const Text("Тийм"),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.close,
                          color: kPrimaryColor,
                        ),
                      ),
                      const Ctext(
                        text: "Өнөөдөр",
                        large: true,
                        bold: true,
                      ),
                      IconButton(
                        onPressed: () {
                          if (!_isLoad) {
                            _loadData();
                          }
                        },
                        icon: Icon(
                          Icons.refresh,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.03,
                    left: width * 0.06,
                    right: width * 0.06,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ShakeWidget(
                            child: InkWell(
                              onTap: () {
                                _audioCache.play('horse.mp3');
                              },
                              child: Image.asset(
                                "assets/images/horse.png",
                                height: height * 0.1,
                                width: height * 0.1,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Ctext(
                            text: horseCount.toString(),
                            normal: true,
                            bold: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ShakeWidget(
                            child: InkWell(
                              onTap: () {
                                _audioCache.play('cow.mp3');
                              },
                              child: Image.asset(
                                "assets/images/cattle.png",
                                height: height * 0.1,
                                width: height * 0.1,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Ctext(
                            text: cattleCount.toString(),
                            normal: true,
                            bold: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ShakeWidget(
                            child: InkWell(
                              onTap: () {
                                _audioCache.play('camel.mp3');
                              },
                              child: Image.asset(
                                "assets/images/camel.png",
                                height: height * 0.1,
                                width: height * 0.1,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Ctext(
                            text: camelCount.toString(),
                            normal: true,
                            bold: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.03,
                    left: width * 0.18,
                    right: width * 0.18,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          ShakeWidget(
                            child: InkWell(
                              onTap: () {
                                _audioCache.play('sheep.mp3');
                              },
                              child: Image.asset(
                                "assets/images/sheep.png",
                                height: height * 0.1,
                                width: height * 0.1,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Ctext(
                            text: sheepCount.toString(),
                            normal: true,
                            bold: true,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ShakeWidget(
                            child: InkWell(
                              onTap: () {
                                _audioCache.play('goat.mp3');
                              },
                              child: Image.asset(
                                "assets/images/goat.png",
                                height: height * 0.1,
                                width: height * 0.1,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          Ctext(
                            text: goatCount.toString(),
                            normal: true,
                            bold: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.08),
                if (_isLoad)
                  SizedBox(
                    height: height * 0.04,
                    width: height * 0.04,
                    child: const CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        kPrimaryColor,
                      ),
                    ),
                  ),
                if (!_isLoad) _menuItems(height, width),
                SizedBox(height: height * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItems(double height, double width) => Column(
        children: [
          CSizedButton(
            cheight: 0.05,
            cwidth: 0.8,
            text: "Малын тоо толгой бүртгэх",
            normal: true,
            onPress: () {
              go(context, AddPage(
                onChange: () {
                  setState(() {});
                },
              ));
            },
            isLoad: false,
          ),
          SizedBox(height: height * 0.03),
          CSizedButton(
            cheight: 0.05,
            cwidth: 0.8,
            text: "Өмнөх тооллогын дэлгэрэнгүй",
            normal: true,
            onPress: () {
              go(context, HistoryPage(
                onChange: () {
                  setState(() {});
                },
              ));
            },
            isLoad: false,
          ),
        ],
      );
}

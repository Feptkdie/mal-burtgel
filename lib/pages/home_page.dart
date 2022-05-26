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
import 'package:too/pages/mail/mail_page.dart';
import 'package:too/pages/profile/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _launchUrl(String url) async {
    String temp = "tel:" + url;
    if (!await launchUrl(Uri.parse(temp))) throw 'Could not launch $temp';
  }

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
        body["animals"].reversed.forEach((value) {
          historyItems.add(value);
        });
        allHorseCount = body["horseCount"];
        allCattleCount = body["cattleCount"];
        allCamelCount = body["camelCount"];
        allSheepCount = body["sheepCount"];
        allGoatCount = body["goatCount"];
        nowItems.clear();
        sheepCount = 0;
        goatCount = 0;
        camelCount = 0;
        horseCount = 0;
        allAnimalCount = 0;

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
            if (valueDate.year == _now.year &&
                valueDate.month == _now.month &&
                valueDate.day == _now.day) {
              nowItems.add(value);
              allAnimalCount += int.parse(value["amount"].toString());
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
    String id = "0";
    if (user["status"] == "Засаг дарга") {
      id = user["id"].toString();
    } else {
      id = user["owner_id"].toString();
    }
    final response2 = await https.post(
      Uri.parse(mainApiUrl + "get-mail"),
      body: {"owner_id": id},
    );
    print(response2.body);
    if (response2.statusCode == 201) {
      var body = json.decode(response2.body);
      if (body["status"]) {
        mailItems.clear();
        body["mails"].forEach((value) {
          mailItems.add(value);
        });
      } else {
        showSnackBar(body["message"].toString(), globalKey);
      }
    } else {
      showSnackBar("Сервер алдаа гарлаа", globalKey);
    }

    if (user["status"] == "Засаг дарга") {
      await _getWorker();
    }

    if (mounted) {
      setState(() {
        _isLoad = false;
      });
    }
  }

  Future<void> _getWorker() async {
    setState(() {
      _isLoad = true;
    });

    final response = await https.post(
      Uri.parse(mainApiUrl + "get-worker"),
      body: {"owner_id": user["id"].toString()},
    );
    print(response.body);
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        workerItems.clear();
        body["users"].forEach((value) {
          workerItems.add(value);
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
        _isLoad = true;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          go(context, const MailPage());
        },
        child: const Icon(
          Icons.mail,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
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
                          go(context, const ProfilePage());
                        },
                        icon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                      ),
                      const Ctext(
                        text: "Нийт",
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
                            text: allHorseCount.toString(),
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
                            text: allCattleCount.toString(),
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
                            text: allCamelCount.toString(),
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
                            text: allSheepCount.toString(),
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
                            text: allGoatCount.toString(),
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
                if (user["status"] == "Засаг дарга") _worker(height, width),
                SizedBox(height: height * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _worker(double height, double width) => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: width * 0.06,
                top: height * 0.04,
              ),
              child: Text(
                "Малчид",
                style: TextStyle(
                  fontSize: height * 0.022,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.02,
              bottom: height * 0.04,
            ),
            child: Column(
              children: List.generate(
                workerItems.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.02,
                    left: width * 0.08,
                    right: width * 0.08,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0.1,
                          blurRadius: 5,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            _launchUrl(workerItems[index]["phone"]);
                          },
                          child: SizedBox(
                            height: height * 0.1,
                            width: width,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: width * 0.04,
                                left: width * 0.04,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            workerItems[index]["surname"]
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: height * 0.02,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            workerItems[index]["phone"]
                                                .toString(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: height * 0.016,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            workerItems[index]["created_at"]
                                                .substring(0, 10),
                                            style: TextStyle(
                                              fontSize: height * 0.016,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                            size: height * 0.026,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

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
            text: "Өмнөх тооллогын түүх",
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:too/constants.dart';
import 'package:too/data.dart';
import 'package:too/helpers/api_url.dart';
import 'package:too/helpers/app_preferences.dart';
import 'package:too/helpers/components.dart';
import 'package:http/http.dart' as https;
import 'package:too/pages/edit/edit_page.dart';

class HistoryPage extends StatefulWidget {
  final VoidCallback onChange;
  const HistoryPage({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = "Өнөөдөр";

  Future<void> _deleteRequest(int index) async {
    loading(true, context);

    final response = await https.post(
      Uri.parse(mainApiUrl + "delete-animal"),
      body: {"id": nowItems[index]["id"].toString()},
    );

    print(response.body);
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        showSnackBar(body["message"], globalKey);
        nowItems.clear();
        body["animals"].forEach((value) {
          nowItems.add(value);
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
              allAnimalCount = int.parse(value["amount"].toString());
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
        setState(() {});
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
      loading(false, context);
      back(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return WillPopScope(
      onWillPop: () {
        widget.onChange.call();
        back(context);
        return Future<bool>.value(true);
      },
      child: Scaffold(
        key: globalKey,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            onPressed: () {
              widget.onChange.call();
              back(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          title: const Ctext(
            text: "Тооллогын түүх",
            large: true,
            color: Colors.white,
          ),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            children: [
              SizedBox(height: height * 0.01),
              _filter(height, width),
              if (_selectedFilter == "Өнөөдөр") _count(height, width),
              if (_selectedFilter == "1 сар") _count2(height, width),
              if (_selectedFilter == "3 сар") _count3(height, width),
              if (_selectedFilter == "1 жил") _count4(height, width),
              if (_selectedFilter == "Өнөөдөр") _listItem(height, width),
              if (_selectedFilter == "1 сар") _listItem2(height, width),
              if (_selectedFilter == "3 сар") _listItem3(height, width),
              if (_selectedFilter == "1 жил") _listItem4(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _count4(double height, double width) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Хонь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      sheepCount4.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ямаа: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goatCount4.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Морь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      horseCount4.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Тэмээ: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      camelCount4.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.26),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Үхэр: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cattleCount4.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _count3(double height, double width) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Хонь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      sheepCount3.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ямаа: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goatCount3.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Морь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      horseCount3.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Тэмээ: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      camelCount3.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.26),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Үхэр: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cattleCount3.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _count2(double height, double width) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Хонь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      sheepCount2.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ямаа: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goatCount2.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Морь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      horseCount2.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Тэмээ: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      camelCount2.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.26),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Үхэр: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cattleCount2.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _count(double height, double width) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Хонь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      sheepCount.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Ямаа: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goatCount.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Морь: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      horseCount.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
              left: width * 0.05,
              right: width * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Тэмээ: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      camelCount.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: width * 0.26),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Үхэр: ",
                      style: TextStyle(
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      cattleCount.toString(),
                      style: TextStyle(
                        fontSize: height * 0.02,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _filter(double height, double width) => Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.03),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = "Өнөөдөр";
                    });
                  },
                  child: Text(
                    "Өнөөдөр",
                    style: TextStyle(
                      color: _selectedFilter == "Өнөөдөр"
                          ? kPrimaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = "1 сар";
                    });
                  },
                  child: Text(
                    "1 сар",
                    style: TextStyle(
                      color: _selectedFilter == "1 сар"
                          ? kPrimaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = "3 сар";
                    });
                  },
                  child: Text(
                    "3 сар",
                    style: TextStyle(
                      color: _selectedFilter == "3 сар"
                          ? kPrimaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = "1 жил";
                    });
                  },
                  child: Text(
                    "1 жил",
                    style: TextStyle(
                      color: _selectedFilter == "1 жил"
                          ? kPrimaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _listItem4(double height, double width) => Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: year1Items.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? height * 0.03 : height * 0.024,
                      left: width * 0.04,
                      right: width * 0.04,
                      bottom: index == (year1Items.length - 1)
                          ? height * 0.04
                          : 0.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1.0,
                            blurRadius: 3.0,
                            offset: Offset(0.0, 3.0),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Дэлгэрэнгүй"),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width: width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (year1Items[index]["name"] == "Хонь")
                                          Image.asset(
                                            "assets/images/sheep.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (year1Items[index]["name"] == "Ямаа")
                                          Image.asset(
                                            "assets/images/goat.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (year1Items[index]["name"] == "Үхэр")
                                          Image.asset(
                                            "assets/images/cattle.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (year1Items[index]["name"] == "Морь")
                                          Image.asset(
                                            "assets/images/horse.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (year1Items[index]["name"] ==
                                            "Тэмээ")
                                          Image.asset(
                                            "assets/images/camel.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: year1Items[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: year1Items[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: year1Items[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 4,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (year1Items[index]["comment"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шалтгаан:\n" +
                                                    year1Items[index]["comment"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (year1Items[index]["alive1"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шинээр ирсэн:\n" +
                                                    year1Items[index]["alive1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (year1Items[index]["alive2"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Айлаас ирсэн:\n" +
                                                    year1Items[index]["alive2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (year1Items[index]["alive3"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Тавиур:\n" +
                                                    year1Items[index]["alive3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (year1Items[index]["dead1"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Үхсэн:\n" +
                                                    year1Items[index]["dead1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (year1Items[index]["dead2"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Зарсан:\n" +
                                                    year1Items[index]["dead2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (year1Items[index]["dead3"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Идсэн:\n" +
                                                    year1Items[index]["dead3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      back(context);
                                    },
                                    child: const Text("ХААХ"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: SizedBox(
                            height: height * 0.16,
                            width: width * 0.9,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                right: width * 0.04,
                              ),
                              child: Row(
                                children: [
                                  if (year1Items[index]["name"] == "Хонь")
                                    Image.asset(
                                      "assets/images/sheep.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (year1Items[index]["name"] == "Ямаа")
                                    Image.asset(
                                      "assets/images/goat.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (year1Items[index]["name"] == "Үхэр")
                                    Image.asset(
                                      "assets/images/cattle.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (year1Items[index]["name"] == "Морь")
                                    Image.asset(
                                      "assets/images/horse.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (year1Items[index]["name"] == "Тэмээ")
                                    Image.asset(
                                      "assets/images/camel.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  SizedBox(width: width * 0.04),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: year1Items[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: year1Items[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: year1Items[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          go(
                                            context,
                                            EditPage(
                                              onChange: () {
                                                setState(() {});
                                              },
                                              index: index,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      Container(
                                        width: width * 0.06,
                                        height: 1.5,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Устгах"),
                                              content: const Text(
                                                  "Та устгахдаа итгэлтэй байна уу"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    back(context);
                                                  },
                                                  child: const Text("ҮГҮЙ"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteRequest(index);
                                                  },
                                                  child: const Text("ТИЙМ"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
        ),
      );

  Widget _listItem3(double height, double width) => Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: month3Items.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? height * 0.03 : height * 0.024,
                      left: width * 0.04,
                      right: width * 0.04,
                      bottom: index == (month3Items.length - 1)
                          ? height * 0.04
                          : 0.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1.0,
                            blurRadius: 3.0,
                            offset: Offset(0.0, 3.0),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Дэлгэрэнгүй"),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width: width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (month3Items[index]["name"] ==
                                            "Хонь")
                                          Image.asset(
                                            "assets/images/sheep.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month3Items[index]["name"] ==
                                            "Ямаа")
                                          Image.asset(
                                            "assets/images/goat.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month3Items[index]["name"] ==
                                            "Үхэр")
                                          Image.asset(
                                            "assets/images/cattle.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month3Items[index]["name"] ==
                                            "Морь")
                                          Image.asset(
                                            "assets/images/horse.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month3Items[index]["name"] ==
                                            "Тэмээ")
                                          Image.asset(
                                            "assets/images/camel.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month3Items[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month3Items[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: month3Items[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 4,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (month3Items[index]["comment"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шалтгаан:\n" +
                                                    month3Items[index]
                                                            ["comment"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month3Items[index]["alive1"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шинээр ирсэн:\n" +
                                                    month3Items[index]["alive1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month3Items[index]["alive2"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Айлаас ирсэн:\n" +
                                                    month3Items[index]["alive2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month3Items[index]["alive3"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Тавиур:\n" +
                                                    month3Items[index]["alive3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month3Items[index]["dead1"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Үхсэн:\n" +
                                                    month3Items[index]["dead1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month3Items[index]["dead2"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Зарсан:\n" +
                                                    month3Items[index]["dead2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month3Items[index]["dead3"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Идсэн:\n" +
                                                    month3Items[index]["dead3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      back(context);
                                    },
                                    child: const Text("ХААХ"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: SizedBox(
                            height: height * 0.16,
                            width: width * 0.9,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                right: width * 0.04,
                              ),
                              child: Row(
                                children: [
                                  if (month3Items[index]["name"] == "Хонь")
                                    Image.asset(
                                      "assets/images/sheep.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month3Items[index]["name"] == "Ямаа")
                                    Image.asset(
                                      "assets/images/goat.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month3Items[index]["name"] == "Үхэр")
                                    Image.asset(
                                      "assets/images/cattle.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month3Items[index]["name"] == "Морь")
                                    Image.asset(
                                      "assets/images/horse.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month3Items[index]["name"] == "Тэмээ")
                                    Image.asset(
                                      "assets/images/camel.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  SizedBox(width: width * 0.04),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month3Items[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month3Items[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: month3Items[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          go(
                                            context,
                                            EditPage(
                                              onChange: () {
                                                setState(() {});
                                              },
                                              index: index,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      Container(
                                        width: width * 0.06,
                                        height: 1.5,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Устгах"),
                                              content: const Text(
                                                  "Та устгахдаа итгэлтэй байна уу"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    back(context);
                                                  },
                                                  child: const Text("ҮГҮЙ"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteRequest(index);
                                                  },
                                                  child: const Text("ТИЙМ"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
        ),
      );

  Widget _listItem2(double height, double width) => Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: month1Items.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? height * 0.03 : height * 0.024,
                      left: width * 0.04,
                      right: width * 0.04,
                      bottom: index == (month1Items.length - 1)
                          ? height * 0.04
                          : 0.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1.0,
                            blurRadius: 3.0,
                            offset: Offset(0.0, 3.0),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Дэлгэрэнгүй"),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width: width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (month1Items[index]["name"] ==
                                            "Хонь")
                                          Image.asset(
                                            "assets/images/sheep.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month1Items[index]["name"] ==
                                            "Ямаа")
                                          Image.asset(
                                            "assets/images/goat.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month1Items[index]["name"] ==
                                            "Үхэр")
                                          Image.asset(
                                            "assets/images/cattle.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month1Items[index]["name"] ==
                                            "Морь")
                                          Image.asset(
                                            "assets/images/horse.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (month1Items[index]["name"] ==
                                            "Тэмээ")
                                          Image.asset(
                                            "assets/images/camel.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month1Items[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month1Items[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: month1Items[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 4,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (month1Items[index]["comment"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шалтгаан:\n" +
                                                    month1Items[index]
                                                            ["comment"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month1Items[index]["alive1"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шинээр ирсэн:\n" +
                                                    month1Items[index]["alive1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month1Items[index]["alive2"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Айлаас ирсэн:\n" +
                                                    month1Items[index]["alive2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month1Items[index]["alive3"] !=
                                            null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Тавиур:\n" +
                                                    month1Items[index]["alive3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month1Items[index]["dead1"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Үхсэн:\n" +
                                                    month1Items[index]["dead1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month1Items[index]["dead2"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Зарсан:\n" +
                                                    month1Items[index]["dead2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (month1Items[index]["dead3"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Идсэн:\n" +
                                                    month1Items[index]["dead3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      back(context);
                                    },
                                    child: const Text("ХААХ"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: SizedBox(
                            height: height * 0.16,
                            width: width * 0.9,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                right: width * 0.04,
                              ),
                              child: Row(
                                children: [
                                  if (month1Items[index]["name"] == "Хонь")
                                    Image.asset(
                                      "assets/images/sheep.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month1Items[index]["name"] == "Ямаа")
                                    Image.asset(
                                      "assets/images/goat.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month1Items[index]["name"] == "Үхэр")
                                    Image.asset(
                                      "assets/images/cattle.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month1Items[index]["name"] == "Морь")
                                    Image.asset(
                                      "assets/images/horse.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (month1Items[index]["name"] == "Тэмээ")
                                    Image.asset(
                                      "assets/images/camel.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  SizedBox(width: width * 0.04),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month1Items[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: month1Items[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: month1Items[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          go(
                                            context,
                                            EditPage(
                                              onChange: () {
                                                setState(() {});
                                              },
                                              index: index,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      Container(
                                        width: width * 0.06,
                                        height: 1.5,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Устгах"),
                                              content: const Text(
                                                  "Та устгахдаа итгэлтэй байна уу"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    back(context);
                                                  },
                                                  child: const Text("ҮГҮЙ"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteRequest(index);
                                                  },
                                                  child: const Text("ТИЙМ"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
        ),
      );

  Widget _listItem(double height, double width) => Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: nowItems.length,
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? height * 0.03 : height * 0.024,
                      left: width * 0.04,
                      right: width * 0.04,
                      bottom:
                          index == (nowItems.length - 1) ? height * 0.04 : 0.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 1.0,
                            blurRadius: 3.0,
                            offset: Offset(0.0, 3.0),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ],
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8.0),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Дэлгэрэнгүй"),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                    width: width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (nowItems[index]["name"] == "Хонь")
                                          Image.asset(
                                            "assets/images/sheep.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (nowItems[index]["name"] == "Ямаа")
                                          Image.asset(
                                            "assets/images/goat.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (nowItems[index]["name"] == "Үхэр")
                                          Image.asset(
                                            "assets/images/cattle.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (nowItems[index]["name"] == "Морь")
                                          Image.asset(
                                            "assets/images/horse.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        if (nowItems[index]["name"] == "Тэмээ")
                                          Image.asset(
                                            "assets/images/camel.png",
                                            height: height * 0.1,
                                            width: height * 0.1,
                                          ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: nowItems[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: nowItems[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: nowItems[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 4,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (nowItems[index]["comment"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шалтгаан:\n" +
                                                    nowItems[index]["comment"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (nowItems[index]["alive1"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Шинээр ирсэн:\n" +
                                                    nowItems[index]["alive1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (nowItems[index]["alive2"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Айлаас ирсэн:\n" +
                                                    nowItems[index]["alive2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (nowItems[index]["alive3"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Тавиур:\n" +
                                                    nowItems[index]["alive3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (nowItems[index]["dead1"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Үхсэн:\n" +
                                                    nowItems[index]["dead1"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (nowItems[index]["dead2"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Зарсан:\n" +
                                                    nowItems[index]["dead2"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                        if (nowItems[index]["dead3"] != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: height * 0.02,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Ctext(
                                                text: "Идсэн:\n" +
                                                    nowItems[index]["dead3"]
                                                        .toString(),
                                                maxLine: 100,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                normal: true,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      back(context);
                                    },
                                    child: const Text("ХААХ"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: SizedBox(
                            height: height * 0.16,
                            width: width * 0.9,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: width * 0.06,
                                right: width * 0.04,
                              ),
                              child: Row(
                                children: [
                                  if (nowItems[index]["name"] == "Хонь")
                                    Image.asset(
                                      "assets/images/sheep.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (nowItems[index]["name"] == "Ямаа")
                                    Image.asset(
                                      "assets/images/goat.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (nowItems[index]["name"] == "Үхэр")
                                    Image.asset(
                                      "assets/images/cattle.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (nowItems[index]["name"] == "Морь")
                                    Image.asset(
                                      "assets/images/horse.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (nowItems[index]["name"] == "Тэмээ")
                                    Image.asset(
                                      "assets/images/camel.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  SizedBox(width: width * 0.04),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: nowItems[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: nowItems[index]["amount"]
                                                    .toString() +
                                                " ширхэг",
                                            maxLine: 2,
                                            textOverflow: TextOverflow.ellipsis,
                                            normal: true,
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: kPrimaryColor
                                                    .withOpacity(0.6),
                                              ),
                                              Expanded(
                                                child: Ctext(
                                                  text: nowItems[index]
                                                          ["address"]
                                                      .toString(),
                                                  maxLine: 1,
                                                  textOverflow:
                                                      TextOverflow.ellipsis,
                                                  normal: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          go(
                                            context,
                                            EditPage(
                                              onChange: () {
                                                setState(() {});
                                              },
                                              index: index,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      Container(
                                        width: width * 0.06,
                                        height: 1.5,
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text("Устгах"),
                                              content: const Text(
                                                  "Та устгахдаа итгэлтэй байна уу"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    back(context);
                                                  },
                                                  child: const Text("ҮГҮЙ"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteRequest(index);
                                                  },
                                                  child: const Text("ТИЙМ"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
        ),
      );
}

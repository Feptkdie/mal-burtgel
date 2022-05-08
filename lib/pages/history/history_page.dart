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

  Future<void> _deleteRequest(int index) async {
    loading(true, context);

    final response = await https.post(
      Uri.parse(mainApiUrl + "delete-animal"),
      body: {"id": historyItems[index]["id"].toString()},
    );

    print(response.body);
    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      if (body["status"]) {
        showSnackBar(body["message"], globalKey);
        historyItems.clear();
        body["animals"].forEach((value) {
          historyItems.add(value);
        });
        horseCount = body["horseCount"];
        cattleCount = body["cattleCount"];
        camelCount = body["camelCount"];
        sheepCount = body["sheepCount"];
        goatCount = body["goatCount"];
        allAnimalCount = body["allAnimalCount"];
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
              _listItem(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(double height, double width) => Expanded(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: historyItems.length,
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
                      bottom: index == (historyItems.length - 1)
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (historyItems[index]["name"] == "Хонь")
                                        Image.asset(
                                          "assets/images/sheep.png",
                                          height: height * 0.1,
                                          width: height * 0.1,
                                        ),
                                      if (historyItems[index]["name"] == "Ямаа")
                                        Image.asset(
                                          "assets/images/goat.png",
                                          height: height * 0.1,
                                          width: height * 0.1,
                                        ),
                                      if (historyItems[index]["name"] == "Үхэр")
                                        Image.asset(
                                          "assets/images/cattle.png",
                                          height: height * 0.1,
                                          width: height * 0.1,
                                        ),
                                      if (historyItems[index]["name"] == "Морь")
                                        Image.asset(
                                          "assets/images/horse.png",
                                          height: height * 0.1,
                                          width: height * 0.1,
                                        ),
                                      if (historyItems[index]["name"] ==
                                          "Тэмээ")
                                        Image.asset(
                                          "assets/images/camel.png",
                                          height: height * 0.1,
                                          width: height * 0.1,
                                        ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Ctext(
                                          text: historyItems[index]["name"]
                                              .toString(),
                                          normal: true,
                                          textOverflow: TextOverflow.ellipsis,
                                          bold: true,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Ctext(
                                          text: historyItems[index]["amount"]
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
                                                text: historyItems[index]
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
                                      if (historyItems[index]["comment"] !=
                                          null)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: height * 0.02,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Ctext(
                                              text: "Шалтгаан:\n" +
                                                  historyItems[index]["comment"]
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
                                  if (historyItems[index]["name"] == "Хонь")
                                    Image.asset(
                                      "assets/images/sheep.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (historyItems[index]["name"] == "Ямаа")
                                    Image.asset(
                                      "assets/images/goat.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (historyItems[index]["name"] == "Үхэр")
                                    Image.asset(
                                      "assets/images/cattle.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (historyItems[index]["name"] == "Морь")
                                    Image.asset(
                                      "assets/images/horse.png",
                                      height: height * 0.1,
                                      width: height * 0.1,
                                    ),
                                  if (historyItems[index]["name"] == "Тэмээ")
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
                                            text: historyItems[index]["name"]
                                                .toString(),
                                            normal: true,
                                            textOverflow: TextOverflow.ellipsis,
                                            bold: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Ctext(
                                            text: historyItems[index]["amount"]
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
                                                  text: historyItems[index]
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

import 'package:flutter/material.dart';
import 'package:too/constants.dart';
import 'package:too/helpers/components.dart';

import '../../data.dart';
import '../../helpers/app_preferences.dart';
import '../auth/auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

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
          text: "Хэрэглэгч",
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
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  right: width * 0.04,
                  top: height * 0.01,
                ),
                child: Row(
                  children: [
                    Text(
                      "Нэр:",
                      style: TextStyle(
                        fontSize: height * 0.022,
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      user["surname"],
                      style: TextStyle(
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  right: width * 0.04,
                  top: height * 0.01,
                ),
                child: Row(
                  children: [
                    Text(
                      "Утас:",
                      style: TextStyle(
                        fontSize: height * 0.022,
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      user["phone"],
                      style: TextStyle(
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.04,
                  right: width * 0.04,
                  top: height * 0.01,
                ),
                child: Row(
                  children: [
                    Text(
                      "Статус:",
                      style: TextStyle(
                        fontSize: height * 0.022,
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      user["status"],
                      style: TextStyle(
                        fontSize: height * 0.024,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (user["status"] == "Малчин")
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    right: width * 0.04,
                    top: height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Даргын нэр:",
                        style: TextStyle(
                          fontSize: height * 0.022,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        user["owner_name"],
                        style: TextStyle(
                          fontSize: height * 0.024,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (user["status"] == "Малчин")
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    right: width * 0.04,
                    top: height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Даргын утас:",
                        style: TextStyle(
                          fontSize: height * 0.022,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        user["owner_phone"],
                        style: TextStyle(
                          fontSize: height * 0.024,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (user["status"] == "Засаг дарга")
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    right: width * 0.04,
                    top: height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Нийт малчин:",
                        style: TextStyle(
                          fontSize: height * 0.022,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        workerItems.length.toString(),
                        style: TextStyle(
                          fontSize: height * 0.024,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (user["status"] == "Засаг дарга")
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.04,
                    right: width * 0.04,
                    top: height * 0.01,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Нийт мал:",
                        style: TextStyle(
                          fontSize: height * 0.022,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        allAllAnimalCount.toString(),
                        style: TextStyle(
                          fontSize: height * 0.024,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: width * 0.04),
                  child: TextButton(
                    onPressed: () {
                      _logout();
                    },
                    child: const Text("Гарах"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Гарах"),
        content: const Text("Та гарахдаа итгэлтэй байна уу?"),
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
  }
}

import 'package:flutter/material.dart';
import 'package:too/constants.dart';
import 'package:too/helpers/components.dart';
import 'package:too/pages/add_mail/add_mail_page.dart';

import '../../data.dart';
import '../../helpers/app_preferences.dart';

class MailPage extends StatefulWidget {
  const MailPage({Key? key}) : super(key: key);

  @override
  State<MailPage> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = size(context).height;
    double width = size(context).width;
    return Scaffold(
      key: globalKey,
      floatingActionButton: user["status"] == "Засаг дарга"
          ? FloatingActionButton(
              onPressed: () {
                go(context, const AddMailPage());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Ctext(
          text: "Захидал",
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
            children: [
              SizedBox(height: height * 0.02),
              Column(
                children: List.generate(
                  mailItems.length,
                  (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: height * 0.02,
                        left: width * 0.04,
                        right: width * 0.04,
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
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        mailItems[index]["title"].toString()),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(mailItems[index]["content"]
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: height * 0.08,
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
                                                mailItems[index]["title"]
                                                    .toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: height * 0.02,
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
                                                mailItems[index]["created_at"]
                                                    .substring(0, 10),
                                                style: TextStyle(
                                                  fontSize: height * 0.016,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.mark_email_unread,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

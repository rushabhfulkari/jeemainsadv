import 'package:flutter/material.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

double appVersion = 2.0;
void versionCheck(BuildContext ctx, dbReference) {
  dbReference.child("Version").once().then((value) {
    double version = double.parse(value.value['v'].toString());
    String cu = value.value['cu'].toString();
    String show = value.value['s'].toString();
    String link = value.value['l'].toString();
    if (show == "yes") {
      if (appVersion < version) {
        showDialog(
          barrierDismissible: (cu == "no"),
          context: ctx,
          builder: (ctx) {
            return WillPopScope(
              onWillPop: () async => (cu == "no"),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 350,
                  height: 180,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SizedBox(
                    height: 10,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 0,
                              ),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Update Available!',
                                          style: TextStyle(color: white)),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Click on Update',
                                          style: TextStyle(color: white)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: GestureDetector(
                                  onTap: () async {
                                    _launchURL(
                                        "https://play.google.com/store/apps/details?id=com.dts.jeemainsadv");
                                  },
                                  child: Container(
                                      height: 45,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: cyan),
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 22),
                                                child: Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: "Update",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  });
}

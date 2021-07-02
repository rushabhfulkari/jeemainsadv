import 'package:flutter/material.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/services/feedback.dart';
import 'package:jeemainsadv/widgets/pdfview.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: cyan,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: black,
                  border: Border.all(color: black),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: AssetImage('assets/JEE.png'),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "JEE Prep",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Solved JEE Mains & Advanced Papers",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: black,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      ListTile(
        onTap: () {
          LaunchReview.launch(androidAppId: "com.dts.jeemainsadv");
        },
        leading: Icon(
          Icons.star,
          color: black,
          size: 30,
        ),
        title: Text(
          "Rate Us",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          _launchURL(
              'https://play.google.com/store/search?q=pub%3ADEVTAS&c=apps');
        },
        leading: Icon(
          Icons.apps_rounded,
          color: black,
          size: 30,
        ),
        title: Text(
          "More Apps",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GetFeedback()),
          );
        },
        leading: Icon(
          Icons.email_rounded,
          color: black,
          size: 30,
        ),
        title: Text(
          "Feedback",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          _showMyDialog();
        },
        leading: Icon(
          Icons.shield,
          color: black,
          size: 30,
        ),
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
      ),
      ListTile(
        onTap: () {
          _onShare(context);
        },
        leading: Icon(
          Icons.share,
          color: black,
          size: 30,
        ),
        title: Text(
          "Share this App",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),
      ),
    ]);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Privacy Policy'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "This Privacy Policy is only applicable if you have downloaded this App from the developer DEVTAS.\n\nDEVTAS built the JEEPrep app as a Free app.\n\nThis SERVICE is provided by DEVTAS at no cost and is intended for use as is.\n\nCopyright: DEVTAS. ALL RIGHTS RESERVED."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;

    await Share.share(
        "JEE Prep\n\nJEE Mains and Advanced Solved Papers\n\nIndia's best JEE preparation app\n\nAvailable on Play Store for Free\n\nlink:\nhttps://play.google.com/store/apps/details?id=com.dts.jeemainsadv",
        subject: "Share",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/main.dart';
import 'package:jeemainsadv/papersandsysllabus/papers/jeeadvpaper.dart';
import 'package:jeemainsadv/papersandsysllabus/papers/jeemainspaper.dart';
import 'package:jeemainsadv/papersandsysllabus/syllabus/jeeadvsys.dart';
import 'package:jeemainsadv/papersandsysllabus/syllabus/jeemainssys.dart';
import 'package:jeemainsadv/papersandsysllabus/unsolvedpapers/jeeadvunsolved.dart';
import 'package:jeemainsadv/papersandsysllabus/unsolvedpapers/jeemainsunsolved.dart';
import 'package:jeemainsadv/services/version_check.dart';
import 'package:jeemainsadv/widgets/slide.dart';
import 'package:jeemainsadv/widgets/widgets.dart';
import 'package:jeemainsadv/widgets/main_drawer.dart';
import 'package:share/share.dart';

class Home extends StatefulWidget {
  bool shown;
  Home({@required this.shown = false});
  @override
  _HomeState createState() => _HomeState(shown);
}

class _HomeState extends State<Home> {
  bool shown;
  _HomeState(this.shown);

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }

  void initState() {
    super.initState();
    DatabaseReference userDbReferece;
    userDbReferece = FirebaseDatabase.instance.reference();
    if (shown == false) {
      versionCheck(context, userDbReferece);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: cyan,
                playSound: true,
                icon: '@mipmap/launcher_icon',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return Home(
                shown: true,
              );
            });
      }
    });
    _initGoogleMobileAds();
    _bannerAd = BannerAd(
      // adUnitId: BannerAd.testAdUnitId,
      adUnitId: "ca-app-pub-6749113501960121/9184097908",
      request: AdRequest(),
      size: AdSize.smartBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
          print("rush");
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  // void showNotification() {
  //   flutterLocalNotificationsPlugin.show(
  //       0,
  //       "Testing",
  //       "How you doin ?",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //               channel.id, channel.name, channel.description,
  //               importance: Importance.high,
  //               color: cyan,
  //               playSound: true,
  //               icon: '@mipmap/launcher_icon')));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: cyan, //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
          child: MainDrawer(),
        ),
      ),
      backgroundColor: cyan,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            Icons.menu_rounded,
                            color: black,
                            size: 30,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Stack(children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'JEE',
                                style: TextStyle(
                                    color: black, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text: ' Prep',
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 35,
                          child: InkWell(
                            onTap: () {
                              _onShare(context);
                            },
                            child: Center(
                                child: Container(
                                    child: Icon(
                              Icons.share,
                              size: 30,
                              color: black,
                            ))),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView(
                        padding: EdgeInsets.only(
                            bottom: _getSmartBannerHeight(context) / 1.3),
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, SlideRightRoute(page: PaperMains()));
                            },
                            child: Container(
                              height: 75,
                              width: 20,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ).copyWith(
                                bottom: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: <Color>[
                                    cyan_light,
                                    cyan_light
                                  ], // red to yellow
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          AssetImage('assets/solved.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "JEE Mains Solved Papers\n (20 Years: 2002 to 2021)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.height / 50,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, SlideRightRoute(page: PaperAdv()));
                            },
                            child: Container(
                              height: 75,
                              width: 20,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ).copyWith(
                                bottom: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: <Color>[
                                    cyan,
                                    cyan_light
                                  ], // red to yellow
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          AssetImage('assets/solved.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "JEE Adv Solved Papers\n (14 Years: 2007 to 2020)",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.height / 50,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  SlideRightRoute(page: UnsolvedMains()));
                            },
                            child: Container(
                              height: 75,
                              width: 20,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ).copyWith(
                                bottom: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: <Color>[
                                    cyan_light,
                                    cyan_light
                                  ], // red to yellow
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          AssetImage('assets/unsolved.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "JEE Mains Unsolved\nPapers",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.height / 50,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  SlideRightRoute(page: UnsolvedAdv()));
                            },
                            child: Container(
                              height: 75,
                              width: 20,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ).copyWith(
                                bottom: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: <Color>[
                                    cyan,
                                    cyan_light
                                  ], // red to yellow
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          AssetImage('assets/unsolved.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "JEE Adv Unsolved\nPapers",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.height / 50,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  SlideRightRoute(page: SysllabusMain()));
                            },
                            child: Container(
                              height: 75,
                              width: 20,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ).copyWith(
                                bottom: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: <Color>[
                                    cyan_light,
                                    cyan_light
                                  ], // red to yellow
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          AssetImage('assets/syllabus.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "JEE Mains Syllabus",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.height / 50,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  SlideRightRoute(page: SysllabusAdv()));
                            },
                            child: Container(
                              height: 75,
                              width: 20,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                              ).copyWith(
                                bottom: 15,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment
                                      .bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: <Color>[
                                    cyan,
                                    cyan_light
                                  ], // red to yellow
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    flex: 0,
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          AssetImage('assets/syllabus.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "JEE Advanced Syllabus",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: size.height / 50,
                                        fontWeight: FontWeight.bold,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (_isBannerAdReady)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: size.width,
                    height: _getSmartBannerHeight(context),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  double _getSmartBannerHeight(BuildContext context) {
    MediaQueryData mediaScreen = MediaQuery.of(context);
    double dpHeight = mediaScreen.orientation == Orientation.portrait
        ? mediaScreen.size.height
        : mediaScreen.size.width;
    if (dpHeight <= 400.0) {
      return 32.0;
    }
    if (dpHeight > 720.0) {
      return 90.0;
    }
    return 50.0;
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;

    await Share.share(
        "JEE Prep\n\nJEE Mains and Advanced Solved Papers\n\nIndia's best JEE preparation app\n\nAvailable on Play Store for Free\n\nlink:\nhttps://play.google.com/store/apps/details?id=com.dts.jeemainsadv",
        subject: "Share",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

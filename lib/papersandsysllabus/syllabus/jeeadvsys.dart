import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/services/firebase.dart';
import 'package:jeemainsadv/widgets/pdfview.dart';
import 'package:jeemainsadv/widgets/widgets.dart';

class SysllabusAdv extends StatefulWidget {
  @override
  _SysllabusAdvState createState() => _SysllabusAdvState();
}

class _SysllabusAdvState extends State<SysllabusAdv> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  late File file;
  final List<String> entries = <String>['Physics', 'Chemistry', 'Mathematics'];
  final List<String> icons = <String>['physics', 'chemistry', 'maths'];
  final List<String> pdfnames = <String>[
    '/JEE Adv syllabus/physics_syllabus.pdf',
    '/JEE Adv syllabus/chemistry_syllabus.pdf',
    '/JEE Adv syllabus/mathematics_syllabus.pdf'
  ];

  intads() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-6749113501960121/2964467625",
        // adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _isInterstitialAdReady = true;
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    MobileAds.instance.initialize();
    intads();
    _bannerAd = BannerAd(
      // adUnitId: BannerAd.testAdUnitId,
      adUnitId: "ca-app-pub-6749113501960121/4277549299",
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57.0),
        child: AppBar(
          backgroundColor: cyan,
          title: brandName("Jee Advanced Syllabus", context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
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
                    ),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.only(
                            bottom: _getSmartBannerHeight(context)),
                        itemCount: entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              if (_isInterstitialAdReady) {
                                _interstitialAd.show();
                                setState(() {
                                  intads();
                                });
                              }
                              final url = '${pdfnames[index]}';
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      showAlertDialog(context));

                              final file = await PDFApi.loadFirebase(url);
                              Navigator.pop(context);
                              if (file == null) return;
                              openPDF(context, file);
                            },
                            child: Container(
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
                              height: 70,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage: AssetImage(
                                            'assets/${icons[index]}.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${entries[index]}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: size.height / 45,
                                          fontWeight: FontWeight.w500,
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
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

  showAlertDialog(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onwillpop();
      },
      child: Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(cyan),
      )),
    );
  }

  onwillpop() {
    return true;
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}

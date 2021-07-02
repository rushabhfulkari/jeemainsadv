import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/services/firebase.dart';
import 'package:jeemainsadv/widgets/pdfview.dart';
import 'package:jeemainsadv/widgets/widgets.dart';
import 'package:share/share.dart';

class PaperAdv extends StatefulWidget {
  @override
  _PaperAdvState createState() => _PaperAdvState();
}

class _PaperAdvState extends State<PaperAdv> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  TextEditingController _textController = TextEditingController();
  late File file;
  static List<String> entries = <String>[
    'JEE Advanced Solved 2020 Paper 1',
    'JEE Advanced Solved 2020 Paper 2',
    'JEE Advanced Solved 2019 Paper 1',
    'JEE Advanced Solved 2019 Paper 2',
    'JEE Advanced Solved 2018 Paper 1',
    'JEE Advanced Solved 2018 Paper 2',
    'JEE Advanced Solved 2017 Paper 1',
    'JEE Advanced Solved 2017 Paper 2',
    'JEE Advanced Solved 2016 Paper 1',
    'JEE Advanced Solved 2016 Paper 2',
    'JEE Advanced Solved 2015 Paper 1',
    'JEE Advanced Solved 2015 Paper 2',
    'JEE Advanced Solved 2014 Paper 1',
    'JEE Advanced Solved 2014 Paper 2',
    'JEE Advanced Solved 2013 Paper 1',
    'JEE Advanced Solved 2013 Paper 2',
    'JEE Advanced Solved 2012 Paper 1',
    'JEE Advanced Solved 2012 Paper 2',
    'JEE Advanced Solved 2011 Paper 1',
    'JEE Advanced Solved 2011 Paper 2',
    'JEE Advanced Solved 2010 Paper 1',
    'JEE Advanced Solved 2010 Paper 2',
    'JEE Advanced Solved 2009 Paper 1',
    'JEE Advanced Solved 2009 Paper 2',
    'JEE Advanced Solved 2008 Paper 1',
    'JEE Advanced Solved 2008 Paper 2',
    'JEE Advanced Solved 2007 Paper 1',
    'JEE Advanced Solved 2007 Paper 2',
  ];
  final List<String> pdfnames = <String>[
    '/JEE Adv Papers/2020p1.pdf',
    '/JEE Adv Papers/2020p2.pdf',
    '/JEE Adv Papers/2019p1.pdf',
    '/JEE Adv Papers/2019p2.pdf',
    '/JEE Adv Papers/2018p1.pdf',
    '/JEE Adv Papers/2018p2.pdf',
    '/JEE Adv Papers/2017p1.pdf',
    '/JEE Adv Papers/2017p2.pdf',
    '/JEE Adv Papers/2016p1.pdf',
    '/JEE Adv Papers/2016p2.pdf',
    '/JEE Adv Papers/2015p1.pdf',
    '/JEE Adv Papers/2015p2.pdf',
    '/JEE Adv Papers/2014p1.pdf',
    '/JEE Adv Papers/2014p2.pdf',
    '/JEE Adv Papers/2013p1.pdf',
    '/JEE Adv Papers/2013p2.pdf',
    '/JEE Adv Papers/2012p1.pdf',
    '/JEE Adv Papers/2012p2.pdf',
    '/JEE Adv Papers/2011p1.pdf',
    '/JEE Adv Papers/2011p2.pdf',
    '/JEE Adv Papers/2010p1.pdf',
    '/JEE Adv Papers/2010p2.pdf',
    '/JEE Adv Papers/2009p1.pdf',
    '/JEE Adv Papers/2009p2.pdf',
    '/JEE Adv Papers/2008p1.pdf',
    '/JEE Adv Papers/2008p2.pdf',
    '/JEE Adv Papers/2007p1.pdf',
    '/JEE Adv Papers/2007p2.pdf',
  ];

  List<String> newDataList = List.from(entries);

  onItemChanged(String value) {
    setState(() {
      newDataList = entries
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  intads() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-6749113501960121/8531175990",
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
    newDataList = entries;
    MobileAds.instance.initialize();
    intads();
    _bannerAd = BannerAd(
      // adUnitId: BannerAd.testAdUnitId,
      adUnitId: "ca-app-pub-6749113501960121/8565112811",
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
          title: brandName("Jee Advanced Solved Papers", context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20,
                  child: Container(
                    color: black,
                  ),
                ),
                Container(
                  color: black,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: TextField(
                      cursorColor: black,
                      controller: _textController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: cyan,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(60)),
                          hintText: 'Search',
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20)),
                      onChanged: onItemChanged,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
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
                        itemCount: newDataList.length,
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
                              child: newDataList.length != 0
                                  ? Container(
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
                                            horizontal: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 0,
                                              child: CircleAvatar(
                                                radius: 22.0,
                                                backgroundImage: AssetImage(
                                                    'assets/solved.png'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${newDataList[index]}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: size.height / 50,
                                                  fontWeight: FontWeight.w500,
                                                  color: white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
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
                                    ));
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

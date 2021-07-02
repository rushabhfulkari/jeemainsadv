import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/services/firebase.dart';
import 'package:jeemainsadv/widgets/pdfview.dart';
import 'package:jeemainsadv/widgets/widgets.dart';

class PaperMains extends StatefulWidget {
  @override
  _PaperMainsState createState() => _PaperMainsState();
}

class _PaperMainsState extends State<PaperMains> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  // final _nativeAdController = NativeAdmobController();
  TextEditingController _textController = TextEditingController();
  late File file;
  static List<String> entries = <String>[
    'JEE Mains Solved Paper 2021 16 March Morning',
    'JEE Mains Solved Paper 2021 16 March Evening',
    'JEE Mains Solved Paper 2021 17 March Morning',
    'JEE Mains Solved Paper 2021 17 March Evening',
    'JEE Mains Solved Paper 2021 18 March Morning',
    'JEE Mains Solved Paper 2021 18 March Evening',
    'JEE Mains Solved Paper 2021 24 February Morning',
    'JEE Mains Solved Paper 2021 24 February Evening',
    'JEE Mains Solved Paper 2021 25 February Morning',
    'JEE Mains Solved Paper 2021 25 February Eveving',
    'JEE Mains Solved Paper 2021 26 February Morning',
    'JEE Mains Solved Paper 2021 26 February Evening',
    'JEE Mains Solved Paper 2020 2 September Morning',
    'JEE Mains Solved Paper 2020 2 September Evening',
    'JEE Mains Solved Paper 2020 3 September Morning',
    'JEE Mains Solved Paper 2020 3 September Evening',
    'JEE Mains Solved Paper 2020 4 September Morning',
    'JEE Mains Solved Paper 2020 4 September Evening',
    'JEE Mains Solved Paper 2020 5 September Morning',
    'JEE Mains Solved Paper 2020 5 September Evening',
    'JEE Mains Solved Paper 2020 6 September Morning',
    'JEE Mains Solved Paper 2020 6 September Eveving',
    'JEE Mains Solved Paper 2020 7 January Morning',
    'JEE Mains Solved Paper 2020 7 January Evening',
    'JEE Mains Solved Paper 2020 8 January Morning',
    'JEE Mains Solved Paper 2020 8 January Evening',
    'JEE Mains Solved Paper 2020 9 January Morning',
    'JEE Mains Solved Paper 2020 9 January Evening',
    'JEE Mains Solved Paper 2019 8 April Morning',
    'JEE Mains Solved Paper 2019 8 April Evening',
    'JEE Mains Solved Paper 2019 9 April Morning',
    'JEE Mains Solved Paper 2019 9 April Evening',
    'JEE Mains Solved Paper 2019 10 April Morning',
    'JEE Mains Solved Paper 2019 10 April Evening',
    'JEE Mains Solved Paper 2019 12 April Morning',
    'JEE Mains Solved Paper 2019 12 April Evening',
    'JEE Mains Solved Paper 2019 9 January Morning',
    'JEE Mains Solved Paper 2019 9 January Eveving',
    'JEE Mains Solved Paper 2019 10 January Morning',
    'JEE Mains Solved Paper 2019 10 January Evening',
    'JEE Mains Solved Paper 2019 11 January Morning',
    'JEE Mains Solved Paper 2019 11 January Evening',
    'JEE Mains Solved Paper 2019 12 January Morning',
    'JEE Mains Solved Paper 2019 12 January Evening',
    'JEE Mains Solved Paper 2018',
    'JEE Mains Solved Paper 2017',
    'JEE Mains Solved Paper 2016',
    'JEE Mains Solved Paper 2015',
    'JEE Mains Solved Paper 2014',
    'JEE Mains Solved Paper 2013',
    'AIEEE Solved Paper 2012',
    'AIEEE Solved Paper 2011',
    'AIEEE Solved Paper 2010',
    'AIEEE Solved Paper 2009',
    'AIEEE Solved Paper 2008',
    'AIEEE Solved Paper 2007',
    'AIEEE Solved Paper 2006',
    'AIEEE Solved Paper 2005',
    'AIEEE Solved Paper 2004',
    'AIEEE Solved Paper 2003',
    'AIEEE Solved Paper 2002',
  ];
  final List<String> pdfnames = <String>[
    '/JEE Mains Papers/2021_march1601.pdf',
    '/JEE Mains Papers/2021_march1602.pdf',
    '/JEE Mains Papers/2021_march1701.pdf',
    '/JEE Mains Papers/2021_march1702.pdf',
    '/JEE Mains Papers/2021_march1801.pdf',
    '/JEE Mains Papers/2021_march1802.pdf',
    '/JEE Mains Papers/2021_feb2401.pdf',
    '/JEE Mains Papers/2021_feb2402.pdf',
    '/JEE Mains Papers/2021_feb2501.pdf',
    '/JEE Mains Papers/2021_feb2502.pdf',
    '/JEE Mains Papers/2021_feb2601.pdf',
    '/JEE Mains Papers/2021_feb2602.pdf',
    '/JEE Mains Papers/2020_sep0201.pdf',
    '/JEE Mains Papers/2020_sep0202.pdf',
    '/JEE Mains Papers/2020_sep0301.pdf',
    '/JEE Mains Papers/2020_sep0302.pdf',
    '/JEE Mains Papers/2020_sep0401.pdf',
    '/JEE Mains Papers/2020_sep0402.pdf',
    '/JEE Mains Papers/2020_sep0501.pdf',
    '/JEE Mains Papers/2020_sep0502.pdf',
    '/JEE Mains Papers/2020_sep0601.pdf',
    '/JEE Mains Papers/2020_sep0602.pdf',
    '/JEE Mains Papers/2020_0701.pdf',
    '/JEE Mains Papers/2020_0702.pdf',
    '/JEE Mains Papers/2020_0801.pdf',
    '/JEE Mains Papers/2020_0802.pdf',
    '/JEE Mains Papers/2020_0901.pdf',
    '/JEE Mains Papers/2020_0902.pdf',
    '/JEE Mains Papers/2019_apr0801.pdf',
    '/JEE Mains Papers/2019_apr0802.pdf',
    '/JEE Mains Papers/2019_apr0901.pdf',
    '/JEE Mains Papers/2019_apr0902.pdf',
    '/JEE Mains Papers/2019_apr1001.pdf',
    '/JEE Mains Papers/2019_apr1002.pdf',
    '/JEE Mains Papers/2019_apr1201.pdf',
    '/JEE Mains Papers/2019_apr1202.pdf',
    '/JEE Mains Papers/2019_jan0901.pdf',
    '/JEE Mains Papers/2019_jan0902.pdf',
    '/JEE Mains Papers/2019_jan1001.pdf',
    '/JEE Mains Papers/2019_jan1002.pdf',
    '/JEE Mains Papers/2019_jan1101.pdf',
    '/JEE Mains Papers/2019_jan1102.pdf',
    '/JEE Mains Papers/2019_jan1201.pdf',
    '/JEE Mains Papers/2019_jan1202.pdf',
    '/JEE Mains Papers/2018.pdf',
    '/JEE Mains Papers/2017.pdf',
    '/JEE Mains Papers/2016.pdf',
    '/JEE Mains Papers/2015.pdf',
    '/JEE Mains Papers/2014.pdf',
    '/JEE Mains Papers/2013.pdf',
    '/JEE Mains Papers/2012.pdf',
    '/JEE Mains Papers/2011.pdf',
    '/JEE Mains Papers/2010.pdf',
    '/JEE Mains Papers/2009.pdf',
    '/JEE Mains Papers/2008.pdf',
    '/JEE Mains Papers/2007.pdf',
    '/JEE Mains Papers/2006.pdf',
    '/JEE Mains Papers/2005.pdf',
    '/JEE Mains Papers/2004.pdf',
    '/JEE Mains Papers/2003.pdf',
    '/JEE Mains Papers/2002.pdf',
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
        adUnitId: "ca-app-pub-6749113501960121/9844257669",
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
      adUnitId: "ca-app-pub-6749113501960121/6096584340",
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
    Timer(Duration(seconds: 10), () {});
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57.0),
        child: AppBar(
          backgroundColor: cyan,
          title: brandName("Jee Mains Solved Papers", context),
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
                        padding: EdgeInsets.only(
                            bottom: _getSmartBannerHeight(context)),
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
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
                            // index % 4 == 0
                            //     ? Container(
                            //         margin: EdgeInsets.all(8),
                            //         height: 400,
                            //         color: cyan,
                            //         child: NativeAdmob(
                            //             adUnitID: NativeAd.testAdUnitId,
                            //             // adUnitID:
                            //             // "ca-app-pub-6749113501960121/8800954522",
                            //             controller: _nativeAdController,
                            //             type: NativeAdmobType.full,
                            //             loading: Center(
                            //                 child: CircularProgressIndicator()),
                            //             error: Text('failed to load'),
                            //             options: NativeAdmobOptions(
                            //               ratingColor: cyan,
                            //             )))
                            //     :
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

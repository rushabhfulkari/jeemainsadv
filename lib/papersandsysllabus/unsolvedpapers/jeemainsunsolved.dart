import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/services/firebase.dart';
import 'package:jeemainsadv/widgets/pdfview.dart';
import 'package:jeemainsadv/widgets/widgets.dart';
import 'package:share/share.dart';

class UnsolvedMains extends StatefulWidget {
  @override
  _UnsolvedMainsState createState() => _UnsolvedMainsState();
}

class _UnsolvedMainsState extends State<UnsolvedMains> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  TextEditingController _textController = TextEditingController();

  late File file;
  static List<String> entries = <String>[
    'JEE Mains Unsolved Paper 2021 16 March Morning',
    'JEE Mains Unsolved Paper 2021 16 March Evening',
    'JEE Mains Unsolved Paper 2021 17 March Morning',
    'JEE Mains Unsolved Paper 2021 17 March Evening',
    'JEE Mains Unsolved Paper 2021 18 March Morning',
    'JEE Mains Unsolved Paper 2021 18 March Evening',
    'JEE Mains Unsolved Paper 2021 24 February Morning',
    'JEE Mains Unsolved Paper 2021 24 February Evening',
    'JEE Mains Unsolved Paper 2021 25 February Morning',
    'JEE Mains Unsolved Paper 2021 25 February Eveving',
    'JEE Mains Unsolved Paper 2021 26 February Morning',
    'JEE Mains Unsolved Paper 2021 26 February Evening',
    'JEE Mains Unsolved Paper 2020 2 September Morning',
    'JEE Mains Unsolved Paper 2020 2 September Evening',
    'JEE Mains Unsolved Paper 2020 3 September Morning',
    'JEE Mains Unsolved Paper 2020 3 September Evening',
    'JEE Mains Unsolved Paper 2020 4 September Morning',
    'JEE Mains Unsolved Paper 2020 4 September Evening',
    'JEE Mains Unsolved Paper 2020 5 September Morning',
    'JEE Mains Unsolved Paper 2020 5 September Evening',
    'JEE Mains Unsolved Paper 2020 6 September Morning',
    'JEE Mains Unsolved Paper 2020 6 September Eveving',
    'JEE Mains Unsolved Paper 2020 7 January Morning',
    'JEE Mains Unsolved Paper 2020 7 January Evening',
    'JEE Mains Unsolved Paper 2020 8 January Morning',
    'JEE Mains Unsolved Paper 2020 8 January Evening',
    'JEE Mains Unsolved Paper 2020 9 January Morning',
    'JEE Mains Unsolved Paper 2020 9 January Evening',
    'JEE Mains Unsolved Paper 2019 8 April Morning',
    'JEE Mains Unsolved Paper 2019 8 April Evening',
    'JEE Mains Unsolved Paper 2019 9 April Morning',
    'JEE Mains Unsolved Paper 2019 9 April Evening',
    'JEE Mains Unsolved Paper 2019 10 April Morning',
    'JEE Mains Unsolved Paper 2019 10 April Evening',
    'JEE Mains Unsolved Paper 2019 12 April Morning',
    'JEE Mains Unsolved Paper 2019 12 April Evening',
    'JEE Mains Unsolved Paper 2019 9 January Morning',
    'JEE Mains Unsolved Paper 2019 9 January Eveving',
    'JEE Mains Unsolved Paper 2019 10 January Morning',
    'JEE Mains Unsolved Paper 2019 10 January Evening',
    'JEE Mains Unsolved Paper 2019 11 January Morning',
    'JEE Mains Unsolved Paper 2019 11 January Evening',
    'JEE Mains Unsolved Paper 2019 12 January Morning',
    'JEE Mains Unsolved Paper 2019 12 January Evening',
    'JEE Mains Unsolved Paper 2018',
    'JEE Mains Unsolved Paper 2017',
    'JEE Mains Unsolved Paper 2016',
    'JEE Mains Unsolved Paper 2015',
    'JEE Mains Unsolved Paper 2014',
    'JEE Mains Unsolved Paper 2013',
  ];
  final List<String> pdfnames = <String>[
    '/JEE Mains unsolved Papers/2021_march1601.pdf',
    '/JEE Mains unsolved Papers/2021_march1602.pdf',
    '/JEE Mains unsolved Papers/2021_march1701.pdf',
    '/JEE Mains unsolved Papers/2021_march1702.pdf',
    '/JEE Mains unsolved Papers/2021_march1801.pdf',
    '/JEE Mains unsolved Papers/2021_march1802.pdf',
    '/JEE Mains unsolved Papers/2021_feb2401.pdf',
    '/JEE Mains unsolved Papers/2021_feb2402.pdf',
    '/JEE Mains unsolved Papers/2021_feb2501.pdf',
    '/JEE Mains unsolved Papers/2021_feb2502.pdf',
    '/JEE Mains unsolved Papers/2021_feb2601.pdf',
    '/JEE Mains unsolved Papers/2021_feb2602.pdf',
    '/JEE Mains unsolved Papers/2020_sep0201unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0202unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0301unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0302unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0401unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0402unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0501unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0502unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0601unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_sep0602unsolved.pdf',
    '/JEE Mains unsolved Papers/2020_0701.pdf',
    '/JEE Mains unsolved Papers/2020_0702.pdf',
    '/JEE Mains unsolved Papers/2020_0801.pdf',
    '/JEE Mains unsolved Papers/2020_0802.pdf',
    '/JEE Mains unsolved Papers/2020_0901.pdf',
    '/JEE Mains unsolved Papers/2020_0902.pdf',
    '/JEE Mains unsolved Papers/2019_apr0801.pdf',
    '/JEE Mains unsolved Papers/2019_apr0802.pdf',
    '/JEE Mains unsolved Papers/2019_apr0901.pdf',
    '/JEE Mains unsolved Papers/2019_apr0902.pdf',
    '/JEE Mains unsolved Papers/2019_apr1001.pdf',
    '/JEE Mains unsolved Papers/2019_apr1002.pdf',
    '/JEE Mains unsolved Papers/2019_apr1201.pdf',
    '/JEE Mains unsolved Papers/2019_apr1202.pdf',
    '/JEE Mains unsolved Papers/2019_jan0901.pdf',
    '/JEE Mains unsolved Papers/2019_jan0902.pdf',
    '/JEE Mains unsolved Papers/2019_jan1001.pdf',
    '/JEE Mains unsolved Papers/2019_jan1002.pdf',
    '/JEE Mains unsolved Papers/2019_jan1101.pdf',
    '/JEE Mains unsolved Papers/2019_jan1102.pdf',
    '/JEE Mains unsolved Papers/2019_jan1201.pdf',
    '/JEE Mains unsolved Papers/2019_jan1202.pdf',
    '/JEE Mains unsolved Papers/2018.pdf',
    '/JEE Mains unsolved Papers/2017.pdf',
    '/JEE Mains unsolved Papers/2016.pdf',
    '/JEE Mains unsolved Papers/2015.pdf',
    '/JEE Mains unsolved Papers/2014.pdf',
    '/JEE Mains unsolved Papers/2013.pdf',
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
        adUnitId: "ca-app-pub-6749113501960121/7218094329",
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
      adUnitId: "ca-app-pub-6749113501960121/4783502673",
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
          title: brandName("Jee Mains Unsolved Papers", context),
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
                                                    'assets/unsolved.png'),
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

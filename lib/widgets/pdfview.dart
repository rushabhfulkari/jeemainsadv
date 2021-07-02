import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jeemainsadv/constants/colors.dart';
import 'package:jeemainsadv/widgets/widgets.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  const PDFViewerPage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late Timer _timerForInter;
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  int timer = 10;
  late String showtimer;

  get nightmode => null;

  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   return MobileAds.instance.initialize();
  // }

  intads() async {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-6749113501960121/9652685970",
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

  void showintads() async {
    _timerForInter = Timer.periodic(Duration(seconds: 60), (result) {
      if (_isInterstitialAdReady) {
        _interstitialAd.show();
        showintads();
        intads();
      }
    });
  }

  void initState() {
    super.initState();
    MobileAds.instance.initialize();
    showintads();
    intads();
    super.initState();

    // _initGoogleMobileAds();
    // _bannerAd = BannerAd(
    //   adUnitId: BannerAd.testAdUnitId,
    //   // adUnitId: "ca-app-pub-6749113501960121/9184097908",
    //   request: AdRequest(),
    //   size: AdSize.smartBanner,
    //   listener: BannerAdListener(
    //     onAdLoaded: (_) {
    //       setState(() {
    //         _isBannerAdReady = true;
    //       });
    //       print("rush");
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       print('Failed to load a banner ad: ${err.message}');
    //       _isBannerAdReady = false;
    //       ad.dispose();
    //     },
    //   ),
    // );
    // _bannerAd.load();
  }

  @override
  void dispose() {
    _timerForInter.cancel();
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(57.0),
          child: AppBar(
            backgroundColor: white,
            title: pdfviewname(name),
            actions: pages >= 2
                ? [
                    Center(child: Text(text)),
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 32),
                      onPressed: () {
                        final page = indexPage == 0 ? pages : indexPage - 1;
                        controller.setPage(page);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 32),
                      onPressed: () {
                        final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                        controller.setPage(page);
                      },
                    ),
                  ]
                : null,
          ),
        ),
        body: Stack(
          children: [
            PDFView(
              nightMode: false,
              filePath: widget.file.path,
              autoSpacing: true,
              // swipeHorizontal: true,
              // pageSnap: true,
              // pageFling: true,
              onRender: (pages) => setState(() => this.pages = pages!),
              onViewCreated: (controller) =>
                  setState(() => this.controller = controller),
              onPageChanged: (indexPage, _) =>
                  setState(() => this.indexPage = indexPage!),
            ),
            // if (_isBannerAdReady)
            //   Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Container(
            //         width: size.width,
            //         height: _getSmartBannerHeight(context),
            //         child: AdWidget(ad: _bannerAd),
            //       ),
            //     ],
            //   ),
          ],
        ));
  }

  // double _getSmartBannerHeight(BuildContext context) {
  //   MediaQueryData mediaScreen = MediaQuery.of(context);
  //   double dpHeight = mediaScreen.orientation == Orientation.portrait
  //       ? mediaScreen.size.height
  //       : mediaScreen.size.width;
  //   if (dpHeight <= 400.0) {
  //     return 32.0;
  //   }
  //   if (dpHeight > 720.0) {
  //     return 90.0;
  //   }
  //   return 50.0;
  // }
}

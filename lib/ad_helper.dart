// lib/ad_helper.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // 初期化
  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  // バナー広告のID
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3331079517737737/9774578853';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3331079517737737/9774578853';
    }
    throw UnsupportedError("Unsupported platform");
  }

  // 全画面広告（インタースティシャル）のID
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3331079517737737/7998462754';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3331079517737737/7998462754';
    }
    throw UnsupportedError("Unsupported platform");
  }

  // 全画面広告を表示するヘルパー関数
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdLoading = false;

  // インタースティシャル広告を事前に読み込む
  static void loadInterstitialAd() {
    if (_interstitialAd != null || _isInterstitialAdLoading) return;

    _isInterstitialAdLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('InterstitialAd loaded.');
          _interstitialAd = ad;
          _isInterstitialAdLoading = false;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isInterstitialAdLoading = false;
        },
      ),
    );
  }

  // 全画面広告を表示するヘルパー関数
  static void showInterstitialAd({required VoidCallback onComplete}) {
    // 既に読み込まれていれば表示
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null; // 使い捨てなのでクリア
          onComplete();
          // 次のためにまたロードしておく
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          onComplete();
          loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null; // 二重表示防止
    } else {
      // 読み込まれていなければロードしてから表示 (フォールバック)
      debugPrint("Interstitial ad not ready, loading now...");
      InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                onComplete();
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                onComplete();
                loadInterstitialAd();
              },
            );
            ad.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            onComplete(); // ロード失敗時も止まらないように
          },
        ),
      );
    }
  }
  // プレロードされたクイズ用バナー広告
  static BannerAd? _preloadedQuizBanner;

  // クイズ画面に行く前にバナーを事前にロードしておく
  static void preloadQuizBanner() {
    // 既にロード済みなら何もしない
    if (_preloadedQuizBanner != null) return;

    _preloadedQuizBanner = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner, // 標準バナー
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a preloaded banner ad: ${err.message}');
          ad.dispose();
          _preloadedQuizBanner = null;
        },
      ),
    )..load();
  }

  // クイズ画面でプレロードされたバナーを取得する
  static BannerAd getQuizBanner({required BannerAdListener listener}) {
    if (_preloadedQuizBanner != null) {
      final ad = _preloadedQuizBanner!;
      
      // 既にロード済みならそのまま返す
      if (ad.responseInfo != null) {
        debugPrint("Using preloaded banner (Ready!)");
        _preloadedQuizBanner = null;
        return ad;
      }
      
      // まだロード中、あるいは失敗していた場合は、リスナーを付け替えられないため破棄して作り直す
      debugPrint("Preloaded banner not ready yet or pending. Discarding to attach new listener.");
      ad.dispose();
      _preloadedQuizBanner = null;
    }

    // 新規作成
    return BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: listener,
    )..load();
  }
}

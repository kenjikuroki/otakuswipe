// lib/ad_helper.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // 初期化
  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  // バナー広告のID（テスト用）
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw UnsupportedError("Unsupported platform");
  }

  // 全画面広告（インタースティシャル）のID（テスト用）
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    throw UnsupportedError("Unsupported platform");
  }

  // 全画面広告を表示するヘルパー関数
  static void showInterstitialAd({required VoidCallback onComplete}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onComplete(); // 広告を閉じたら次の処理へ
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onComplete(); // 失敗しても次の処理へ進める
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

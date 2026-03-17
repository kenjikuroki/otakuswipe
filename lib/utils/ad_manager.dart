import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import '../widgets/special_offer_dialog.dart';
import '../services/purchase_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PreloadedAd {
  final BannerAd ad;
  final ValueNotifier<bool> isLoaded = ValueNotifier(false);

  PreloadedAd(this.ad);

  void dispose() {
    ad.dispose();
    isLoaded.dispose();
  }
}

class AdManager {
  static final AdManager instance = AdManager._internal();
  AdManager._internal();

  final Map<String, PreloadedAd> _ads = {};
  bool _isPremium = false;

  void setPremium(bool premium) {
    _isPremium = premium;
    if (_isPremium) {
      disposeAllAds();
    }
  }

  final String _adUnitId = 'ca-app-pub-3331079517737737/8905948804';
  
  // Test ID for debug (optional use)
  // final String _testAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  /// Initialize Consent Flow (iOS ATT)
  Future<void> initializeConsent() async {
    // iOSでのトラッキング許可ダイアログを直接呼び出し
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        // ダイアログ表示
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint("ATT Error: $e");
    }
  }

  void preloadAd(String key) {
    if (_isPremium) return;
    if (_ads.containsKey(key)) {
      // Already preloading or loaded
      return;
    }

    final unitId = _adUnitId;

    final ad = BannerAd(
      adUnitId: unitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('AdManager: Ad $key loaded.');
          _ads[key]?.isLoaded.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('AdManager: Ad $key failed to load: $err');
          ad.dispose();
          _ads.remove(key);
        },
      ),
    );

    final preloadedAd = PreloadedAd(ad);
    _ads[key] = preloadedAd;
    ad.load();
  }

  PreloadedAd? getAd(String key) {
    if (_isPremium) return null;
    return _ads[key];
  }
  
  /// Returns the ad and removes it from manager (transfer ownership)
  /// If [keep] is true, it retains in manager (shared ownership/singleton usage like Home).
  PreloadedAd? consumeAd(String key, {bool keep = false}) {
    if (_isPremium) return null;
    if (keep) {
      return _ads[key];
    }
    return _ads.remove(key);
  }

  // Interstitial Ad
  InterstitialAd? _interstitialAd;
  
  // Real ID from user screenshot
  final String _interstitialAdUnitId = 'ca-app-pub-3331079517737737/4723161214';

  void preloadInterstitial() {
    if (_isPremium) return;
    if (_interstitialAd != null) return;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId, 
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdManager: Interstitial loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          debugPrint('AdManager: Interstitial failed to load: $err');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Shows the interstitial ad if available.
  /// [onComplete] is called when the ad is dismissed or if it fails to show/load.
  void showInterstitial({required BuildContext context, required VoidCallback onComplete}) {
    if (_isPremium) {
      onComplete();
      return;
    }
    if (_interstitialAd == null) {
      debugPrint('AdManager: No interstitial ready, skipping.');
      onComplete();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AdManager: Interstitial dismissed.');
        ad.dispose();
        _interstitialAd = null;
        onComplete();
        // Trigger special offer after interstitial
        _showSpecialOfferIfEligible(context);
      },
      onAdFailedToShowFullScreenContent: (ad, err) {
        debugPrint('AdManager: Interstitial failed to show: $err');
        ad.dispose();
        _interstitialAd = null;
        onComplete();
      },
    );

    _interstitialAd!.show();
  }

  Future<void> _showSpecialOfferIfEligible(BuildContext context) async {
    if (_isPremium) return;

    final prefs = await SharedPreferences.getInstance();
    final hasShownOffer = prefs.getBool('has_shown_special_offer') ?? false;
    if (hasShownOffer) return;

    final limitDate = DateTime(2026, 3, 1);
    if (DateTime.now().isAfter(limitDate)) return;

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => const SpecialOfferDialog(),
      );
      await prefs.setBool('has_shown_special_offer', true);
    }
  }
  
  void disposeAllAds() {
    for (var ad in _ads.values) {
      ad.dispose();
    }
    _ads.clear();
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  void dispose() {
    disposeAllAds();
  }
}

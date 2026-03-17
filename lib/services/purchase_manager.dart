import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/ad_manager.dart';

class PurchaseManager extends ChangeNotifier {
  static final PurchaseManager instance = PurchaseManager._internal();
  PurchaseManager._internal();

  static const String _premiumProductId = 'unlock_add';
  static const String _yakuzaProductId = 'com.yourname.otaku.unlock_yakuza_2';
  
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  bool _isYakuzaUnlocked = false;
  bool get isYakuzaUnlocked => _isYakuzaUnlocked;

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<void> initialize() async {
    // 1. Load from cache
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('is_premium_unlocked') ?? false;
    _isYakuzaUnlocked = prefs.getBool('is_yakuza_unlocked') ?? false;
    
    // Sync with AdManager immediately
    AdManager.instance.setPremium(_isPremium);
    notifyListeners();

    // 2. Listen to purchase updates
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint("IAP Stream Error: $error");
    });
  }

  void disposeSubscription() {
    _subscription.cancel();
  }

  Future<void> buyPremium() async {
    await _buyProduct(_premiumProductId);
  }

  Future<void> buyYakuza() async {
    await _buyProduct(_yakuzaProductId);
  }

  Future<void> _buyProduct(String productId) async {
    final available = await _iap.isAvailable();
    if (!available) throw Exception("Store not available");

    final Set<String> kIds = {productId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);
    
    if (response.error != null) throw Exception(response.error!.message);
    if (response.productDetails.isEmpty) throw Exception("Product $productId not found");

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("Purchase error: ${purchaseDetails.error}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          await _deliverProduct(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (purchaseDetails.productID == _premiumProductId) {
      _isPremium = true;
      AdManager.instance.setPremium(true);
      await prefs.setBool('is_premium_unlocked', true);
    } else if (purchaseDetails.productID == _yakuzaProductId) {
      _isYakuzaUnlocked = true;
      await prefs.setBool('is_yakuza_unlocked', true);
    }
    
    notifyListeners();
  }
}

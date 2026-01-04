import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService extends ChangeNotifier {
  // ストアに登録した製品ID (Non-Consumable)
  static const String _yakuzaProductId = 'com.yourname.otaku.unlock_yakuza';
  
  bool _isYakuzaUnlocked = false;
  bool get isYakuzaUnlocked => _isYakuzaUnlocked;

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  PurchaseService() {
    _init();
  }

  Future<void> _init() async {
    // 1. ローカル保存された購入状態をロード
    final prefs = await SharedPreferences.getInstance();
    _isYakuzaUnlocked = prefs.getBool('is_yakuza_unlocked') ?? false;
    notifyListeners();

    // 2. ストアの購入リスナーを開始
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint("IAP Stream Error: $error");
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // 購入処理の開始
  Future<void> buyYakuzaLevel() async {
    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint("Store not available");
      return;
    }

    // 商品情報を取得
    final Set<String> kIds = {_yakuzaProductId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);
    
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint("Product not found: ${response.notFoundIDs}");
      // ストアにアイテムがまだ登録されていない、または有効化されていない場合
      return;
    }

    if (response.productDetails.isEmpty) {
      debugPrint("No product details found.");
      return;
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

    // 購入フロー開始 (非消耗型)
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // 購入の復元処理
  Future<void> restorePurchases() async {
    debugPrint("Restore process started...");
    await _iap.restorePurchases();
  }

  // 購入ステータスの変更を監視
  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 処理待ち
        debugPrint("Purchase pending...");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("Purchase error: ${purchaseDetails.error}");
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          
          // 購入完了 or 復元成功
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            await _deliverProduct(purchaseDetails);
          } else {
            debugPrint("Invalid purchase verification.");
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // 本来はサーバーサイドでレシート検証を行うのが安全ですが、
    // 簡易実装としてクライアント側では常にtrueを返します。
    return true;
  }

  Future<void> _deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == _yakuzaProductId) {
      debugPrint("Unlocking Yakuza Level!");
      _isYakuzaUnlocked = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_yakuza_unlocked', true);
    }
  }
  
  // デバッグ用: 強制リセット
  Future<void> debugResetPurchase() async {
    _isYakuzaUnlocked = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_yakuza_unlocked');
  }
}

// lib/services/purchase_service.dart
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService extends ChangeNotifier {
  // シングルトン（どこからでも同じデータにアクセスできるようにする）
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  bool _isYakuzaUnlocked = false; // レベル6解放フラグ

  bool get isYakuzaUnlocked => _isYakuzaUnlocked;

  // 初期化：アプリ起動時に保存された状態を読み込む
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isYakuzaUnlocked = prefs.getBool('is_yakuza_unlocked') ?? false;
    notifyListeners();
  }

  // 課金処理（現在はデバッグ用に即解放）
  Future<void> buyYakuzaLevel() async {
    debugPrint("Purchase process started...");
    
    // ★本来はここでApple/Googleの課金フローが入ります
    // 今回は擬似的に「成功」として扱います
    await _unlockContent();
  }

  // コンテンツ解放処理
  Future<void> _unlockContent() async {
    _isYakuzaUnlocked = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_yakuza_unlocked', true);
    notifyListeners();
    debugPrint("Level 6 Yakuza Unlocked!");
  }
}

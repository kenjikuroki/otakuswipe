// lib/providers/quiz_provider.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/slang_item.dart';
import '../services/purchase_service.dart'; // インポート追加

class QuizProvider with ChangeNotifier {
  // 全データ保持用
  SlangData? _masterData;
  
  // 現在プレイ中のリスト
  List<SlangItem> _currentList = [];
  List<SlangItem> get slangList => _currentList;

  // 現在のレベルID（ロジック判定用）
  String _currentLevelId = "";
  String get currentLevelId => _currentLevelId;

  // 現在のレベル名（タイトル表示用）
  String _currentLevelTitle = "";
  String get currentLevelTitle => _currentLevelTitle;

  // ▼▼▼ 追加 ▼▼▼
  final PurchaseService _purchaseService = PurchaseService();

  // 外部からロック状態を確認するためのゲッター
  bool get isYakuzaUnlocked => _purchaseService.isYakuzaUnlocked;

  QuizProvider() {
    // 課金状態が変わったら（購入完了したら）画面を更新するようにリスナー登録
    _purchaseService.addListener(() {
      notifyListeners();
    });
    
    // サービスの初期化
    _purchaseService.init();
    
    // (既存の処理)
    loadMasterData();
  }
  // ▲▲▲ 追加ここまで ▲▲▲

  // 最初にアプリ起動時に一度だけ呼ぶ
  Future<void> loadMasterData() async {
    if (_masterData != null) return; // 既に読み込み済みなら何もしない

    try {
      final String response = await rootBundle.loadString('assets/json/slang_data.json');
      final data = json.decode(response);
      _masterData = SlangData.fromJson(data);
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  // レベルを選んでセットする関数
  void selectLevel(String levelId) {
    if (_masterData == null) return;
    
    _currentLevelId = levelId; // IDを保存

    bool shouldShuffle = true; // デフォルトはシャッフルする

    switch (levelId) {
      case 'lv1':
        _currentList = _masterData!.level1;
        _currentLevelTitle = "Level 1: Survival";
        break;
      case 'lv2':
        _currentList = _masterData!.level2;
        _currentLevelTitle = "Level 2: Youth";
        break;
      case 'lv3':
        _currentList = _masterData!.level3;
        _currentLevelTitle = "Level 3: Otaku";
        break;
      case 'lv4':
        _currentList = _masterData!.level4;
        _currentLevelTitle = "Level 4: Internet";
        break;
      case 'lv5':
        _currentList = _masterData!.level5;
        _currentLevelTitle = "Level 5: Persona";
        break;
      case 'level6_yakuza':
        _currentList = _masterData!.level6;
        _currentLevelTitle = "Level 6: Yakuza";
        
        // データがない場合のフォールバック（テスト用：Level 1のデータを使う）
        if (_currentList.isEmpty) {
           _currentList = _masterData!.level1;
        }

        // 未解放ならシャッフルしない（固定順）
        if (!isYakuzaUnlocked) {
          shouldShuffle = false;
        }
        break;
      default:
        _currentList = _masterData!.level1;
    }
    
    // リストをコピー
    _currentList = List.of(_currentList);

    // シャッフル指示がある場合のみシャッフル
    if (shouldShuffle) {
      _currentList.shuffle();
    }

    // 10問に制限する (Yakuza未解放の場合は制限せず、UI側で4問目以降をブロックするのでリスト自体は渡す)
    // ただし、長すぎると無駄なので適当に切るか、そのままにする
    if (isYakuzaUnlocked && _currentList.length > 10) {
      _currentList = _currentList.sublist(0, 10);
    } else if (!isYakuzaUnlocked && levelId == 'level6_yakuza') {
       // 未解放Yakuzaの場合：少なくとも4問はないと「4問目が有料」を表現できない
       // そのまま全リストを渡す（もしくは適当に制限）
    } else if (_currentList.length > 10) {
      // 通常レベル
      _currentList = _currentList.sublist(0, 10);
    }
    
    notifyListeners();
  }

  // 復習用リストをセットする関数
  void setReviewList(List<SlangItem> reviewList) {
    // 渡された復習用リストをコピーして現在のリストに設定
    _currentList = List.from(reviewList);
    // タイトルを「復習モード」に変更
    _currentLevelTitle = "Review Mode";
    // 画面を更新
    notifyListeners();
  }
}

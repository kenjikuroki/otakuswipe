// lib/providers/quiz_provider.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/slang_item.dart';
import '../services/purchase_service.dart';
import '../i18n/strings.g.dart';

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
  // ▼▼▼ 追加 ▼▼▼
  PurchaseService? _purchaseService;

  // 外部からロック状態を確認するためのゲッター
  bool get isYakuzaUnlocked => _purchaseService?.isYakuzaUnlocked ?? false;

  void updatePurchaseService(PurchaseService service) {
    // サービスが変わっていなければ何もしない
    if (_purchaseService == service) return;
    
    // 古いリスナーを解除（もしあれば）
    _purchaseService?.removeListener(_onPurchaseUpdated);
    
    // 新しいサービスをセットして監視開始
    _purchaseService = service;
    _purchaseService!.addListener(_onPurchaseUpdated);
    
    // 即座に一度更新通知
    notifyListeners();
  }

  void _onPurchaseUpdated() {
    notifyListeners();
  }

  QuizProvider() {
    // コンストラクタでの初期化は不要になり、updatePurchaseServiceで紐付けされます
    loadMasterData();
  }
  // ▲▲▲ 追加ここまで ▲▲▲

  // Loaded locale to check for changes
  AppLocale? _loadedLocale;

  // 最初にアプリ起動時に一度だけ呼ぶ、または言語変更時に呼ぶ
  Future<void> loadMasterData() async {
    final currentLocale = LocaleSettings.currentLocale;
    // 既にデータがあり、かつ言語が変わっていなければ何もしない
    if (_masterData != null && _loadedLocale == currentLocale) return;

    try {
      String fileName = 'slang_data.json';
      if (currentLocale == AppLocale.es) {
        fileName = 'slang_data_es.json';
      } else if (currentLocale == AppLocale.fr) {
        fileName = 'slang_data_fr.json';
      } else if (currentLocale == AppLocale.pt) {
        fileName = 'slang_data_pt.json';
      }
      
      final String response = await rootBundle.loadString('assets/json/$fileName');
      final data = json.decode(response);
      _masterData = SlangData.fromJson(data);
      _loadedLocale = currentLocale;
    } catch (e) {
      debugPrint("Error loading JSON: $e");
    }
  }

  // レベルを選んでセットする関数
  Future<void> selectLevel(String levelId) async {
    // データをロード（言語変更に対応するため毎回呼び出す。内部でキャッシュチェックあり）
    await loadMasterData();
    
    if (_masterData == null) return; // それでもロード失敗したら終了
    
    _currentLevelId = levelId; // IDを保存

    bool shouldShuffle = true; // デフォルトはシャッフルする

    switch (levelId) {
      case 'lv1':
        _currentList = _masterData!.level1;
        _currentLevelTitle = t.levelSelect.levels.level1.title;
        break;
      case 'lv2':
        _currentList = _masterData!.level2;
        _currentLevelTitle = t.levelSelect.levels.level2.title;
        break;
      case 'lv3':
        _currentList = _masterData!.level3;
        _currentLevelTitle = t.levelSelect.levels.level3.title;
        break;
      case 'lv4':
        _currentList = _masterData!.level4;
        _currentLevelTitle = t.levelSelect.levels.level4.title;
        break;
      case 'lv5':
        _currentList = _masterData!.level5;
        _currentLevelTitle = t.levelSelect.levels.level5.title;
        break;
      case 'level6_yakuza':
        _currentList = _masterData!.level6;
        _currentLevelTitle = t.levelSelect.levels.level6.title;
        
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
    _currentLevelTitle = t.quiz.reviewMode;
    // 画面を更新
    notifyListeners();
  }
}

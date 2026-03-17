// lib/providers/quiz_provider.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/slang_item.dart';
import '../services/purchase_manager.dart';
import '../i18n/strings.g.dart';

import 'package:shared_preferences/shared_preferences.dart';

enum QuizMode {
  shuffle,
  sequential
}

class QuizProvider with ChangeNotifier {
  // 全データ保持用
  SlangData? _masterData;
  
  // 現在プレイ中のリスト
  List<SlangItem> _currentList = [];
  List<SlangItem> get slangList => _currentList;
  
  // クイズの出題モード
  QuizMode _selectedMode = QuizMode.shuffle;
  QuizMode get selectedMode => _selectedMode;

  set selectedMode(QuizMode mode) {
    if (_selectedMode != mode) {
      _selectedMode = mode;
      notifyListeners();
    }
  }

  // 苦手な単語のリスト（単語の文字列をIDとして扱う）
  Set<String> _weakWordIds = {};
  Set<String> get weakWordIds => _weakWordIds;

  // 現在のレベルID（ロジック判定用）
  String _currentLevelId = "";
  String get currentLevelId => _currentLevelId;

  // 現在のレベル名（タイトル表示用）
  String _currentLevelTitle = "";
  String get currentLevelTitle => _currentLevelTitle;

  // 現在のレベルカラー（背景用）
  Color _currentLevelColor = Colors.orange;
  Color get currentLevelColor => _currentLevelColor;

  // ▼▼▼ 追加 ▼▼▼
  // ▼▼▼ 追加 ▼▼▼
  PurchaseManager? _purchaseManager;

  // 外部からロック状態を確認するためのゲッター
  bool get isYakuzaUnlocked => _purchaseManager?.isYakuzaUnlocked ?? false;

  void updatePurchaseManager(PurchaseManager manager) {
    // サービスが変わっていなければ何もしない
    if (_purchaseManager == manager) return;
    
    // 古いリスナーを解除（もしあれば）
    _purchaseManager?.removeListener(_onPurchaseUpdated);
    
    // 新しいサービスをセットして監視開始
    _purchaseManager = manager;
    _purchaseManager!.addListener(_onPurchaseUpdated);
    
    // 即座に一度更新通知
    notifyListeners();
  }

  void _onPurchaseUpdated() {
    notifyListeners();
  }

  QuizProvider() {
    // コンストラクタでの初期化は不要になり、updatePurchaseManagerで紐付けされます
    loadMasterData();
    _loadWeakWords();

    // 言語設定の変更を監視して、データ（slang_data_xx.json）をリロードする
    LocaleSettings.getLocaleStream().listen((locale) {
      loadMasterData();
    });
  }

  Future<void> _loadWeakWords() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('weak_word_ids') ?? [];
    _weakWordIds = list.toSet();
    notifyListeners();
  }

  Future<void> toggleWeakWord(String wordId, bool isWeak) async {
    if (isWeak) {
      _weakWordIds.add(wordId);
    } else {
      _weakWordIds.remove(wordId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('weak_word_ids', _weakWordIds.toList());
    notifyListeners();
  }

  // カテゴリーごとの苦手件数を取得
  int getCategoryWeakCount(String levelId) {
    if (_masterData == null) return 0;
    List<SlangItem> list = _getListByLevelId(levelId);
    return list.where((item) => _weakWordIds.contains(item.word)).length;
  }

  // 全カテゴリーの苦手合計（表示中の6カテゴリーのみ）
  int getTotalWeakCount() {
    int total = 0;
    total += getCategoryWeakCount('lv1');
    total += getCategoryWeakCount('lv2');
    total += getCategoryWeakCount('lv3');
    total += getCategoryWeakCount('lv4');
    total += getCategoryWeakCount('lv5');
    total += getCategoryWeakCount('level6_yakuza');
    return total;
  }

  // 全カテゴリーの復習を開始
  void startAllCategoryReview() {
    if (_masterData == null) return;
    List<SlangItem> allItems = [];
    allItems.addAll(_masterData!.level1);
    allItems.addAll(_masterData!.level2);
    allItems.addAll(_masterData!.level3);
    allItems.addAll(_masterData!.level4);
    allItems.addAll(_masterData!.level5);
    allItems.addAll(_masterData!.level6);

    List<SlangItem> reviewList = allItems.where((item) => _weakWordIds.contains(item.word)).toList();
    
    if (reviewList.isNotEmpty) {
      _currentList = List.from(reviewList);
      _currentLevelTitle = t.review.modal.allQuestions; // "All Categories"
      notifyListeners();
    }
  }

  List<SlangItem> _getListByLevelId(String levelId) {
    if (_masterData == null) return [];
    switch (levelId) {
      case 'lv1': return _masterData!.level1;
      case 'lv2': return _masterData!.level2;
      case 'lv3': return _masterData!.level3;
      case 'lv4': return _masterData!.level4;
      case 'lv5': return _masterData!.level5;
      case 'level6_yakuza': return _masterData!.level6;
      default: return [];
    }
  }

  // Persona（一人称）カテゴリの単語を返す
  List<SlangItem> getPersonaSlangItems() {
    if (_masterData == null) return [];
    return List.from(_masterData!.level5);
  }

  // Persona（一人称）以外の全てのレベルの単語をマージして返す
  List<SlangItem> getNonPersonaSlangItems() {
    if (_masterData == null) return [];
    return [
      ..._masterData!.level1,
      ..._masterData!.level2,
      ..._masterData!.level3,
      ..._masterData!.level4,
      ..._masterData!.level6,
    ];
  }

  // 指定されたアイテムが Persona（一人称）カテゴリに属するか判定
  bool isPersonaItem(SlangItem item) {
    if (_masterData == null) return false;
    return _masterData!.level5.any((p) => p.word == item.word);
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
        _currentLevelColor = Colors.orange;
        break;
      case 'lv2':
        _currentList = _masterData!.level2;
        _currentLevelTitle = t.levelSelect.levels.level2.title;
        _currentLevelColor = Colors.pink;
        break;
      case 'lv3':
        _currentList = _masterData!.level3;
        _currentLevelTitle = t.levelSelect.levels.level3.title;
        _currentLevelColor = Colors.purple;
        break;
      case 'lv4':
        _currentList = _masterData!.level4;
        _currentLevelTitle = t.levelSelect.levels.level4.title;
        _currentLevelColor = Colors.blue;
        break;
      case 'lv5':
        _currentList = _masterData!.level5;
        _currentLevelTitle = t.levelSelect.levels.level5.title;
        _currentLevelColor = Colors.teal;
        break;
      case 'level6_yakuza':
        _currentList = _masterData!.level6;
        _currentLevelTitle = t.levelSelect.levels.level6.title;
        _currentLevelColor = Colors.black;
        
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

    // シャッフルモード または 未解放ヤクザ 以外でシャッフル
    if (_selectedMode == QuizMode.shuffle && shouldShuffle) {
      _currentList.shuffle();
    }

    // 制限ロジック
    if (_selectedMode == QuizMode.shuffle) {
      // シャッフルモードは10問程度に限定
      if (_currentList.length > 10) {
        _currentList = _currentList.sublist(0, 10);
      }
    } else {
      // 順番通りモード（プレミアム限定だが、Provider側では全問題を渡す。UIでロック制御）
      // 特に追加の制限はしない
    }
    
    // ヤクザレベルの特殊ルール (未解放ならシャッフルせず全リストを渡す)
    if (!isYakuzaUnlocked && levelId == 'level6_yakuza') {
       // そのまま
    }
    
    notifyListeners();
  }

  // 特定カテゴリーの復習を開始
  void startCategoryReview(String levelId) {
    if (_masterData == null) return;
    List<SlangItem> fullList = _getListByLevelId(levelId);
    List<SlangItem> reviewList = fullList.where((item) => _weakWordIds.contains(item.word)).toList();
    
    if (reviewList.isNotEmpty) {
      _currentList = List.from(reviewList);
      String catTitle = "";
      switch (levelId) {
        case 'lv1': catTitle = t.levelSelect.levels.level1.title; break;
        case 'lv2': catTitle = t.levelSelect.levels.level2.title; break;
        case 'lv3': catTitle = t.levelSelect.levels.level3.title; break;
        case 'lv4': catTitle = t.levelSelect.levels.level4.title; break;
        case 'lv5': catTitle = t.levelSelect.levels.level5.title; break;
        case 'level6_yakuza': catTitle = t.levelSelect.levels.level6.title; break;
      }
      _currentLevelTitle = "${t.quiz.reviewMode} ($catTitle)";
      notifyListeners();
    }
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

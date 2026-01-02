// lib/providers/quiz_provider.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/slang_item.dart';

class QuizProvider with ChangeNotifier {
  // 全データ保持用
  SlangData? _masterData;
  
  // 現在プレイ中のリスト
  List<SlangItem> _currentList = [];
  List<SlangItem> get slangList => _currentList;

  // 現在のレベル名（タイトル表示用）
  String _currentLevelTitle = "";
  String get currentLevelTitle => _currentLevelTitle;

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

    switch (levelId) {
      case 'lv1':
        _currentList = _masterData!.level1;
        _currentLevelTitle = "Level 1: Survival";
        break;
      case 'lv2':
        _currentList = _masterData!.level2;
        _currentLevelTitle = "Level 2: Otaku";
        break;
      case 'lv3':
        _currentList = _masterData!.level3;
        _currentLevelTitle = "Level 3: Internet";
        break;
      case 'lv4':
        _currentList = _masterData!.level4;
        _currentLevelTitle = "Level 4: Youth";
        break;
      case 'bonus':
        _currentList = _masterData!.bonus;
        _currentLevelTitle = "Bonus: Persona";
        break;
      default:
        _currentList = _masterData!.level1;
    }
    
    // 毎回順番が変わるようにシャッフルして、コピーを作成（元のリストを破壊しないため）
    _currentList = List.of(_currentList)..shuffle();

    // 10問に制限する
    if (_currentList.length > 10) {
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

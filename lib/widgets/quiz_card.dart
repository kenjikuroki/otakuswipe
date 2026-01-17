// lib/widgets/quiz_card.dart

import 'package:flutter/material.dart';
import '../models/slang_item.dart';
import '../i18n/strings.g.dart'; // Localized strings

class QuizCard extends StatelessWidget {
  final SlangItem slangItem;
  final bool isFlipped; // ← これを追加！

  const QuizCard({
    super.key,
    required this.slangItem,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        // isFlipped が true なら裏面、false なら表面を表示
        child: isFlipped ? _buildBackSide() : _buildFrontSide(),
      ),
    );
  }

  // 🌞 表面（問題）のデザイン
  Widget _buildFrontSide() {
    return _buildScrollableContent(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. 画像エリア (16:9で固定)
          AspectRatio(
            aspectRatio: 3 / 2, // 16:9より少し縦長にして拡大表示（両端カット）
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  slangItem.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // 2. タグ
          Wrap(
            spacing: 8,
            children: slangItem.tags.map((tag) => Chip(
              label: Text(
                "#$tag", 
                style: const TextStyle(
                  fontSize: 10, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4E342E), // Colors.brown[800]
                )
              ),
              backgroundColor: Colors.amber[100],
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )).toList(),
          ),

          const Spacer(),

          // 3. 単語 (Maji)
          Text(
            slangItem.word,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          // 4. ローマ字 (Maji de)
          if (slangItem.romaji != null && slangItem.romaji!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                slangItem.romaji!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const SizedBox(height: 12), // スペース調整

          Text(
            t.quiz.tapToSeeMeaning,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // 🌙 裏面（答え）のデザイン
  Widget _buildBackSide() {
    return _buildScrollableContent(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1. 意味 (Really?)
          Text(
            slangItem.meaning,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          
          const Divider(height: 40, thickness: 2),

          // 2. 解説
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text("📝 Explanation", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                const SizedBox(height: 8),
                Text(
                  slangItem.explanation,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. 例文 (あれば)
          if (slangItem.example != null) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("🗣 Usage:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 4),
            Text(
              slangItem.example!,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],

          // 4. 警告 (あれば)
          if (slangItem.warning != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    slangItem.warning!,
                    style: TextStyle(color: Colors.red[800], fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }

  // スクローラブルなコンテナのラッパー
  // 中身が画面に収まる場合は中央寄せ(Spacer有効)、あふれる場合はスクロール可能にする
  Widget _buildScrollableContent(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: child,
            ),
          ),
        );
      },
    );
  }
}

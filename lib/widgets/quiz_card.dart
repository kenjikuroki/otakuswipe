import 'package:flutter/material.dart';
import '../models/slang_item.dart';

class QuizCard extends StatelessWidget {
  final SlangItem slangItem;

  const QuizCard({Key? key, required this.slangItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. 画像を表示 (画像がある場合のみ)
            if (slangItem.imagePath.isNotEmpty)
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    slangItem.imagePath,
                    fit: BoxFit.cover,
                    // 画像がない時のエラー回避（白い四角を出す）
                    errorBuilder: (c, o, s) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.image_not_supported)),
                    ),
                  ),
                ),
              ),
            
            const SizedBox(height: 20),

            // 2. タグを表示 (Basic, Youth など)
            Wrap(
              spacing: 8,
              children: slangItem.tags.map((tag) => Chip(
                label: Text(tag, style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.amber[100],
              )).toList(),
            ),

            const SizedBox(height: 10),

            // 3. 単語をドーンと表示
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  slangItem.word,
                  style: const TextStyle(
                    fontSize: 40, 
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'Mplus1', // フォントはmain.dartで設定されているものを継承
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            // 4. 注意書きがあれば表示
            if (slangItem.warning != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  "⚠️ ${slangItem.warning}",
                  style: TextStyle(color: Colors.red[800], fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

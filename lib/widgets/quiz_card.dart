// lib/widgets/quiz_card.dart

import 'package:flutter/material.dart';
import '../models/slang_item.dart';
import '../i18n/strings.g.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizCard extends StatelessWidget {
  final SlangItem slangItem;
  final bool isFlipped;

  const QuizCard({
    super.key,
    required this.slangItem,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FF), // Very Light Purple
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D0B5A).withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
          // 1. 画像エリア
          AspectRatio(
            aspectRatio: 3 / 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF2D0B5A).withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  slangItem.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    color: const Color(0xFF2D0B5A).withOpacity(0.05),
                    child: const Center(
                      child: Icon(Icons.image_rounded, size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),

          // 2. タグ
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slangItem.tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2D0B5A).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "#$tag", 
                style: GoogleFonts.outfit(
                  fontSize: 11, 
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D0B5A).withOpacity(0.5),
                )
              ),
            )).toList(),
          ),

          const Spacer(),

          // 3. 単語
          Text(
            slangItem.word,
            style: GoogleFonts.outfit(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2D0B5A),
            ),
            textAlign: TextAlign.center,
          ),
          
          // 4. ローマ字
          if (slangItem.romaji != null && slangItem.romaji!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                slangItem.romaji!,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2D0B5A).withOpacity(0.4),
                  letterSpacing: 2.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          const SizedBox(height: 20),

          Text(
            t.quiz.tapToSeeMeaning,
            style: GoogleFonts.outfit(color: const Color(0xFF2D0B5A).withOpacity(0.3), fontSize: 13),
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
          // 1. 意味
          Text(
            slangItem.meaning,
            style: GoogleFonts.outfit(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2D0B5A),
            ),
            textAlign: TextAlign.center,
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Divider(height: 1, thickness: 1, color: Color(0xFF2D0B5A) ,), // Color(0xFF2D0B5A).withOpacity(0.1) would be better but let's see
          ),

          // 2. 解説
          Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D0B5A).withOpacity(0.04),
                   blurRadius: 10,
                   offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  "NOTES", 
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900, 
                    color: const Color(0xFF2D0B5A).withOpacity(0.3),
                    letterSpacing: 1.5,
                    fontSize: 12,
                  )
                ),
                const SizedBox(height: 12),
                Text(
                  slangItem.explanation,
                  style: GoogleFonts.outfit(fontSize: 16, height: 1.5, color: const Color(0xFF2D0B5A).withOpacity(0.8)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 3. 例文
          if (slangItem.example != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "EXAMPLE", 
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900, 
                  color: const Color(0xFF2D0B5A).withOpacity(0.3),
                  fontSize: 11,
                  letterSpacing: 1.2,
                )
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF2D0B5A).withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                slangItem.example!,
                style: GoogleFonts.outfit(fontSize: 17, fontStyle: FontStyle.italic, color: const Color(0xFF2D0B5A)),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          // 4. 警告
          if (slangItem.warning != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF44336).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF44336).withOpacity(0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFF44336), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      slangItem.warning!,
                      style: GoogleFonts.outfit(color: const Color(0xFFF44336), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
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
  Widget _buildScrollableContent(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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

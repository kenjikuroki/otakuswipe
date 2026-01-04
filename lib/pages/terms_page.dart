import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of Use"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Terms of Use",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Thank you for using this application. By using this app, you agree to the following terms.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 30),
            _SectionTitle("1. Disclaimer"),
            _SectionContent(
              "The developer shall not be held responsible for any damages resulting from the use of this application. Additionally, we do not guarantee the accuracy or completeness of the information provided within the app.",
            ),
            SizedBox(height: 20),
            _SectionTitle("2. Intellectual Property"),
            _SectionContent(
              "Copyrights for the content (text, images, programs, etc.) included in this app belong to the developer or the respective rights holders. Unauthorized reproduction, modification, or sale is prohibited.",
            ),
            SizedBox(height: 20),
            _SectionTitle("3. Changes to Service"),
            _SectionContent(
              "The developer reserves the right to change the content of the app or discontinue its provision without prior notice.",
            ),
            SizedBox(height: 20),
            _SectionTitle("4. Governing Law"),
            _SectionContent(
              "These terms shall be governed by and interpreted in accordance with the laws of Japan.",
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _SectionContent extends StatelessWidget {
  final String text;
  const _SectionContent(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black54),
      ),
    );
  }
}

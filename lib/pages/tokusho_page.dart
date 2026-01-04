import 'package:flutter/material.dart';

class TokushoPage extends StatelessWidget {
  const TokushoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Specified Commercial Transactions Act"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _RowItem("Sales Price", "Please refer to the price displayed on the purchase screen."),
            Divider(),
            _RowItem("Payment Time & Method", "Charged to your Apple ID / Google Play account at the time of purchase."),
            Divider(),
            _RowItem("Delivery Time", "Available immediately after payment completion."),
            Divider(),
            _RowItem("Returns / Cancellations", "Due to the nature of digital content, returns or cancellations are not accepted after purchase."),
            Divider(),
            _RowItem("Business Name", "kenji kuroki"),
            Divider(),
            _RowItem("Address", "Will be disclosed without delay upon request."),
            Divider(),
            _RowItem("Contact", "sanataro2025@protonmail.com\n(Will be disclosed without delay upon request)"),
            Divider(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String title;
  final String content;

  const _RowItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

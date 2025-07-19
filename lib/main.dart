import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodbuy/app/app_widget.dart';

void main() {
  runApp(
    ProviderScope(
      child: const GoodBuyApp()
    )
  );
}

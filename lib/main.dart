import 'package:clatch_rcikmorti/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Rick and Morty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const Scaffold(),
    ),
  );
}

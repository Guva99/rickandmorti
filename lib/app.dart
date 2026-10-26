import 'package:clatch_rcikmorti/core/di/injection.dart';
import 'package:clatch_rcikmorti/core/theme/app_theme.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:clatch_rcikmorti/features/characters/presentation/pages/catalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<CharactersBloc>()..add(const CharactersStarted()),
    child: MaterialApp(
      title: 'Rick and Morty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const CatalogPage(),
    ),
  );
}

import 'package:clatch_rcikmorti/features/characters/presentation/bloc/characters_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<CharactersBloc>().state.query,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) =>
      context.read<CharactersBloc>().add(CharactersQueryChanged(query));

  void _clear() {
    _controller.clear();
    _search('');
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: _controller,
    onChanged: _search,
    textInputAction: TextInputAction.search,
    onTapOutside: (_) => FocusScope.of(context).unfocus(),
    decoration: InputDecoration(
      hintText: 'Search by name',
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, value, _) => value.text.isEmpty
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: _clear,
                tooltip: 'Clear',
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    ),
  );
}

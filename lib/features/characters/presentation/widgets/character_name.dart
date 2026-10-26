import 'package:clatch_rcikmorti/features/characters/domain/entities/character.dart';
import 'package:flutter/material.dart';

class CharacterName extends StatelessWidget {
  const CharacterName({
    required this.character,
    required this.style,
    this.maxLines,
    super.key,
  });

  final Character character;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Hero(
    tag: 'character-name-${character.id}',
    flightShuttleBuilder: _flight,
    child: _Name(text: character.name, style: style, maxLines: maxLines),
  );

  Widget _flight(
    BuildContext context,
    Animation<double> animation,
    HeroFlightDirection direction,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final from = _nameOf(fromHeroContext);
    final to = _nameOf(toHeroContext);
    final (begin, end) = direction == HeroFlightDirection.push
        ? (from, to)
        : (to, from);

    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, _) => _Name(
          text: character.name,
          style: TextStyle.lerp(begin?.style, end?.style, animation.value),
          maxLines: to?.maxLines,
        ),
      ),
    );
  }

  static _Name? _nameOf(BuildContext heroContext) =>
      switch (heroContext.widget) {
        Hero(child: final _Name name) => name,
        _ => null,
      };
}

class _Name extends StatelessWidget {
  const _Name({required this.text, required this.style, this.maxLines});

  final String text;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: style,
    maxLines: maxLines,
    overflow: maxLines == null ? null : TextOverflow.ellipsis,
  );
}

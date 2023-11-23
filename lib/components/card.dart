import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.randomWord,
  });

  final randomWord;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    var styleMobile = theme.textTheme.bodyMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          color: theme.colorScheme.primary,
          child: Padding(
            padding: constraints.maxWidth >= 380
                ? const EdgeInsets.all(20)
                : const EdgeInsets.all(10),
            child: Text(
              randomWord,
              style: constraints.maxWidth >= 600 ? style : styleMobile,
              semanticsLabel: randomWord,
            ),
          ),
        );
      },
    );
  }
}

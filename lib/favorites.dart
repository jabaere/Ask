import 'package:ask/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var styleH1 =
        theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary);
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No saved items yet', style: styleH1),
      );
    }
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.all(20),
            child: Text('you have ${appState.favorites.length} favorites:')),
        for (var word in appState.favorites)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(word.toLowerCase()),
          )
      ],
    );
  }
}

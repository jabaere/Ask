import 'package:ask/components/card.dart';
import 'package:ask/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var randomWord = appState.current;
    var theme = Theme.of(context);
    var styleH1 =
        theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary);
    var styleH2 =
        theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onPrimary);
    //icon
    IconData icon;

    if (appState.favorites.contains(randomWord)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: constraints.maxWidth >= 600
                ? const EdgeInsets.all(80.0)
                : const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: constraints.maxWidth >= 600
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                        'A randomly chosen word to expand the English vocabulary base.',
                        style: styleH1,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    Text('Generate new words to show how a tree grows',
                        style: styleH2, textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BigCard(randomWord: randomWord ?? ''),
                    BigCard(randomWord: appState.geo),
                    const SizedBox(height: 20),
                    constraints.maxWidth >= 600
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () {
                                    appState.toggleFavorite();
                                  },
                                  icon: Icon(icon),
                                  label: const Text('Save')),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () {
                                    appState.getNext();
                                  },
                                  child: const Text('Next')),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    appState.getNext();
                                  },
                                  child: const Text('Next')),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                  onPressed: () {
                                    appState.toggleFavorite();
                                  },
                                  icon: Icon(icon),
                                  label: const Text('Save')),
                            ],
                          ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

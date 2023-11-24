import 'dart:convert';
import 'dart:math';
import 'package:ask/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'favorites.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:rive/rive.dart' as h;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Ask',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 34, 203, 255)),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String? current;
  final translator = GoogleTranslator();
  var geo = '';
  String? firstWord;
  List<String> words = [];
  var favorites = <String>[];
  double progress = 0;

// Call loadWords when the app state is initialized
  MyAppState() {
    loadWords();
  }

  // fetch words
  void loadWords() async {
    try {
      String jsonString = await rootBundle.loadString('assets/words.json');
      List<dynamic> parsedJson = jsonDecode(jsonString);
      words = parsedJson.cast<String>();

      // Set the first word and current if the words list is not empty
      if (words.isNotEmpty) {
        // Set current to a random word from the list on app load
        current = getRandomWord();
        translate();
      }
    } catch (e) {
      print('Error loading JSON file: $e');
    }

    // Notify listeners about the change in data
    notifyListeners();
  }

  //translate genereted word
  void translate() {
    translator.translate(current.toString(), from: 'en', to: 'ka').then((s) {
      geo = s.toString();
      notifyListeners();
    });
  }

  //handle button click
  void getNext() {
    // Generate a random word index between 0 and 3000
    int randomIndex = Random().nextInt(3000);
    current = words[randomIndex];
    translate();
    progress += 2;
  }

  // Save words to favorites
  void toggleFavorite() {
    if (current != null) {
      if (favorites.contains(current)) {
        favorites.remove(current);
      } else {
        favorites.add(current!);
      }
      notifyListeners();
    }
  }

  // Get a random word from the loaded list
  String getRandomWord() {
    if (words.isNotEmpty) {
      int randomIndex = Random().nextInt(words.length);
      return words[randomIndex];
    }
    return '';
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  //tree
  h.Artboard? _riveArtboard;
  h.SMIInput<double>? _progress;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/tree.riv').then(
      (data) async {
        final file = h.RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            h.StateMachineController.fromArtboard(artboard, 'State Machine 1');
        if (controller != null) {
          artboard.addController(controller);
          _progress = controller.findInput('input');
          setState(() {
            _riveArtboard = artboard;
          });
        }
      },
    );
  }

//update ui
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var appState = context.watch<MyAppState>();
    if (_progress != null) {
      _progress!.value = appState.progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      default:
        throw UnimplementedError("page not found");
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: Stack(
                children: [
                  NavigationRail(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (val) {
                      setState(() {
                        selectedIndex = val;
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: _riveArtboard != null
                            ? h.Rive(
                                alignment: Alignment.center,
                                artboard: _riveArtboard!,
                              )
                            : Container(),
                      ), // Your text widget
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 20, 30, 48),
                        Color.fromARGB(255, 36, 59, 85),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: page,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// class GeoCard extends StatelessWidget {
//   const GeoCard({
//     super.key,
//     required this.randomWord,
//   });

//   final String randomWord;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!
//         .copyWith(color: theme.colorScheme.onPrimary);
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text(
//           randomWord.toLowerCase(),
//           style: style,
//         ),
//       ),
//     );
//   }
// }

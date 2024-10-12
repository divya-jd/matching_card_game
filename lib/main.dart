import 'package:flutter/material.dart';
import 'dart:async'; // Import Timer class for delay functionality

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int matchedPairs = 0;

  // List of unique image paths for the pairs (4 unique images, each appearing twice)
  final List<String> cardImages = [
    'assets/smile.png',   // Image 1
    'assets/smile.png',   // Image 1 (duplicate)
    'assets/smile2.png',  // Image 2
    'assets/smile2.png',  // Image 2 (duplicate)
    'assets/smile3.png',  // Image 3
    'assets/smile3.png',  // Image 3 (duplicate)
    'assets/smile4.png',  // Image 4
    'assets/smile4.png',  // Image 4 (duplicate)
  ];

  // To hold the shuffled card images
  late List<String> shuffledCardImages;

  // List to keep track of face-up/face-down states for the cards
  late List<bool> isFaceUp;

  // Keep track of the first selected card index
  int? firstSelectedIndex;

  @override
  void initState() {
    super.initState();
    resetGame(); // Initialize game state
  }

  void resetGame() {
    matchedPairs = 0;
    isFaceUp = List.generate(8, (index) => false); // Reset all cards to face-down
    shuffledCardImages = List.from(cardImages); // Use the defined pairs directly
    shuffledCardImages.shuffle(); // Shuffle the images for a new game
  }

  void flipCard(int index) {
    if (firstSelectedIndex == null) {
      setState(() {
        isFaceUp[index] = true;
        firstSelectedIndex = index;
      });
    } else {
      if (firstSelectedIndex == index) return; // Ignore if the same card is tapped

      setState(() {
        isFaceUp[index] = true;
      });

      // Check for a match after a brief delay
      Timer(const Duration(seconds: 1), () {
        if (shuffledCardImages[firstSelectedIndex!] != shuffledCardImages[index]) {
          setState(() {
            isFaceUp[firstSelectedIndex!] = false;
            isFaceUp[index] = false;
          });
        } else {
          matchedPairs++;
          // Check for a win condition
          if (matchedPairs == 4) { // Adjust to 4 pairs since we have 4 unique images
            // Show a dialog when all pairs are matched
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('You Win!'),
                content: const Text('Congratulations, you matched all the pairs!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      resetGame(); // Reset the game for a new round
                      setState(() {}); // Update UI after reset
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            );
          }
        }
        firstSelectedIndex = null; // Reset the first selected index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Matching Game'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // A 4x4 grid of cards
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 8, // Total number of cards (8 for 4 unique pairs)
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => flipCard(index),
            child: Card(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  color: isFaceUp[index] ? Colors.white : Colors.blue,
                  image: isFaceUp[index]
                      ? DecorationImage(
                          image: AssetImage(shuffledCardImages[index]),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: isFaceUp[index]
                    ? null
                    : const Center(
                        child: Text(
                          'Back',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}


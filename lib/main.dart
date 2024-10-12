import 'package:flutter/material.dart';

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
  // List of 8 unique image paths
  List<String> cardImages = [
    '/Users/joisedivya/card_matching_game/assets/smile.png',
    '/Users/joisedivya/card_matching_game/assets/smile2.png',
    '/Users/joisedivya/card_matching_game/assets/smile3.png',
    '/Users/joisedivya/card_matching_game/assets/smile4.png',
    '/Users/joisedivya/card_matching_game/assets/smile5.png',
    '/Users/joisedivya/card_matching_game/assets/smile6.png',
    '/Users/joisedivya/card_matching_game/assets/smile7.png',
    '/Users/joisedivya/card_matching_game/assets/smile8.png',
  ];

  // To hold the shuffled card images (16 entries, 8 pairs)
  List<String> shuffledCardImages = [];

  // List to keep track of face-up/face-down states for the cards
  List<bool> isFaceUp = List.generate(16, (index) => false); 

  @override
  void initState() {
    super.initState();
    // Duplicate and shuffle images to create a random 4x4 grid
    shuffledCardImages = List.from(cardImages)..addAll(cardImages); // Duplicate the image list
    shuffledCardImages.shuffle(); // Shuffle the images to randomize card positions
  }

  // Function to flip a card when tapped
  void flipCard(int index) {
    setState(() {
      isFaceUp[index] = !isFaceUp[index]; // Toggle card's face-up state
    });
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
        itemCount: 16, // Total number of cards (4x4 grid)
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => flipCard(index), // Call the flipCard function on tap
            child: Card(
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  color: isFaceUp[index] ? Colors.white : Colors.blue, // Face-up: White, Face-down: Blue
                  image: isFaceUp[index]
                      ? DecorationImage(
                          image: AssetImage(shuffledCardImages[index]), // Show the front image if face-up
                          fit: BoxFit.cover,
                        )
                      : null, // Face-down state shows no image
                ),
                child: isFaceUp[index]
                    ? null // If face-up, show the image only
                    : const Center(
                        child: Text(
                          'Back', // Display 'Back' when face-down
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

class CardModel {
  final String frontImage;
  bool isFaceUp;
  bool isMatched;

  CardModel({required this.frontImage, this.isFaceUp = false, this.isMatched = false});
}

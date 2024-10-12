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
  int score = 0; // Score variable
  late Timer timer;
  int elapsedTime = 0; // Timer variable

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
    score = 0; // Reset score
    elapsedTime = 0; // Reset timer
    isFaceUp = List.generate(8, (index) => false); // Reset all cards to face-down
    shuffledCardImages = List.from(cardImages); // Use the defined pairs directly
    shuffledCardImages.shuffle(); // Shuffle the images for a new game

    // Start timer
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        elapsedTime++; // Increment elapsed time every second
      });
    });
  }

  void flipCard(int index) {
    if (isFaceUp[index]) return; // Ignore if the card is already face up

    setState(() {
      isFaceUp[index] = true;
    });

    if (firstSelectedIndex == null) {
      firstSelectedIndex = index; // First card selected
    } else {
      if (firstSelectedIndex == index) return; // Ignore if the same card is tapped

      // Check for a match after a brief delay
      Timer(const Duration(seconds: 1), () {
        if (shuffledCardImages[firstSelectedIndex!] != shuffledCardImages[index]) {
          setState(() {
            isFaceUp[firstSelectedIndex!] = false;
            isFaceUp[index] = false;
            score -= 1; // Deduct points for a mismatch
          });
        } else {
          matchedPairs++;
          score += 2; // Add points for a match
          // Check for a win condition
          if (matchedPairs == 4) { // Adjust to 4 pairs since we have 4 unique images
            // Stop the timer
            timer.cancel();
            // Show a dialog when all pairs are matched
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('You Win!'),
                content: Text('Congratulations, you matched all the pairs!\nYour Score: $score\nTime: $elapsedTime seconds'),
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
  void dispose() {
    timer.cancel(); // Cancel timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Matching Game'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $score', style: const TextStyle(fontSize: 20)),
                Text('Time: $elapsedTime seconds', style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
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
                  child: FlippableCard(
                    isFaceUp: isFaceUp[index],
                    imagePath: shuffledCardImages[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlippableCard extends StatefulWidget {
  final bool isFaceUp;
  final String imagePath;

  const FlippableCard({Key? key, required this.isFaceUp, required this.imagePath}) : super(key: key);

  @override
  _FlippableCardState createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFaceUp) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(_animation.value * 3.14),
          child: Card(
            elevation: 4.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: widget.isFaceUp
                    ? DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.isFaceUp
                  ? null
                  : const Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

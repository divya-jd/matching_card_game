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
  List<bool> isFaceUp = List.generate(16, (index) => false); // Track the state of each card

  // Function to flip card when tapped
  void flipCard(int index) {
    setState(() {
      isFaceUp[index] = !isFaceUp[index];
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
        itemCount: 16, // Number of cards
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => flipCard(index), // Call the flipCard function on tap
            child: Card(
              elevation: 4.0,
              child: Container(
                color: isFaceUp[index] ? Colors.white : Colors.blue, // Change color based on face-up state
                child: Center(
                  child: isFaceUp[index]
                      ? const Text(
                          'Front', // Text when card is flipped (face-up)
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      : const Text(
                          'Back', // Text when card is face-down
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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

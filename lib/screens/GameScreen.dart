import 'package:flutter/material.dart';

class GameInfo {
  final String name;
  final String imageURL;
  final String description;

  const GameInfo(this.name, this.imageURL, this.description);

}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = ModalRoute.of(context)!.settings.arguments as GameInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: Column(
        children: [
          Image.network(game.imageURL),
          Text(game.description),
        ],
      ),
    );
  }
}
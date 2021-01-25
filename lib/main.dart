import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input_controller.dart' as InputController;
import 'game_core.dart';

void main() {
  runApp(AlphaOne());
}

class AlphaOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: "AlphaOne",
      home: GameScreen(),
    );
  }
}

/// Main Screen.
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Do one-time tasks that require the BuildContext (whether directly or not).
    if (gameLoopController == null) {
      firstTimeInitialization(context, this);
    }

    // The List of children for the Stack.
    List<Widget> stackChildren = [
      // Background.
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      // Score.
      Positioned(
        left: 14,
        top: 2,
        child: Text(
          'Score: ${score.toString().padLeft(4, "0")}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      // Energy bar.
      Positioned(
        left: 120,
        top: 2,
        width: screenWidth - 124,
        height: 22,
        child: LinearProgressIndicator(
          value: player.energy,
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.red),
        ),
      ),
      // Crystal.
      crystal.draw(),
    ];

    // Add enemies.
    for (int i = 0; i < 3; i++) {
      stackChildren.add(fish[i].draw());
      stackChildren.add(robots[i].draw());
      stackChildren.add(aliens[i].draw());
      stackChildren.add(asteroids[i].draw());
    }

    // Now the planet and the player (must be done after enemies to ensure proper z indexing).
    stackChildren.add(planet.draw());
    stackChildren.add(player.draw());

    // Add any explosions that are currently exploding.
    for (var i = 0; i < explosions.length; i++) {
      stackChildren.add(explosions[i].draw());
    }

    // Return the root widget.
    return Scaffold(
      body: GestureDetector(
        onPanStart: InputController.onPanStart,
        onPanUpdate: InputController.onPanUpdate,
        onPanEnd: InputController.onPanEnd,
        child: Stack(children: stackChildren),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:rotation_three_d_effect/double_sided_flip_widget.dart';
import 'package:rotation_three_d_effect/indefinite_rotation_three_d_effect.dart';
import 'package:rotation_three_d_effect/rotation_three_d_effect.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                spacing: 50,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                   DoubleSidedFlipWidget(
                    axis: FlipAxis.vertical,
                    enableTap: true,
                    enableDrag: true,                    
                    flipThreshold: 0.5,
                    perspective: 0.001,
                    front: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Text("Front")
                    ),
                    back: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Text("Back")
                    ),
                  ),
                  IndefiniteRotation3DEffect(
                    rotateY: true,
                    rotateX: false,
                    rotationCount: 10,
                    allowUserRotation: true,
                    rotationDuration: const Duration(seconds: 5),
                    child: FilledButton.tonal(
                      onPressed: () {},
                      child: const Text(
                        "Indefinite Continous Rotation",
                      ),
                    ),
                  ),
                  Rotation3DEffect.limitedReturnsInPlace(
                    child: const Text(
                      'Hello 3D Rotation! \n(Returns in place)',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                  Rotation3DEffect.limited(
                    maximumPan: 80,
                    child: FilledButton.tonal(
                      onPressed: () {},
                      child: const Text(
                        "Limited 3D Rotation (No return in place)",
                      ),
                    ),
                  ),
                  const Text("Unrestriced 3D Rotation"),
                  Rotation3DEffect(child: const FlutterLogo(size: 150)),
                  Rotation3DEffect(
                    maximumPan: 90,
                    returnsInPlace: true,
                    returnInPlaceDuration: const Duration(seconds: 1),
                    child: Card(
                      elevation: 6,
                      color: Colors.amber[300],
                      shadowColor: Colors.black,
                      child: const SizedBox(
                        height: 160,
                        width: 300,
                        child: Center(child: Text("Rotating Card")),
                      ),
                    ),
                  ),
                  Rotation3DEffect.limitedReturnsInPlace(
                    initalPosition: const Offset(21, 50),
                    child: const Text(
                      '3D Rotation with\nWith inital offset! \n(Returns in place)',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Rotation3DEffect(
                    maximumPan: 90,
                    returnsInPlace: true,
                    returnInPlaceDuration: const Duration(milliseconds: 200),
                    initalPosition: const Offset(45, 90),
                    endPosition: const Offset(45, 90),
                    child: const Card(
                      elevation: 6,
                      color: Colors.green,
                      shadowColor: Colors.black,
                      child: SizedBox(
                        height: 160,
                        width: 300,
                        child: Center(
                          child: Text(
                            "Rotating Card\nInitial and end pos:\nx: 45, y: 90",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

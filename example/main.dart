import 'package:flutter/material.dart';
import 'package:rotation_three_d_effect/rotation_three_d_effect.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ThreeDimensionalWidget.limitedReturnsInPlace(
                  child: Text(
                'Hello 3D Rotation! \n(Returns in place)',
                style: TextStyle(fontSize: 35),
              )),
              const SizedBox(
                height: 50,
              ),
              ThreeDimensionalWidget.limited(
                maximumPan: 80,
                child: FilledButton.tonal(
                    onPressed: () {},
                    child:
                        const Text("Limited 3D Rotation (No return in place)")),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text("Unrestriced 3D Rotation"),
              const ThreeDimensionalWidget(
                  child: FlutterLogo(
                size: 150,
              )),

              const SizedBox(
                height: 50,
              ),

              ThreeDimensionalWidget(
                maximumPan: 30,
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
            ],
          ),
        ),
      ),
    );
  }
}

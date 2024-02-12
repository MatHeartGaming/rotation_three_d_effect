<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Rotation 3D Effect

A Flutter package that allows to apply a Three Dimensional Rotation to any widget, also allowing the user to rotate it as they whish.

## Installation
Add the following line to your pubspec.yaml file:
dependencies:
  rotation_three_d_effect: ^0.1.1

## Usage

1. Import the package:
import 'package:rotation_three_d_effect/rotation_three_d_effect.dart';

2. Apply 3D Rotation Effect:
a) Limited Returns In Place:
```
ThreeDimensionalWidget.limitedReturnsInPlace(
  child: Text(
    'Hello 3D Rotation! \n(Returns in place)',
    style: TextStyle(fontSize: 35),
  ),
)
```

b) Limited Rotation (No Return in Place):
```
ThreeDimensionalWidget.limited(
  maximumPan: 80,
  child: FilledButton.tonal(
    onPressed: () {},
    child: const Text("Limited 3D Rotation (No return in place)"),
  ),
)
```

c) Full 3D Rotation:
```
ThreeDimensionalWidget(
  child: FlutterLogo(
    size: 150,
  ),
)
```

d) Full Custom:
```
ThreeDimensionalWidget(
    maximumPan: 20,
    returnsInPlace: true,
    returnInPlaceDuration: const Duration(seconds: 2),
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
)
```

This widget allows limited rotation with a return to the original position.


## Additional information
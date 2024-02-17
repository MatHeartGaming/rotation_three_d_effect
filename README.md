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

A Flutter package inspired by SwiftUI's rotation3DEffect that allows to apply a Three Dimensional rotation to any Widget.

## Installation
Add the following line to your pubspec.yaml file:
```
dependencies:
  rotation_three_d_effect: ^0.2.1
```

## Usage

1. Import the package:
```
import 'package:rotation_three_d_effect/rotation_three_d_effect.dart';
```

2. Apply 3D Rotation Effect:
a) Limited Returns In Place:
```
Rotation3DEffect.limitedReturnsInPlace(
  child: Text(
    'Hello 3D Rotation! \n(Returns in place)',
    style: TextStyle(fontSize: 35),
  ),
)
```
![Rotating Text](https://github.com/MatHeartGaming/readme_images/raw/main/rotating_text.gif)

b) Limited Rotation (No Return in Place):
```
Rotation3DEffect.limited(
  maximumPan: 80,
  child: FilledButton.tonal(
    onPressed: () {},
    child: const Text("Limited 3D Rotation (No return in place)"),
  ),
)
```
![Rotating Tonal Button](https://github.com/MatHeartGaming/readme_images/raw/main/rotating_tonal_button.gif)

c) Full 3D Rotation:
```
Rotation3DEffect(
  child: FlutterLogo(
    size: 150,
  ),
)
```
![Flutter Logo Rotating](https://github.com/MatHeartGaming/readme_images/raw/main/flutter_logo_rotating.gif)

d) Full Custom:
```
Rotation3DEffect(
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
![Flutter Logo Rotating](https://github.com/MatHeartGaming/readme_images/raw/main/rotating_card.gif)

e) Full Custom with Initial and End Offset of your chosing:
```
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
              "Rotating Card\nInitial and end pos:\nx: 45, y: 90")),
    ),
  ),
)
```
![Flutter Logo Rotating](https://github.com/MatHeartGaming/readme_images/raw/main/rotating_card_inital_end_offsets.gif)


## Important Notice
This project is still in development, bugs may be present and I encourage you to report them. New features are under development and will be coming in the next weeks.
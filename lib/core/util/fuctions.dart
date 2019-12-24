import 'dart:math';

/// Generates a Random Number within a range
Random randomNum = Random();
int randomInRange(int min, int max) => min + randomNum.nextInt(max - min);
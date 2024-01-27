import 'package:flutter/material.dart';

/// The recommended scaling factor for Material is 8.
///
/// See more https://medium.com/swlh/the-comprehensive-8pt-grid-guide-aa16ff402179
/// or https://material.io/design/layout/understanding-layout.html#layout-anatomy
const int kDefaultScalingFactor = 8;

/// value to initialize [width] values
const double widthMultiplier = 1;

/// value to initialize [height] values
const double heightMultiplier = 1;

///
/// Default app scaling sizes, considering responsiveness.
///
/// To ensure that App layouts are visually balanced, most measurements align to
/// 8 pixels, which corresponds to both spacing and the overall layout.
///
/// This class contains some static constants with most common sizes.
/// To create a variation with a different size, use the default constructor:
///
/// ```dart
/// // 10 * kDefaultScalingFactor = 80
/// const Dimension(10).value;
/// ```
///
class Dimension {
  /// Extra small = 4
  static const xxs = Dimension(0.5);

  /// Extra small = 8
  static const xs = Dimension(1);

  /// Small = 16
  static const sm = Dimension(2);

  /// Medium = 24
  static const md = Dimension(3);

  /// Large = 32
  static const lg = Dimension(4);

  /// Extra large = 40
  static const xl = Dimension(5);

  /// Extra large = 48
  static const xxl = Dimension(6);

  /// Extra large = 56
  static const xxxl = Dimension(7);

  final double _val;

  /// Raw double value, without considering responsiveness.
  double get value => _val * factor;

  /// The scaling factor for gutters and margins
  final int factor;

  /// Default [Dimension] constructor
  const Dimension(this._val, {this.factor = kDefaultScalingFactor});

  /// Binary subtraction operator.
  Dimension operator -(Dimension other) => Dimension((value - other.value) / factor);

  /// Binary addition operator.
  Dimension operator +(Dimension other) => Dimension((value + other.value) / factor);

  /// Multiplication operator.
  Dimension operator *(double operand) => Dimension(value * operand);
}

/// Add extension methods to [Dimension] handle responsiveness.
extension DimensionExtensions on Dimension {
  /// Current value with [widthMultiplier]
  double get width => widthMultiplier * value;

  /// Current value with [SizeConfig.heightMultiplier]
  double get height => heightMultiplier * value;

  /// Builds a [SizedBox] with vertical spacing (using [SizeConfig.heightMultiplier])
  SizedBox get vertical => SizedBox(height: heightMultiplier * value);

  /// Builds a [SizedBox] with horizontal spacing (using [SizeConfig.widthMultiplier])
  SizedBox get horizontal => SizedBox(width: widthMultiplier * value);
}

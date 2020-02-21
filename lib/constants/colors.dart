library ttd_colors;

import 'dart:ui';

import 'package:flutter/material.dart';

const int _denimPrimaryValue = 0xFF0A7DA0;

const Map<int, Color> _denimSwatch = <int, Color>{
  50: Color(0xFFE3F7FB),
  100: Color(0xFFC7EEF7),
  200: Color(0xFF76CFE3),
  300: Color(0xFF3EB1CC),
  400: Color(0xFF008EAF),
  500: Color(_denimPrimaryValue),
  600: Color(0xFF097090),
  700: Color(0xFF086480),
  800: Color(0xFF064B60),
  900: Color(0xFF043644),
};

const MaterialColor materialDenim = MaterialColor(
  _denimPrimaryValue,
  _denimSwatch,
);

const Color duckEgg = Color(0xFFE0F1E6);

const Color forest100 = Color(0xFFD5F0DE);

const Color moss = Color(0xFF19A064);

const Color squash = Color(0xFFFFD9A3);

const Color vermillion = Color(0xFFE65038);

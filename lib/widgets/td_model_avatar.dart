import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';
import 'package:toptodo/constants/td_colors.dart' as ttd_colors;

class TdModelAvatar extends StatelessWidget {
  const TdModelAvatar(this.model, {this.diameter = 40.0});
  final TdModel model;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      child: CircleAvatar(
        backgroundColor: ttd_colors.squash,
        child: _buildTdModelAvatar(model),
      ),
    );
  }
}

Widget _buildTdModelAvatar(TdModel model) => (model is TdPerson)
    ? ((model.avatar == null) ? _AvatarText(model) : _AvatarImage(model))
    : _AvatarText(model);

class _AvatarImage extends StatelessWidget {
  const _AvatarImage(this.model);
  final TdPerson model;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.memory(
        base64.decode(
          model.avatar,
        ),
      ),
    );
  }
}

class _AvatarText extends StatelessWidget {
  const _AvatarText(this.model);
  final TdModel model;

  @override
  Widget build(BuildContext context) {
    return Text(model.name.substring(0, 1).toUpperCase());
  }
}

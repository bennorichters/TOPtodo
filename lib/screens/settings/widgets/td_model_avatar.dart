import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toptodo_data/toptodo_data.dart';

import 'package:toptodo/utils/colors.dart' show squash;

class TdModelAvatar extends StatelessWidget {
  const TdModelAvatar(this.model);
  final TdModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: CircleAvatar(
        backgroundColor: squash,
        child: _buildTdModelAvatar(model),
      ),
    );
  }
}

Widget _buildTdModelAvatar(TdModel model) => (model is Person)
    ? ((model.avatar == null) ? _AvatarText(model) : _AvatarImage(model))
    : _AvatarText(model);


class _AvatarImage extends StatelessWidget {
  const _AvatarImage(this.model);
  final Person model;

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

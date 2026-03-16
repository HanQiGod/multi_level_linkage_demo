import 'package:flutter/material.dart';

class LinkageNode {
  const LinkageNode({
    required this.code,
    required this.label,
    this.children = const [],
  });

  final String code;
  final String label;
  final List<LinkageNode> children;
}

class LinkageDemoDefinition {
  const LinkageDemoDefinition({
    required this.title,
    required this.overview,
    required this.pickerTitle,
    required this.homeButtonText,
    required this.pickerButtonText,
    required this.icon,
    required this.accentColor,
    required this.chipColor,
    required this.data,
    required this.defaultSelecteds,
    required this.highlights,
    this.columnFlex,
    this.looping = false,
  });

  final String title;
  final String overview;
  final String pickerTitle;
  final String homeButtonText;
  final String pickerButtonText;
  final IconData icon;
  final Color accentColor;
  final Color chipColor;
  final List<LinkageNode> data;
  final List<int> defaultSelecteds;
  final List<String> highlights;
  final List<int>? columnFlex;
  final bool looping;
}

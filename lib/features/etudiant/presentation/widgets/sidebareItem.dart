import 'package:flutter/material.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final bool isHeader;
  final bool isLogout;

  const SidebarItem({
    required this.title,
    required this.icon,
    this.isHeader = false,
    this.isLogout = false,
  });
}

import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

class HomeScreen extends KFDrawerContent {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
    );
  }
}

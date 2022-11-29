import 'package:flutter/material.dart';

import 'home.dart';

class BatterDetail extends StatefulWidget {
  const BatterDetail({super.key, required this.album});
  final Album album;
  @override
  State<BatterDetail> createState() => _BatterDetailState();
}

class _BatterDetailState extends State<BatterDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text(widget.album.serialNumber),
    ));
  }
}

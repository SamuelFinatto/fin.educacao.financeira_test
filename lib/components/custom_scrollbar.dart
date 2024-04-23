import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CustomScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController controller;

  const CustomScrollbar({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  _CustomScrollbarState createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  bool _showScrollbar = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _showScrollbar = false;
      });
    });
  }

  void _restartTimer() {
    _timer?.cancel();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showScrollbar = true;
          _restartTimer();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          if (_showScrollbar)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                controller: widget.controller,
                child: Container(
                  width: 12,
                  color: Colors.grey.withOpacity(0.5),
                  child: GestureDetector(
                    onTap: () {
                      // Prevents the tap from reaching the underlying widget
                    },
                    child: Container(
                      width: 12,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
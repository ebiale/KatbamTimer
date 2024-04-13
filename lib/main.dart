import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catbamdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountdownScreen(),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late DateTime _twoAM;
  late Duration _difference;
  late Timer _timer;

  bool _isRed = false;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _twoAM = DateTime(now.year, now.month, now.day, 2, 0, 0);
    _difference = _twoAM.difference(now);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_difference.inSeconds <= 0) {
            timer.cancel();
          } else {
            _difference -= const Duration(seconds: 1);

            if (_difference.inMinutes == 10 && !_isRed) {
              _isRed = true;
              _isBlinking = false;
            } else if (_difference.inMinutes == 5 && !_isBlinking) {
              _isRed = false;
              _isBlinking = true;
            }
          }
        });
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "כטב''ם דואון",
          style: TextStyle(
              fontSize: 50, color: _isRed ? Colors.red : Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _formatDuration(_difference),
              style: TextStyle(
                fontSize: 140,
                color: _isRed
                    ? Colors.red
                    : (_isBlinking ? Colors.blue : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

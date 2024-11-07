import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool isActive = false;

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    setState(() {
      isActive = true;
    });
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        _elapsedSeconds++; // Saniye sayacını artır
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      isActive = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        setState(() {
          isActive = true;
        });
      },
    ).whenComplete(() {
      isActive ? startTimer() : stopTimer();
      isActive
          ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [])
          : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
    _timer?.cancel();
  }

  String sureGetir(int saniye) {
    int minutes = saniye ~/ 60;
    int remainingSeconds = saniye % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Arka planı şeffaf yapın
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(sureGetir(_elapsedSeconds),
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 50, color: Colors.white)),
          const Center(
            child: Text(
              'SÜRE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  !isActive ? startTimer() : stopTimer();
                  isActive
                      ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [])
                      : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                },
                child: Icon(
                  _timer != null
                      ? !isActive
                          ? Icons.play_circle_rounded
                          : Icons.pause_circle_rounded
                      : Icons.play_circle_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              InkWell(
                onTap: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                  _timer?.cancel();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.stop_circle,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Geçiş animasyonları için PageRouteBuilder kullanımı
PageRouteBuilder<dynamic> createRoute() {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return const FocusPage();
    },
    transitionsBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    },
  );
}

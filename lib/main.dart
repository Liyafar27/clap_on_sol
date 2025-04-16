import 'dart:async';
import 'dart:html' as html;
import 'dart:math';
import 'dart:ui';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import 'ball_game.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Симуляция задержки, пока загружается сайт
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClapOnSolPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF69B4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(2, 4),
                    // Смещение тени
                    child: Image.asset(
                      'assets/title.png',
                      color: Colors.black.withOpacity(0.7), // "тень"
                    ),
                  ),
                  Image.asset('assets/title.png'),
                ],
              ),
            ),
            SizedBox(
              width: 100,
              child: Image.asset(
                'assets/slap.gif',
                // color: Colors.black.withOpacity(0.3),
                fit: BoxFit.cover,
                // "тень"
              ),
            ),
            SizedBox(height: 20),

            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text('Progressing...'),
          ],
        ),
      ),
    );
  }
}


class ClapOnSolPage extends StatefulWidget {
  const ClapOnSolPage({super.key});

  @override
  State<ClapOnSolPage> createState() => _ClapOnSolPageState();
}

class _ClapOnSolPageState extends State<ClapOnSolPage>
    with TickerProviderStateMixin {
  late AnimationController _clapController;
  late AnimationController _clapController2;
  late AnimationController _clapControllerBody;

  late Animation<double> _arcAnimation;
  late Animation<double> _arcAnimation1;
  late Animation<double> _arcAnimationBody;

  late VideoPlayerController _controller;
  late VideoPlayerController _controllerBody;
  late VideoPlayerController _controller3;

  bool _isPlaying = false;
  bool _isPlaying2 = false;
  bool _isPlayingBody = false;


  bool isAnimating = false;
  double ballScale = 1;
  double ballSkew = 0;
  double ballScale1 = 1;
  double ballSkew1 = 0;
  double ballScaleBody = 1;
  double ballSkewBody = 0;
  Future<void> _initAllVideos() async {
    await _controller.initialize();
    await _controllerBody.initialize();
    await _controller3.initialize();

    setState(() {}); // чтобы отобразились виджеты после инициализации

    // 🔄 Быстрое проигрывание и пауза
    _controller.setLooping(false);
    _controller.play();
    await Future.delayed(Duration(milliseconds: 1500));
    _controller.pause();
    _controller.seekTo(Duration.zero);

    _controllerBody.setLooping(false);
    _controllerBody.play();
    await Future.delayed(Duration(milliseconds: 1500));
    _controllerBody.pause();
    _controllerBody.seekTo(Duration.zero);

    _controller3.setLooping(false);
    _controller3.play();
    await Future.delayed(Duration(milliseconds:1500));
    _controller3.pause();
    _controller3.seekTo(Duration.zero);
  }
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/slap.mp4');
    _controllerBody = VideoPlayerController.asset('assets/slap1.mp4');
    _controller3 = VideoPlayerController.asset('assets/slap2.mp4');
    _initAllVideos();
    // _controller.initialize().then((_) {
    //   _controller.setLooping(true);
    //   setState(() {});
    // });
    // _controllerBody.initialize().then((_) {
    //   _controllerBody.setLooping(true);
    //   setState(() {});
    // });
    //
    // _controller3.initialize().then((_) {
    //   _controller3.setLooping(true);
    //   setState(() {});
    // });

    _clapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _clapController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _clapControllerBody = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _arcAnimation = Tween<double>(begin: 13, end: -2).animate(
      CurvedAnimation(parent: _clapController, curve: Curves.easeOutBack),
    );
    _arcAnimation1 = Tween<double>(begin: -13, end: 2).animate(
      CurvedAnimation(parent: _clapController2, curve: Curves.easeOutBack),
    );
    _arcAnimationBody = Tween<double>(begin: 6, end: -6).animate(
      CurvedAnimation(parent: _clapControllerBody, curve: Curves.easeOutBack),
    );
    _clapController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _clapController.reverse();
      }
    });
    _clapController2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _clapController2.reverse();
      }
    });
    _clapControllerBody.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _clapControllerBody.reverse();
      }
    });
  }

  void _togglePlayPause() {
    _controller.setPlaybackSpeed(0.8);
_controller.setLooping(true);
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller.seekTo(Duration.zero);
      _controller.play();
      setState(() => _isPlaying = true);

      Future.delayed(Duration(milliseconds: 1300), () {
        if (_controller.value.isPlaying) {
          _controller.pause();
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  void _togglePlayPauseBody() {
    _controllerBody.setPlaybackSpeed(1);
    _controllerBody.setLooping(true);
    if (_controllerBody.value.isPlaying) {
      _controllerBody.pause();
      setState(() => _isPlayingBody = false);
    } else {
      _controllerBody.seekTo(Duration.zero);
      _controllerBody.play();
      setState(() => _isPlayingBody = true);

      Future.delayed(Duration(milliseconds: 900), () {
        if (_controllerBody.value.isPlaying) {
          _controllerBody.pause();
          setState(() => _isPlayingBody = false);
        }
      });
    }
  }

  void _togglePlayPause3() {
    _controller3.setPlaybackSpeed(1.5);
    _controller3.setLooping(true);

    if (_controller3.value.isPlaying) {
      _controller3.pause();
      setState(() => _isPlaying2 = false);
    } else {
      _controller3.seekTo(Duration.zero);
      _controller3.play();
      setState(() => _isPlaying2 = true);

      Future.delayed(Duration(milliseconds: 1300), () {
        if (_controller3.value.isPlaying) {
          _controller3.pause();
          setState(() => _isPlaying2 = false);
        }
      });
    }
  }

  void _triggerClapBody() {
    _clapControllerBody.forward();
    _togglePlayPauseBody();
    setState(() {
      ballScaleBody = 0.80;
      ballSkewBody = 0.15;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        ballScaleBody = 1.0;
        ballSkewBody = 0.0;
      });
    });
  }

  void _triggerClap() {
    _clapController.forward();
    _togglePlayPause();
    setState(() {
      ballScale = 0.80;
      ballSkew = 0.15;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        ballScale = 1.0;
        ballSkew = 0.0;
      });
    });
  }

  void _triggerClap1() {
    _clapController2.forward();
    _togglePlayPause3();
    setState(() {
      ballScale1 = 0.80;
      ballSkew1 = 0.15;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        ballScale1 = 1.0;
        ballSkew1 = 0.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller3.dispose();
    _controllerBody.dispose();
    _clapController2.dispose();
    _clapController.dispose();
    _clapControllerBody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body:  SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height:
                      screenWidth < 800
                          ? screenWidth * 0.6 + 50
                          : screenWidth * 0.5 + 50,
                  color: Color(0xFFFF69B4),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Transform.translate(
                                  offset: const Offset(2, 2),
                                  child: SizedBox.expand(
                                    child: Image.asset(
                                      'assets/background.png',
                                      color: Colors.black.withOpacity(0.3),
                                      fit: BoxFit.cover,
                                      // "тень"
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.9,
                                  child: SizedBox.expand(
                                    child: Image.asset(
                                      'assets/background.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ScrollDownArrow(
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 50),
                              width: screenWidth / 0.25,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(2, 4),
                                    // Смещение тени
                                    child: Image.asset(
                                      'assets/title.png',
                                      color: Colors.black.withOpacity(
                                        0.7,
                                      ), // "тень"
                                    ),
                                  ),
                                  Image.asset('assets/title.png'),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: screenWidth * 0.1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        width:
                                            screenWidth < 800
                                                ? screenWidth * 0.20
                                                : screenWidth * 0.15,
                                        transform: Matrix4.skewX(ballSkew1)
                                          ..scale(ballScale1),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 10,
                                              spreadRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 100),
                                          child: AspectRatio(
                                            aspectRatio:
                                                _controller3.value.aspectRatio,
                                            child: RepaintBoundary(child: VideoPlayer(_controller3)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: screenWidth * 0.0001,
                                    top:
                                        screenWidth < 800
                                            ? screenWidth * 0.08
                                            : screenWidth * 0.08,
                                    child: AnimatedBuilder(
                                      animation: _arcAnimation1,
                                      builder: (context, child) {
                                        final angle =
                                            lerpDouble(
                                              3 * pi / 190.0,
                                              pi / -360,
                                              _arcAnimation1.value,
                                            )!;
                                        return GestureDetector(
                                          onTap: _triggerClap1,
                                          child: Transform.rotate(
                                            angle: angle + pi / 700,
                                            child: SizedBox(
                                              width:
                                                  screenWidth < 800
                                                      ? screenWidth * 0.20
                                                      : screenWidth * 0.20,
                                              child: Image.asset(
                                                'assets/hand3.png',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                  right: screenWidth * 0.1,
                                      top:
                                      screenWidth < 800
                                          ? screenWidth * 0.18
                                          : screenWidth * 0.18,child: TapPulseEffect(size:screenWidth * 0.05,))

                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(top: 20),
                              child: ClapLabelBubble(screenWidth: screenWidth),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top:
                                        screenWidth < 800
                                            ? screenWidth * 0.25
                                            : screenWidth * 0.20,
                                    left: screenWidth * 0.13,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        width:
                                            screenWidth < 800
                                                ? screenWidth * 0.25
                                                : screenWidth * 0.20,
                                        transform: Matrix4.skewX(ballSkew)
                                          ..scale(ballScale),
                                        decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              blurRadius: 10,
                                              spreadRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 100),
                                          child: AspectRatio(
                                            aspectRatio:
                                                _controller.value.aspectRatio,
                                            child: RepaintBoundary(child: VideoPlayer(_controller)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top:
                                        screenWidth < 800
                                            ? screenWidth * 0.35
                                            : screenWidth * 0.30,
                                    left:
                                        screenWidth < 800
                                            ? screenWidth * 0.0010
                                            : screenWidth * 0.0010,
                                    child: AnimatedBuilder(
                                      animation: _arcAnimation,
                                      builder: (context, child) {
                                        final angle =
                                            lerpDouble(
                                              3 * pi / 190.0,
                                              pi / -360,
                                              _arcAnimation.value,
                                            )!;
                                        return GestureDetector(
                                          onTap: _triggerClap,
                                          child: Transform.rotate(
                                            angle: angle + pi / 700,
                                            child: SizedBox(
                                              width:
                                                  screenWidth < 800
                                                      ? screenWidth * 0.25
                                                      : screenWidth * 0.25,
                                              child: Image.asset(
                                                'assets/hand2.png',
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(  top:
                                  screenWidth < 800
                                      ? screenWidth * 0.45
                                      : screenWidth * 0.40,
                                      left:
                                      screenWidth < 800
                                          ? screenWidth * 0.15
                                          : screenWidth * 0.15,child: TapPulseEffect(size:screenWidth * 0.05,))
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(top: 20),
                              child: ClapLabelBubble(screenWidth: screenWidth),
                            ),],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(horizontal: 8),

                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SelectableText(
                              "Bz7vVzQhm2KMW1XgcrDruYega1MiwrAs1DQysrx4tFkp",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    screenWidth < 800
                                        ? screenWidth / 40
                                        : screenWidth / 60,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
                                        'Bz7vVzQhm2KMW1XgcrDruYega1MiwrAs1DQysrx4tFkp',
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Copied!")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🖐️ Welcome to ClapOnSol!",
                        style: TextStyle(
                          fontSize: screenWidth < 800
                              ? screenWidth * 0.033
                              : screenWidth * 0.023,                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Dive into the wild world of Web3 fun on Solana! 🔥",
                        style: TextStyle(
                          fontSize: screenWidth < 800
                              ? screenWidth * 0.031
                              : screenWidth * 0.021,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Here, clapping isn’t just for applause — it’s a way of life. 🖐️🩷",
                        style: TextStyle( fontSize: screenWidth < 800
                            ? screenWidth * 0.03
                            : screenWidth * 0.02, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "👋 Tap the magic hand, slap the objects, and start stacking \$CLAP — our meme-powered token built for the true Solana degens.",
                        style: TextStyle( fontSize: screenWidth < 800
                            ? screenWidth * 0.03
                            : screenWidth * 0.02,color: Colors.black87),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "🚀 How it works:",
                        style: TextStyle(
                          fontSize: screenWidth < 800
                              ? screenWidth * 0.031
                              : screenWidth * 0.021,                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),

                      SizedBox(height:  screenWidth * 0.25,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,  // Добавляем центрирование

                          children: [
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(text: "👉 Tap the hand\n",
                                    style: TextStyle(
                                      fontSize: screenWidth < 800
                                          ? screenWidth * 0.03
                                          : screenWidth * 0.02,
                                    ),),
                                  TextSpan(text: "👉 Clap the 👋 'objects' 😏 \n",
                                    style: TextStyle(
                                      fontSize: screenWidth < 800
                                          ? screenWidth * 0.03
                                          : screenWidth * 0.02,
                                    ),),
                                  TextSpan(
                                    text: "👉 Earn \$CLAP tokens\n",
                                    style: TextStyle(
                                      fontSize: screenWidth < 800
                                          ? screenWidth * 0.03
                                          : screenWidth * 0.02,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "    (in progress)\n",
                                    style: TextStyle(
                                      fontSize: screenWidth < 800
                                          ? screenWidth * 0.03
                                          : screenWidth * 0.02,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(text: "👉 Repeat and have fun 😉",style: TextStyle(
                                    fontSize: screenWidth < 800
                                        ? screenWidth * 0.03
                                        : screenWidth * 0.02,
                                  ),),
                                ],
                              ),
                            ),

                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: screenWidth * 0.08),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      width:
                                          screenWidth < 800
                                              ? screenWidth * 0.25
                                              : screenWidth * 0.20,
                                      transform: Matrix4.skewX(ballSkewBody)
                                        ..scale(ballScaleBody),
                                      decoration: BoxDecoration(
                                        // shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 100),
                                        child: AspectRatio(
                                          aspectRatio:
                                              _controllerBody.value.aspectRatio,
                                          child: RepaintBoundary(child: VideoPlayer(_controllerBody)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: screenWidth * 0.01,top: screenWidth * 0.07,
                                  // height:  screenWidth < 800
                                  //     ? screenWidth * 0.25
                                  //     : screenWidth * 0.20,

                                  child: AnimatedBuilder(
                                    animation: _arcAnimationBody,
                                    builder: (context, child) {
                                      final angle =
                                      lerpDouble(
                                        3 * pi / 190.0,
                                        pi / -360,
                                        _arcAnimationBody.value,
                                      )!;
                                      return GestureDetector(
                                        onTap: _triggerClapBody,
                                        child: Transform.rotate(
                                          angle: angle + pi / 700,
                                          child: SizedBox(
                                            width:
                                            screenWidth < 800
                                                ? screenWidth * 0.20
                                                : screenWidth * 0.15,
                                            child: Image.asset('assets/hand2.png'),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                    top:screenWidth < 800?screenWidth * 0.2:screenWidth * 0.151,
                                    // screenWidth < 800
                                    //     ? screenWidth * 0.45
                                    //     : screenWidth * 0.40,
                                    left:screenWidth < 800?screenWidth * 0.09:screenWidth * 0.06,
                                    //     screenWidth < 800
                                    //         ? screenWidth * 0.15
                                    //         : screenWidth * 0.15,
                                    child: TapPulseEffect(size:screenWidth * 0.05,))
                              ],
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Ready to clap your way to the top? 👏🚀",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        fontSize: screenWidth < 800

                        ? screenWidth * 0.03
                          : screenWidth * 0.02,
                      ),
                      ),
                      SizedBox(height: 6),

                      Text(
                        "Whether you're here for laughs or to farm some digital chaos 💥, this is the place to let your inner degen high-five the blockchain ✋🧠",

                        style: TextStyle(
                        fontSize: screenWidth < 800
                        ? screenWidth * 0.03
                          : screenWidth * 0.02,
                      ),
                      ),
                      SizedBox(height: 6),

                      Text(
                        "Let’s clap it out! 👋",
                        style: TextStyle(
                          fontSize: screenWidth < 800
                              ? screenWidth * 0.032
                              : screenWidth * 0.022,
                          decoration: TextDecoration.overline,
                        ),
                      ),

                      SizedBox(height: 26),
                      Container(
                        alignment: Alignment.center,
                        width:screenWidth/2,
                         height: screenWidth/1.9+200,child: BubbleGamePage(screenWidth:screenWidth.toInt())),
                      // Container(
                      //   height: 500,
                      //   decoration: BoxDecoration(
                      //     color: const Color(0xFF1A1A1A),
                      //     borderRadius: BorderRadius.circular(20),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: const Color(0xFF00FF9D).withOpacity(0.1),
                      //         spreadRadius: 5,
                      //         blurRadius: 15,
                      //         offset: const Offset(0, 3),
                      //       ),
                      //     ],
                      //   ),
                      //   child: const DexScreenerChart(),
                      // ),
                      SizedBox(height: 26),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Wrap(
                      spacing: 30,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildSocialButton(
                          'X (Twitter)',
                          'https://x.com/claponsolx',
                          const Color(0xFF1DA1F2),
                          '𝕏',
                        ),
                        _buildSocialButton(
                          'Telegram',
                          'https://t.me/wapcoin',
                          const Color(0xFF0088CC),
                          '✈️',
                        ),
                        _buildSocialButton(
                          'DexScreener',
                          'https://dexscreener.com/solana/8pr4PXNzG8KcgzAkf5tebuPh1ct9ke5eC6VCd3PngutC',
                          const Color(0xFF00FF9D),
                          '📊',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )

    );
  }
}

Widget _buildSocialButton(String label, String url, Color color, String icon) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        html.window.open(url, '_blank');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF69B4).withOpacity(0.8), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF69B4).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              icon,
              style: GoogleFonts.fredoka(
                textStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              // const TextStyle(fontSize: 26, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.fredoka(
                textStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DexScreenerChart extends StatefulWidget {
  const DexScreenerChart({super.key});

  @override
  State<DexScreenerChart> createState() => _DexScreenerChartState();
}

class _DexScreenerChartState extends State<DexScreenerChart> {
  final String viewId = 'dexscreener-chart';

  @override
  void initState() {
    super.initState();
    // Register the view factory
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
      final div =
          html.DivElement()
            ..id = 'dexscreener-embed'
            ..style.position = 'relative'
            ..style.width = '100%'
            ..style.height = '100%';

      final style =
          html.StyleElement()
            ..text = '''
            #dexscreener-embed {
              position: relative;
              width: 100%;
              height: 100%;
            }
            #dexscreener-embed iframe {
              position: absolute;
              width: 100%;
              height: 100%;
              top: 0;
              left: 0;
              border: 0;
              pointer-events: none;
            }
            #dexscreener-embed iframe:hover {
              pointer-events: auto;
            }
          ''';

      final iframe =
          html.IFrameElement()
            ..src =
                'https://dexscreener.com/solana/8pr4PXNzG8KcgzAkf5tebuPh1ct9ke5eC6VCd3PngutC?embed=1&loadChartSettings=0&chartLeftToolbar=0&chartDefaultOnMobile=1&chartTheme=dark&theme=dark&chartStyle=0&chartType=usd&interval=15';

      // Add scroll event listener to the iframe
      iframe.onWheel.listen((event) {
        if (event.ctrlKey || event.metaKey) {
          // Allow zooming
          return;
        }
        // Prevent default scroll behavior
        event.preventDefault();
      });

      div.children.add(style);
      div.children.add(iframe);
      return div;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: RepaintBoundary(child: HtmlElementView(viewType: viewId)),
    );
  }
}

class ClapLabelBubble extends StatelessWidget {
  final double screenWidth;

  const ClapLabelBubble({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber[400],
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Text(
        'Tap the hands',
        style: GoogleFonts.fredoka(
          textStyle: TextStyle(
            fontSize: screenWidth / 40,
            fontWeight: FontWeight.w900,
            color: Colors.pinkAccent,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class CurvedBadge extends StatelessWidget {
  final String text;

  const CurvedBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvedContainerPainter(),
      child: SizedBox(
        height: 100,
        width: 300,
        child: Center(
          child: Transform.translate(
            offset: const Offset(0, 20),
            child: Text(
              text,
              style: GoogleFonts.luckiestGuy(fontSize: 22, color: Colors.pink),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvedContainerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFFFCC5C)
          ..style = PaintingStyle.fill;

    final path = Path();

    final curveHeight = 30.0;
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width / 2,
      0 - curveHeight,
      size.width,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width / 2,
      size.height + curveHeight,
      0,
      size.height * 0.5,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ScrollDownArrow extends StatefulWidget {

  const ScrollDownArrow({super.key, });

  @override
  State<ScrollDownArrow> createState() => _ScrollDownArrowState();
}

class _ScrollDownArrowState extends State<ScrollDownArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0.2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
class TapPulseEffect extends StatefulWidget {
  final double size;
  const TapPulseEffect({super.key, this.size = 100});

  @override
  State<TapPulseEffect> createState() => _TapPulseEffectState();
}

class _TapPulseEffectState extends State<TapPulseEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<Color> pulseColors = [
    Colors.pinkAccent.withOpacity(0.5),
    Colors.blueAccent.withOpacity(0.5),
    Colors.yellowAccent.withOpacity(0.5),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: List.generate(3, (index) {
                double progress = (_animation.value + index * 0.33) % 1.0;
                double scale = 0.5 + progress;
                double opacity = (1 - progress).clamp(0.0, 1.0);

                return Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.size * scale,
                    height: widget.size * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pulseColors[index % pulseColors.length],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

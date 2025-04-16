import 'dart:async';
import 'package:video_player/video_player.dart';

import 'src/browser_utils_stub.dart'
if (dart.library.html) 'src/browser_utils_html.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:video_player/video_player.dart';

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
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late VideoPlayerController _controllerBody;
  late VideoPlayerController _controller3;
  bool _videosReady = false;

  @override
  void initState() {
    super.initState();
    _initVideos();
  }

  Future<void> _prewarm(VideoPlayerController controller) async {
    try {
      await controller.play();
      await Future.delayed(Duration(milliseconds: 100));
      await controller.pause();
      await controller.seekTo(Duration.zero);
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> _initVideos() async {
    _controller = VideoPlayerController.asset('assets/slap.mp4');
    _controllerBody = VideoPlayerController.asset('assets/slap1.mp4');
    _controller3 = VideoPlayerController.asset('assets/slap2.mp4');
    _controller.setVolume(0);
    _controllerBody.setVolume(0);
    _controller3.setVolume(0);
    // Initialize the controllers
    await Future.wait([
      _controller.initialize(),
      _controllerBody.initialize(),
      _controller3.initialize(),
    ]);

    // Ensure that the state gets updated after the videos are initialized
    setState(() {
      _videosReady = true;
    });

    // Prewarm the videos
    await _prewarm(_controller);
    await _prewarm(_controllerBody);
    await _prewarm(_controller3);

    // Set looping for all controllers
    _controller.setLooping(true);
    _controllerBody.setLooping(true);
    _controller3.setLooping(true);

    // Navigate to next screen after a delay
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ClapOnSolPage(
            controller: _controller,
            controllerBody: _controllerBody,
            controller3: _controller3,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF69B4),
      body: Center(
        child:  Column(
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
                    child: Image.asset(
                      'assets/title.png',
                      color: Colors.black.withValues(alpha:0.7),
                    ),
                  ),
                  Image.asset('assets/title.png'),
                ],
              ),
            ),
            const SizedBox(
              width: 100,
              child: Image(
                image: AssetImage('assets/slap.gif'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            _videosReady
                ? Text('Loading videos...'):Text('Processing...'),

          ],
        )
      ),
    );
  }
}
  class ClapOnSolPage extends StatefulWidget {
    final VideoPlayerController controller;
    final VideoPlayerController controllerBody;
    final VideoPlayerController controller3;

    const ClapOnSolPage({
      super.key,
      required this.controller,
      required this.controllerBody,
      required this.controller3,
    });

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


  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controllerBody = widget.controllerBody;
    _controller3 = widget.controller3;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play();
      _controllerBody.play();
      _controller3.play();
    });
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
      body: SingleChildScrollView(
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
                                  color: Colors.black.withValues(alpha:0.3),
                                  fit: BoxFit.cover,
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
                          child: ScrollDownArrow(),
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
                                child: Image.asset(
                                  'assets/title.png',
                                  color: Colors.black.withValues(alpha:
                                    0.7,
                                  ),
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
                                    top:
                                        screenWidth < 800
                                            ? screenWidth * 0.01
                                            : screenWidth * 0.01,
                                left: screenWidth - screenWidth * 0.1 - (screenWidth * 0.15),
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
                                              color: Colors.black.withValues(alpha:
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
                                            child: RepaintBoundary(
                                              child: VideoPlayer(_controller3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ,
                              Positioned(
                                left:        screenWidth < 800
                                  ?screenWidth - screenWidth * 0.0001 - (screenWidth * 0.15):screenWidth - screenWidth * 0.0001 - (screenWidth * 0.20),
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
                                left:        screenWidth < 800
                                    ?screenWidth - screenWidth * 0.01 - (screenWidth * 0.10):screenWidth - screenWidth * 0.01 - (screenWidth * 0.15),
                                top:
                                    screenWidth < 800
                                        ? screenWidth * 0.18
                                        : screenWidth * 0.18,
                                child: TapPulseEffect(size: screenWidth * 0.05),
                              ),
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
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha:
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
                                            child: RepaintBoundary(
                                              child: VideoPlayer(_controller),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                 ,
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
                              Positioned(
                                top:
                                    screenWidth < 800
                                        ? screenWidth * 0.45
                                        : screenWidth * 0.40,
                                left:
                                    screenWidth < 800
                                        ? screenWidth * 0.15
                                        : screenWidth * 0.15,
                                child: TapPulseEffect(size: screenWidth * 0.05),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(top: 20),
                          child: ClapLabelBubble(screenWidth: screenWidth),
                        ),
                      ],
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
                          icon: const Icon(Icons.copy, color: Colors.white70),
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
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🖐️ Welcome to ClapOnSol!",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.05
                              : screenWidth * 0.023,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Dive into the wild world of Web3 fun on Solana! 🔥",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.04
                              : screenWidth * 0.021,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Here, clapping isn’t just for applause — it’s a way of life. 🖐️🩷",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.04
                              : screenWidth * 0.02,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "👋 Tap the magic hand, slap the objects, and start stacking \$CLAP — our meme-powered token built for the true Solana degens.",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.04
                              : screenWidth * 0.02,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "🚀 How it works:",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.04
                              : screenWidth * 0.021,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),

                  SizedBox(
                    height: screenWidth * 0.25,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                            children: [
                              TextSpan(
                                text: "👉 Tap the hand\n",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth < 800
                                          ? screenWidth * 0.04
                                          : screenWidth * 0.02,
                                ),
                              ),
                              TextSpan(
                                text: "👉 Clap the 👋 'objects' 😏 \n",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth < 800
                                          ? screenWidth * 0.04
                                          : screenWidth * 0.02,
                                ),
                              ),
                              TextSpan(
                                text: "👉 Earn \$CLAP tokens\n",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth < 800
                                          ? screenWidth * 0.04
                                          : screenWidth * 0.02,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              TextSpan(
                                text: "    (in progress)\n",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth < 800
                                          ? screenWidth * 0.04
                                          : screenWidth * 0.02,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: "👉 Repeat and have fun 😉",
                                style: TextStyle(
                                  fontSize:
                                      screenWidth < 800
                                          ? screenWidth * 0.04
                                          : screenWidth * 0.02,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.08,
                              ),

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
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha:0.5),
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
                                      child: RepaintBoundary(
                                        child: VideoPlayer(_controllerBody),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: screenWidth * 0.01,
                              top: screenWidth * 0.07,
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
                              top:
                                  screenWidth < 800
                                      ? screenWidth * 0.2
                                      : screenWidth * 0.151,
                              left:
                                  screenWidth < 800
                                      ? screenWidth * 0.09
                                      : screenWidth * 0.06,
                              child: TapPulseEffect(size: screenWidth * 0.05),
                            ),
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
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.04
                              : screenWidth * 0.02,
                    ),
                  ),
                  SizedBox(height: 6),

                  Text(
                    "Whether you're here for laughs or to farm some digital chaos 💥, this is the place to let your inner degen high-five the blockchain ✋🧠",

                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.04
                              : screenWidth * 0.02,
                    ),
                  ),
                  SizedBox(height: 6),

                  Text(
                    "Let’s clap it out! 👋",
                    style: TextStyle(
                      fontSize:
                          screenWidth < 800
                              ? screenWidth * 0.045
                              : screenWidth * 0.022,
                      decoration: TextDecoration.overline,
                    ),
                  ),

                  SizedBox(height: 26),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth < 800
                          ? screenWidth / 1.3 :screenWidth / 2,
                      height:  screenWidth < 800
                          ?screenWidth / 1.3 + 200: screenWidth / 1.9 + 200,
                      child: BubbleGamePage(screenWidth: screenWidth.toInt()),
                    ),
                  ),

                  SizedBox(height: 26),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha:0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.5),
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
      ),
    );
  }
}

Widget _buildSocialButton(String label, String url, Color color, String icon) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {
        openUrl(url);      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF69B4).withValues(alpha:0.8), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFFF69B4).withValues(alpha:0.4),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha:0.3), width: 1),
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
            color: Colors.orange..withValues(alpha:0.4),
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
  const ScrollDownArrow({super.key});

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
    Colors.pinkAccent.withValues(alpha:0.5),
    Colors.blueAccent.withValues(alpha:0.5),
    Colors.yellowAccent.withValues(alpha:0.5),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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

import 'dart:async';
import 'dart:html' as html;
import 'dart:math';
import 'dart:ui';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

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
  final ScrollController _scrollControllerSC = ScrollController();

  bool _isPlaying = false;

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
    _controller = VideoPlayerController.asset('assets/slap.mp4');
    _controllerBody = VideoPlayerController.asset('assets/slap1.mp4');
    _controller3 = VideoPlayerController.asset('assets/slap2.mp4');
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      setState(() {});
    });
    _controllerBody.initialize().then((_) {
      _controllerBody.setLooping(true);
      setState(() {});
    });

    _controller3.initialize().then((_) {
      _controller3.setLooping(true);
      setState(() {});
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
    _arcAnimationBody = Tween<double>(begin: 13, end: 2).animate(
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
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller.seekTo(Duration.zero);
      _controller.play();
      setState(() => _isPlaying = true);

      Future.delayed(Duration(seconds: 2), () {
        if (_controller.value.isPlaying) {
          _controller.pause();
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  void _togglePlayPauseBody() {
    _controllerBody.setPlaybackSpeed(1);
    if (_controllerBody.value.isPlaying) {
      _controllerBody.pause();
      setState(() => _isPlaying = false);
    } else {
      _controllerBody.seekTo(Duration.zero);
      _controllerBody.play();
      setState(() => _isPlaying = true);

      Future.delayed(Duration(seconds: 1), () {
        if (_controllerBody.value.isPlaying) {
          _controllerBody.pause();
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  void _togglePlayPause3() {
    _controller3.setPlaybackSpeed(1.5);
    if (_controller3.value.isPlaying) {
      _controller3.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller3.seekTo(Duration.zero);
      _controller3.play();
      setState(() => _isPlaying = true);

      Future.delayed(Duration(seconds: 2), () {
        if (_controller3.value.isPlaying) {
          _controller3.pause();
          setState(() => _isPlaying = false);
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
            controller: _scrollControllerSC,
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
                                scrollController: _scrollControllerSC,
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
                                            child: VideoPlayer(_controller3),
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
                                            child: VideoPlayer(_controller),
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
                                ],
                              ),
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
                                        : screenWidth / 30,
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
                        "🔥 Welcome to ClapOnSol!",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Dive into the wild world of Web3 fun on Solana! 🌊",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Here, clapping isn’t just for applause — it’s a way of life. 😄",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "👋 Tap the magic hand, slap the objects, and start stacking \$CLAP — our meme-powered token built for the true Solana degens.",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "🚀 How it works:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      // SizedBox(height: 150,
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         "👉 Tap the hand\n👉 Clap the objects\n👉 Earn \$CLAP tokens\n👉 Repeat and have fun 🎉",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           height: 1.5,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //       Stack(
                      //         children: [
                      //           Container(
                      //             padding: EdgeInsets.only(left: screenWidth * 0.10),
                      //
                      //             child: ClipRRect(
                      //               borderRadius: BorderRadius.circular(20),
                      //               child: AnimatedContainer(
                      //                 duration: Duration(milliseconds: 500),
                      //                 width:
                      //                     screenWidth < 800
                      //                         ? screenWidth * 0.25
                      //                         : screenWidth * 0.20,
                      //                 transform: Matrix4.skewX(ballSkewBody)
                      //                   ..scale(ballScaleBody),
                      //                 decoration: BoxDecoration(
                      //                   // shape: BoxShape.circle,
                      //                   color: Colors.white,
                      //                   boxShadow: [
                      //                     BoxShadow(
                      //                       color: Colors.black.withOpacity(0.5),
                      //                       blurRadius: 10,
                      //                       spreadRadius: 4,
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 child: AnimatedSwitcher(
                      //                   duration: Duration(milliseconds: 100),
                      //                   child: AspectRatio(
                      //                     aspectRatio:
                      //                         _controllerBody.value.aspectRatio,
                      //                     child: VideoPlayer(_controllerBody),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: EdgeInsets.only(left: screenWidth * 0.01,top: screenWidth * 0.07),
                      //             height:  screenWidth < 800
                      //                 ? screenWidth * 0.25
                      //                 : screenWidth * 0.20,
                      //
                      //             child: AnimatedBuilder(
                      //               animation: _arcAnimationBody,
                      //               builder: (context, child) {
                      //                 final angle =
                      //                 lerpDouble(
                      //                   3 * pi / 190.0,
                      //                   pi / -360,
                      //                   _arcAnimationBody.value,
                      //                 )!;
                      //                 return GestureDetector(
                      //                   onTap: _triggerClapBody,
                      //                   child: Transform.rotate(
                      //                     angle: angle + pi / 700,
                      //                     child: SizedBox(
                      //                       width:
                      //                       screenWidth < 800
                      //                           ? screenWidth * 0.25
                      //                           : screenWidth * 0.30,
                      //                       child: Image.asset('assets/hand2.png'),
                      //                     ),
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //
                      //         ],
                      //       ),
                      //
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 24),
                      Text(
                        "Are you ready to clap your way to the top? 💥",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),

                      Text(
                        'Whether you\'re here to have fun or farm some digital chaos, this is the place to let your inner degen high-five the blockchain',
                      ),
                      Text(' Let’s clap it out!'),
                      SizedBox(height: 26),
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
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
            colors: [Colors.pinkAccent.withOpacity(0.8), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pinkAccent.withOpacity(0.4),
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
      child: HtmlElementView(viewType: viewId),
    );
  }
}

class ClapLabelBubble extends StatefulWidget {
  final double screenWidth;

  const ClapLabelBubble({super.key, required this.screenWidth});

  @override
  State<ClapLabelBubble> createState() => _ClapLabelBubbleState();
}

class _ClapLabelBubbleState extends State<ClapLabelBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: -6,
      end: 6,
    ).chain(CurveTween(curve: Curves.elasticIn)).animate(_controller);

    _startShakingLoop();
  }

  void _startShakingLoop() async {
    while (mounted) {
      await Future.delayed(
        Duration(seconds: 3 + _random.nextInt(5)),
      ); // задержка 4-8 сек
      if (!mounted) break;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        double offsetX = sin(_shakeAnimation.value) * 4;
        return Transform.translate(offset: Offset(offsetX, 0), child: child);
      },
      child: Container(
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
              fontSize: widget.screenWidth / 40,
              fontWeight: FontWeight.w900,
              color: Colors.pinkAccent,
              letterSpacing: 1,
            ),
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
  final ScrollController scrollController;

  const ScrollDownArrow({super.key, required this.scrollController});

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

  void _scrollDown() {
    widget.scrollController.animateTo(
      widget.scrollController.offset + 300, // сколько прокрутить (в пикселях)
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _scrollDown,
      child: SlideTransition(
        position: _animation,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}

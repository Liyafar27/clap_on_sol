import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const ClapOnSolApp());
}

class ClapOnSolApp extends StatelessWidget {
  const ClapOnSolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClapOnSolPage(),
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

  late Animation<double> _arcAnimation;
  late Animation<double> _arcAnimation1;

  late VideoPlayerController _controller;
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  late VideoPlayerController _controller3;

  bool _isPlaying = false;

  bool isAnimating = false;
  double ballScale = 1;
  double ballSkew = 0;
  double ballScale1 = 1;
  double ballSkew1 = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/slap.mp4');
    _controller1 = VideoPlayerController.asset('assets/slap1.mp4');
    _controller2 = VideoPlayerController.asset('assets/slap2.mp4');
    _controller3 = VideoPlayerController.asset('assets/slap4.mp4');
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      setState(() {});
    });
    _controller1.initialize().then((_) {
      _controller1.setLooping(true);
      setState(() {});
    });
    _controller2.initialize().then((_) {
      _controller2.setLooping(true);
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

    _arcAnimation = Tween<double>(begin: 13, end: -2).animate(
      CurvedAnimation(parent: _clapController, curve: Curves.easeOutBack),
    );
    _arcAnimation1 = Tween<double>(begin: -13, end: 2).animate(
      CurvedAnimation(parent: _clapController2, curve: Curves.easeOutBack),
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
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller.seekTo(Duration.zero);
      _controller.play();
      setState(() => _isPlaying = true);
    }
  }

  void _togglePlayPause1() {
    if (_controller1.value.isPlaying) {
      _controller1.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller1.seekTo(Duration.zero);
      _controller1.play();
      setState(() => _isPlaying = true);
    }
  }

  void _togglePlayPause2() {
    if (_controller2.value.isPlaying) {
      _controller2.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller2.seekTo(Duration.zero);
      _controller2.play();
      setState(() => _isPlaying = true);
    }
  }

  void _togglePlayPause3() {
    if (_controller3.value.isPlaying) {
      _controller3.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller3.seekTo(Duration.zero);
      _controller3.play();
      setState(() => _isPlaying = true);
    }
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
    // _togglePlayPause();
    _togglePlayPause3();
    // _togglePlayPause2();
    // _togglePlayPause3();
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

    _clapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                print(screenWidth.toString());
                return Container(
                  height:
                      screenWidth < 800
                          ? screenWidth * 0.6 + 50
                          : screenWidth * 0.5 + 50,
                  color: Color(0xFFFF69B4),
                  child: Column(
                    children: [
                      // SizedBox(height: 50,),
                      Expanded(
                        child: Stack(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 16)
,
                            Container(
                              margin: EdgeInsets.only(
                                top: 50,
                              ),
                              width: screenWidth / 0.25,
                              alignment: Alignment.topCenter,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.translate(
                                    offset: const Offset(2, 4), // Смещение тени
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
                                    // right: screenWidth * 0.001,
                                    child: AnimatedBuilder(
                                      animation: _arcAnimation1,
                                      builder: (context, child) {
                                        final angle =
                                            lerpDouble(
                                              3 * pi / 190.0,
                                              pi / -360,
                                              _arcAnimation1.value,
                                            )!;
                                        return Positioned(
                                          right: screenWidth * 0.0001,

                                          top:
                                              screenWidth < 800
                                                  ? screenWidth * 0.15
                                                  : screenWidth * 0.10,
                                          child: GestureDetector(
                                            onTap: _triggerClap1,
                                            child: Transform.rotate(
                                              angle: angle + pi / 700,
                                              child: SizedBox(
                                                width:
                                                    screenWidth < 800
                                                        ? screenWidth * 0.25
                                                        : screenWidth * 0.25,
                                                child: Image.asset(
                                                  'assets/hand3.png',
                                                ),
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
                            const Positioned(
                              top: 30,
                              child: ClapLabelBubble()
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
                                        return Positioned(
                                          top:
                                              screenWidth < 800
                                                  ? screenWidth * 0.35
                                                  : screenWidth * 0.30,
                                          child: GestureDetector(
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                );
              },
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🔥 Welcome to ClapOnSol!",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "This is a fun Web3-style concept where you can clap objects on Solana 😄.",
                    style: TextStyle(fontSize: 18),
                  ),

                  Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00FF9D).withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const DexScreenerChart(),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
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
                        'https://twitter.com/wapcoin',
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
      ),
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
            colors: [
              Colors.pinkAccent.withOpacity(0.8),
              Colors.pink.withOpacity(0.6),
            ],
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
              style: const TextStyle(fontSize: 26, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  //     .animate(
  //   onPlay: (controller) => controller.repeat(),
  // )
  //     .fadeIn()
  //     .scale(delay: 200.ms)
  //     .shimmer(duration: 2000.ms)
  //     .then()
  //     .shimmer(duration: 2000.ms);
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

class ClapLabelBubble extends StatelessWidget {
  const ClapLabelBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber[400], // желтый фон
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child:  Text(
        'Tap the hands',
        style: GoogleFonts.fredoka(
    textStyle: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: Colors.pinkAccent,
    letterSpacing: 1,
    ),
        ) ),
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
              style: GoogleFonts.luckiestGuy(
                fontSize: 22,
                color: Colors.pink,
              ),
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
    final paint = Paint()
      ..color = const Color(0xFFFFCC5C)
      ..style = PaintingStyle.fill;

    final path = Path();

    final curveHeight = 30.0;
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(size.width / 2, 0 - curveHeight, size.width, size.height * 0.5);
    path.quadraticBezierTo(size.width / 2, size.height + curveHeight, 0, size.height * 0.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

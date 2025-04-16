
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
class Bubble {
  final int id;
  final Offset position;
  final String image;

  Bubble({required this.id, required this.position, required this.image});
}
class BubbleGamePage extends StatefulWidget {
  final int screenWidth;

  BubbleGamePage({
    required this.screenWidth,
    super.key,
  });

  @override
  State<BubbleGamePage> createState() => _BubbleGamePageState();
}
class _BubbleGamePageState extends State<BubbleGamePage> with TickerProviderStateMixin {
  final List<String> _imagePaths = List.generate(
    15,
        (index) => 'assets/ball_${index + 1}.png',
  );
  final List<Bubble> _bubbles = [];

  final List<Offset> _positions = [];
  final List<int> _activeIndexes = [];
  Offset? _mousePosition;
  late AnimationController _handController;
  late Animation<double> _handRotation;
  final double squareSize = 600;
  int _score = 0; // Счёт
  bool _isGameRunning = false;
  late Timer _gameTimer;
  late Timer _bubbleTimer; // Таймер для добавления пузырей
  int _timeRemaining = 30; // Время игры
  late Random random;
  bool _isGameOver = false; // Флаг окончания игры


  @override
  void initState() {
    super.initState();

    _handController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    // _handRotation = Tween<double>(begin: -1.5, end: 0).animate(
    //   CurvedAnimation(parent: _handController, curve: Curves.easeOut),
    // );
    _handRotation = Tween<double>(begin: -1, end: 0).animate(
        CurvedAnimation(parent: _handController, curve: Curves.easeInOut));
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _isGameRunning = true;
      _timeRemaining = 30;
      _isGameOver = false; // Игра не завершена
      _positions.clear(); // Очистить предыдущие пузырьки
      _activeIndexes.clear(); // Очистить индексы активных пузырьков
    });

    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _gameTimer.cancel();
          _bubbleTimer.cancel(); // Остановить таймер добавления пузырей
          _isGameOver = true; // Игра завершена
          _isGameRunning = false;
          _showEndGameDialog();
        }
      });
    });

    _bubbleTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_isGameRunning) {
        _generateBubbles( 15); // Добавляем новые пузыри каждые 5 секунд
      }
    });

    _generateBubbles(15); // Добавляем начальные пузыри
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _timeRemaining = 30;
      _isGameRunning = true;
      _isGameOver = false;
      _positions.clear();
      _activeIndexes.clear();
    });

    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _gameTimer.cancel();
          _bubbleTimer.cancel();
          _isGameOver = true;
          _isGameRunning = false;
          _showEndGameDialog();
        }
      });
    });

    _bubbleTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_isGameRunning) {
        _generateBubbles(15);
      }
    });

    _generateBubbles(15); // Начать с пузырей
  }
  void _generateBubbles(int quantity) {
    final random = Random();
    final double bubbleRadius = widget.screenWidth / 80;
    final double fieldWidth = widget.screenWidth / 2;
    final double fieldHeight = fieldWidth;

    List<Bubble> newBubbles = List.generate(quantity, (_) {
      final position = Offset(
        random.nextDouble() * (fieldWidth - 2 * bubbleRadius) + bubbleRadius,
        random.nextDouble() * (fieldHeight - 2 * bubbleRadius) + bubbleRadius,
      );
      final imageIndex = random.nextInt(_imagePaths.length); // -1 если hand в конце
      final id = DateTime.now().microsecondsSinceEpoch + random.nextInt(10000);
      return Bubble(id: id, position: position, image: _imagePaths[imageIndex]);
    });

    setState(() {
      _bubbles.addAll(newBubbles);
      if (_bubbles.length > 50) {
        _bubbles.removeRange(0, _bubbles.length - 50);
      }
    });
  }

  // void _generateBubbles(int quantity) {
  //   final random = Random();
  //   final double bubbleRadius = widget.screenWidth / 32;
  //   final double fieldWidth = widget.screenWidth / 2.2; // ширина игрового поля
  //   final double fieldHeight = fieldWidth; // если поле квадратное
  //
  //   for (int i = 0; i < quantity; i++) {
  //     _positions.add(Offset(
  //       random.nextDouble() * (fieldWidth - 2 * bubbleRadius) + bubbleRadius,
  //       random.nextDouble() * (fieldHeight - 2 * bubbleRadius) + bubbleRadius,
  //     ));
  //     _activeIndexes.add(i);
  //   }
  //
  //   if (_positions.length > 50) {
  //     _positions.removeRange(0, _positions.length - 50);
  //     _activeIndexes.removeRange(0, _activeIndexes.length - 50);
  //   }
  //
  //   final List<Offset> shuffledPositions = List.from(_positions)
  //     ..shuffle(random);
  //   setState(() {
  //     _positions.clear();
  //     _positions.addAll(shuffledPositions);
  //   });
  // }

  // void _removeBubble(int index) {
  //   if (_isGameOver) return;
  //   setState(() {
  //     _activeIndexes.remove(index);
  //     _score++;
  //   });
  // }
  void _removeBubble(int id) {
    if (_isGameOver) return;
    setState(() {
      _bubbles.removeWhere((b) => b.id == id);
      _score++;
    });
  }
  void _showEndGameDialog() {
    setState(() {
      _isGameOver = true;
      _isGameRunning = false;
    });
  }


  @override
  void dispose() {
    _gameTimer.cancel();
    _bubbleTimer.cancel();
    _handController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Time: $_timeRemaining',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 6),
              Text(
                'Score: $_score',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: _isGameRunning ? null : _startGame,
                  child: Text(_isGameRunning ? 'Game Running' : 'Start Game',  style: TextStyle(color: Color(0xFFFF69B4), fontWeight:FontWeight.w900),),

                ),
              ),
              SizedBox(height: 6),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.none, // 👈 скрываем курсор в игровом поле

                      child:  Listener(
                      onPointerHover: (event) {
                    setState(() {
                    _mousePosition = event.localPosition;
                    });
                    },
                        child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          width: widget.screenWidth / 1.5,
                          height: widget.screenWidth / 1.5,
                          color: Color(0xFFFF69B4),

                            child: GestureDetector(
                              onTapDown: (details) {
                                setState(() {
                                  _mousePosition = details.localPosition;
                                });
                                // Перезапуск анимации
                                _handController.reset(); // Сбрасываем анимацию
                                if (!_handController.isAnimating) {  // Проверка, чтобы избежать повторного запуска
                                  _handController.forward().then((_) => _handController.reverse());
                                }
                              },
                              child: Stack(
                                children: [
                                  ..._bubbles.map((bubble) {
                                    return Positioned(
                                      left: bubble.position.dx,
                                      top: bubble.position.dy,
                                      child: BubbleWidget(
                                        screenWidth: widget.screenWidth,
                                        imagePath: bubble.image,
                                        onPopped: () => _removeBubble(bubble.id),
                                        position: bubble.position,
                                      ),
                                    );
                                  }),
                                  // ..._activeIndexes.map((i) {
                                  //   return Positioned(
                                  //     left: _positions[i].dx,
                                  //     top: _positions[i].dy,
                                  //     child: BubbleWidget(
                                  //       screenWidth: widget.screenWidth,
                                  //       imagePath: _imagePaths[i],
                                  //       onPopped: () => _removeBubble(i),
                                  //       position: _positions[i],
                                  //     ),
                                  //   );
                                  // }),
                                  if (_mousePosition != null)
                                    Positioned(
                                      left: _mousePosition!.dx,
                                      top: _mousePosition!.dy,
                                      child: IgnorePointer(
                                        child: AnimatedBuilder(
                                          animation: _handRotation,
                                          builder: (_, child) {
                                            return Transform.rotate(
                                              angle: _handRotation.value,
                                              child: Transform.translate(
                                                offset: Offset(
                                                    widget.screenWidth / -50,
                                                    widget.screenWidth / -30),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/hand2.png',
                                            width: widget.screenWidth / 10,
                                            height: widget.screenWidth / 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!_isGameRunning)
                    Container(
                      width: widget.screenWidth / 1.5,
                      height: widget.screenWidth / 1.5,
                      color: Colors.grey.shade900.withOpacity(0.9),
                    ),
                  if (_isGameOver)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Game Over!',
                                style: TextStyle(color:  Color(0xFFFF69B4), fontSize: 32),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'You clapped $_score!',
                                style: TextStyle(color: Colors.white, fontSize: 24),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _restartGame,
                                child: Text('Restart', style: TextStyle(color: Color(0xFFFF69B4), fontWeight:FontWeight.w900),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleWidget extends StatefulWidget {
  final int  screenWidth;
  final String imagePath;
  final Offset position;
  final VoidCallback onPopped;

  const BubbleWidget({
    required this.screenWidth,
    required this.imagePath,
    required this.position,
    required this.onPopped,
    super.key,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> with SingleTickerProviderStateMixin {
  bool _isPopped = false;

  late final AnimationController _popController;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    // Создаем уникальный контроллер анимации для каждого пузыря
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Анимация для подергивания пузыря
    _shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(0.05, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.05, 0), end: const Offset(-0.05, 0)), weight: 1),
      TweenSequenceItem(tween: Tween(begin: const Offset(-0.05, 0), end: Offset.zero), weight: 1),
      TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 3),
    ]).animate(CurvedAnimation(parent: _popController, curve: Curves.easeOut));

    // Анимация для масштабирования пузыря
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 3),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.0), weight: 2),
    ]).animate(
      CurvedAnimation(parent: _popController, curve: Curves.easeOutCubic),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isPopped = true);
        widget.onPopped(); // Уведомляем родительский виджет о лопнувшем пузыре
      }
    });
  }

  // Метод для проверки, попал ли клик в область пузыря
  bool _isClickedInsideBubble(Offset clickPosition) {
    final bubbleRect = Rect.fromLTWH(
      widget.position.dx - 70, // учтите смещение картинки
      widget.position.dy - 70,
      140, // ширина пузыря
      140, // высота пузыря
    );

    return bubbleRect.contains(clickPosition); // Проверка попадания в пузырь
  }

  void _onTap(Offset clickPosition) {
    if (_isPopped || _popController.isAnimating) return; // Если пузырь уже лопнул, игнорируем

    if (_isClickedInsideBubble(clickPosition)) {
      _popController.forward(from: 0.0);  // Лопаем пузырь
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPopped) return const SizedBox.shrink(); // Если пузырь лопнул, не показываем его

    return GestureDetector(
      onTap: () {
        if (!_isPopped) {
          _onTap(widget.position);  // Проверка клика на конкретный пузырь
        }
      },
      child: SlideTransition(
        position: _shakeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ClipOval(
            child: Image.asset(
              widget.imagePath,
              width:
              widget.screenWidth/8,
              height:  widget.screenWidth/8,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _popController.dispose();  // Освобождаем ресурсы
    super.dispose();
  }
}


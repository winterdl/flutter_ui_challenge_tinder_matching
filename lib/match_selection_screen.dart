import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prototype/match_card.dart';
import 'package:prototype/profiles.dart';

class MatchSelectionScreen extends StatefulWidget {
  @override
  _MatchSelectionScreenState createState() => new _MatchSelectionScreenState();
}

class _MatchSelectionScreenState extends State<MatchSelectionScreen> with TickerProviderStateMixin {
  int _activeCardIndex = 0;
  CardDragController _cardController;

  @override
  void initState() {
    super.initState();
    _cardController = new CardDragController(
        vsync: this,
        onLiked: () {
          setState(() => ++_activeCardIndex);
        },
        onNoped: () {
          setState(() => ++_activeCardIndex);
        },
        onSuperLiked: () {
          setState(() => ++_activeCardIndex);
        })
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Widget _buildSmallButton(IconData icon, Color color, VoidCallback onPressed) {
    return _buildButton(50.0, icon, color, onPressed);
  }

  Widget _buildLargeButton(IconData icon, Color color, VoidCallback onPressed) {
    return _buildButton(60.0, icon, color, onPressed);
  }

  Widget _buildButton(double size, IconData icon, Color color, VoidCallback onPressed) {
    return new Center(
      child: new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: const Color(0x11000000),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: new RawMaterialButton(
          shape: new CircleBorder(),
          elevation: 0.0,
          child: new Icon(
            icon,
            color: color,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(
            Icons.person,
            color: Colors.grey,
            size: 40.0,
          ),
          onPressed: () {
            // TODO:
          },
        ),
        title: new FlutterLogo(
          size: 30.0,
          colors: Colors.red,
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.chat_bubble,
              color: Colors.grey,
              size: 40.0,
            ),
            onPressed: () {
              // TODO:
            },
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new CardStack(
                cardIndex: _activeCardIndex,
                controller: _cardController,
              ),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: _buildSmallButton(Icons.refresh, Colors.orange, () {}),
                ),
                new Expanded(
                  child: _buildLargeButton(Icons.clear, Colors.red, () {
                    _cardController.nope(context.findRenderObject() as RenderBox);
                  }),
                ),
                new Expanded(
                  child: _buildSmallButton(Icons.star, Colors.blue, () {
                    _cardController.superLike(context.findRenderObject() as RenderBox);
                  }),
                ),
                new Expanded(
                  child: _buildLargeButton(Icons.favorite, Colors.green, () {
                    _cardController.like(context.findRenderObject() as RenderBox);
                  }),
                ),
                new Expanded(
                  child: _buildSmallButton(Icons.lock, Colors.purple, () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardStack extends StatefulWidget {
  final int cardIndex;
  final CardDragController controller;

  CardStack({
    this.cardIndex = 0,
    this.controller,
  });

  @override
  _CardStackState createState() => new _CardStackState();
}

class _CardStackState extends State<CardStack> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void _setControllerSizingInfo() async {
    if (widget.controller.cardSize == null || widget.controller.draggableExtent == null) {
      final screenSize = MediaQuery.of(context).size;
      print('Screen size: $screenSize');
      widget.controller.cardSize = context.size;
      widget.controller.draggableExtent = new Rect.fromLTWH(
        0.0,
        0.0,
        screenSize.width,
        screenSize.height,
      );
    }
  }

  void _onPanStart(DragStartDetails details) {
    widget.controller.onDragStart(
      (context.findRenderObject() as RenderBox),
      details.globalPosition,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    widget.controller.onDragUpdate(details.globalPosition);

    print('Percent superlike: ${widget.controller.percentSuperLike}');
  }

  void _onPanEnd(DragEndDetails details) {
    widget.controller.onDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    _setControllerSizingInfo();

    Matrix4 cardTransform = new Matrix4.translationValues(
      widget.controller.positionOffset.dx,
      widget.controller.positionOffset.dy,
      0.0,
    );
    cardTransform.rotateZ(widget.controller.rotation);

    final maxDecision = max(
        widget.controller.percentLike,
        max(
          widget.controller.percentNope,
          widget.controller.percentSuperLike,
        ));

    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Transform(
          transform: new Matrix4.identity()
            ..scale(
              0.9 + (0.1 * maxDecision),
              0.9 + (0.1 * maxDecision),
            ),
          origin: widget.controller.dragOrigin,
          child: new MatchCard(
            profile: demoMatches[(widget.cardIndex + 1) % demoMatches.length],
          ),
        ),
        new GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: new Transform(
            transform: cardTransform,
            origin: widget.controller.dragOrigin,
            child: new MatchCard(
              profile: demoMatches[widget.cardIndex % demoMatches.length],
            ),
          ),
        ),
      ],
    );
  }
}

class CardDragController extends ChangeNotifier {
  final VoidCallback onLiked;
  final VoidCallback onNoped;
  final VoidCallback onSuperLiked;
  final AnimationController _springBackController;
  final AnimationController _slideOutController;

  Rect _draggableExtent;
  Size _cardSize;
  Offset _origin = const Offset(0.0, 0.0);
  Offset _positionOffset = const Offset(0.0, 0.0);

  Offset _startDragPoint;

  Offset _startSpringOffset;

  Offset _startSlideOffset;
  Offset _endSlideOffset;
  VoidCallback _onSlideEndCallback;

  CardDragController({
    this.onLiked,
    this.onNoped,
    this.onSuperLiked,
    TickerProvider vsync,
  })  : _springBackController = new AnimationController(vsync: vsync),
        _slideOutController = new AnimationController(vsync: vsync) {
    _springBackController
      ..duration = const Duration(milliseconds: 800)
      ..addListener(() {
        _positionOffset = Offset.lerp(
          _startSpringOffset,
          const Offset(0.0, 0.0),
          Curves.elasticOut.transform(_springBackController.value),
        );

        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _startSpringOffset = null;
          notifyListeners();
        }
      });

    _slideOutController
      ..duration = const Duration(milliseconds: 500)
      ..addListener(() {
        _positionOffset = Offset.lerp(
          _startSlideOffset,
          _endSlideOffset,
          _slideOutController.value,
        );

        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          // TODO: clean up
          _positionOffset = const Offset(0.0, 0.0);

          if (null != _onSlideEndCallback) {
            _onSlideEndCallback();
          }

          notifyListeners();
        }
      });
  }

  // The point on the card that is being dragged, and therefore
  // the center of rotation and also the basis of the position offset.
  // Reported in pixels/points.
  Offset get dragOrigin => _origin;

  // The current drag offset as a difference from the drag origin.
  // Reported in pixels/points.
  Offset get positionOffset => _positionOffset;

  double get rotation {
    if (_cardSize == null || _origin == null || _draggableExtent == null) {
      return 0.0;
    }

    final rotationCornerMultiplier = _origin.dy >= _cardSize.height / 2 ? -1 : 1;
    return (pi / 8) * (_positionOffset.dx / _draggableExtent.width) * rotationCornerMultiplier;
  }

  double get percentLike {
    if (_draggableExtent == null) {
      return 0.0;
    }

    return (_positionOffset.dx / _draggableExtent.width).clamp(0.0, 1.0);
  }

  double get percentNope {
    if (_draggableExtent == null) {
      return 0.0;
    }

    return (-_positionOffset.dx / _draggableExtent.width).clamp(0.0, 1.0);
  }

  double get percentSuperLike {
    if (_draggableExtent == null) {
      return 0.0;
    }

    return (-_positionOffset.dy / _draggableExtent.height).clamp(0.0, 1.0);
  }

  Size get cardSize => _cardSize;

  set cardSize(Size cardSize) {
    _cardSize = cardSize;
    notifyListeners();
  }

  Rect get draggableExtent => _draggableExtent;

  set draggableExtent(Rect extent) {
    _draggableExtent = extent;
    notifyListeners();
  }

  void like(RenderBox cardRenderBox) {
    final pushFromTop = new Random().nextBool();
    _cardSize = cardRenderBox.size;
    _origin = cardRenderBox.size.center(const Offset(0.0, 0.0)) -
        new Offset(0.0, pushFromTop ? -10.0 : 10.0);
    _startSlideOffset = const Offset(0.0, 0.0);
    _endSlideOffset = new Offset(_cardSize.width, 0.0);
    _slideOutController.forward(from: 0.0);

    _onSlideEndCallback = onLiked;
  }

  void nope(RenderBox cardRenderBox) {
    final pushFromTop = new Random().nextBool();
    _cardSize = cardRenderBox.size;
    _origin = cardRenderBox.size.center(const Offset(0.0, 0.0)) -
        new Offset(0.0, pushFromTop ? -10.0 : 10.0);
    _startSlideOffset = const Offset(0.0, 0.0);
    _endSlideOffset = new Offset(-_cardSize.width, 0.0);
    _slideOutController.forward(from: 0.0);

    _onSlideEndCallback = onNoped;
  }

  void superLike(RenderBox cardRenderBox) {
    _cardSize = cardRenderBox.size;
    _origin = cardRenderBox.size.center(const Offset(0.0, 0.0));
    _startSlideOffset = const Offset(0.0, 0.0);
    _endSlideOffset = new Offset(0.0, -_cardSize.height);
    _slideOutController.forward(from: 0.0);

    _onSlideEndCallback = onSuperLiked;
  }

  void onDragStart(RenderBox cardRenderBox, Offset dragPositionWithinExtent) {
    _cardSize = cardRenderBox.size;
    _startDragPoint = dragPositionWithinExtent;
    _origin = cardRenderBox.globalToLocal(_startDragPoint);
  }

  void onDragUpdate(Offset dragPositionWithinExtent) {
    _positionOffset = dragPositionWithinExtent - _startDragPoint;

    notifyListeners();
  }

  void onDragEnd() {
    final slideDirection = _positionOffset / _positionOffset.distance;

    if (percentLike > 0.5) {
      _startSlideOffset = _positionOffset;
      _endSlideOffset = _startSlideOffset + (slideDirection * _draggableExtent.width);
      _slideOutController.forward(from: 0.0);

      _onSlideEndCallback = onLiked;
    } else if (percentNope > 0.5) {
      _startSlideOffset = _positionOffset;
      _endSlideOffset = _startSlideOffset + (slideDirection * _draggableExtent.width);
      _slideOutController.forward(from: 0.0);

      _onSlideEndCallback = onNoped;
    } else if (percentSuperLike > 0.4) {
      _startSlideOffset = _positionOffset;
      _endSlideOffset = _startSlideOffset + (slideDirection * _draggableExtent.height);
      _slideOutController.forward(from: 0.0);

      _onSlideEndCallback = onSuperLiked;
    } else {
      _startSpringOffset = _positionOffset;
      _springBackController.forward(from: 0.0);
    }

    _startDragPoint = null;

    notifyListeners();
  }
}

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prototype/match_card.dart';
import 'package:prototype/profiles.dart';

class MatchSelectionScreen extends StatefulWidget {
  @override
  _MatchSelectionScreenState createState() => new _MatchSelectionScreenState();
}

class _MatchSelectionScreenState extends State<MatchSelectionScreen> {
  Widget _buildSmallButton(IconData icon, Color color) {
    return _buildButton(50.0, icon, color);
  }

  Widget _buildLargeButton(IconData icon, Color color) {
    return _buildButton(60.0, icon, color);
  }

  Widget _buildButton(double size, IconData icon, Color color) {
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
          onPressed: () {
            // TODO:
          },
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
              child: new CardStack(),
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: _buildSmallButton(Icons.refresh, Colors.orange),
                ),
                new Expanded(
                  child: _buildLargeButton(Icons.clear, Colors.red),
                ),
                new Expanded(
                  child: _buildSmallButton(Icons.star, Colors.blue),
                ),
                new Expanded(
                  child: _buildLargeButton(Icons.favorite, Colors.green),
                ),
                new Expanded(
                  child: _buildSmallButton(Icons.lock, Colors.purple),
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
  @override
  _CardStackState createState() => new _CardStackState();
}

class _CardStackState extends State<CardStack> with TickerProviderStateMixin {
  Offset _startDragPoint;
  Offset _positionOffset = const Offset(0.0, 0.0);
  Offset _cardMotionOrigin;
  double _rotation = 0.0;
  Offset _startSpringOffset;
  double _startSpringRotation;
  AnimationController _springBackController;

  @override
  void initState() {
    super.initState();

    _springBackController = new AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _positionOffset = Offset.lerp(
            _startSpringOffset,
            const Offset(0.0, 0.0),
            Curves.elasticOut.transform(_springBackController.value),
          );
          _rotation = lerpDouble(
            _startSpringRotation,
            0.0,
            const Interval(0.0, 0.3).transform(_springBackController.value),
          );
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _startSpringOffset = null;
        }
      });
  }

  void _onPanStart(DragStartDetails details) {
    _startDragPoint = details.globalPosition;
    _cardMotionOrigin = (context.findRenderObject() as RenderBox).globalToLocal(_startDragPoint);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _positionOffset = details.globalPosition - _startDragPoint;

      final rotationCornerMultiplier = _cardMotionOrigin.dy >= context.size.height / 2 ? -1 : 1;
      _rotation = (pi / 8) *
          (_positionOffset.dx / MediaQuery.of(context).size.width) *
          rotationCornerMultiplier;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _startSpringOffset = _positionOffset;
      _startSpringRotation = _rotation;
      _springBackController.forward(from: 0.0);

      _startDragPoint = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Matrix4 cardTransform =
        new Matrix4.translationValues(_positionOffset.dx, _positionOffset.dy, 0.0);
    cardTransform.rotateZ(_rotation);

    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: new Transform(
            transform: cardTransform,
            origin: _cardMotionOrigin,
            child: new MatchCard(
              profile: demoMatches[0],
            ),
          ),
        )
      ],
    );
  }
}

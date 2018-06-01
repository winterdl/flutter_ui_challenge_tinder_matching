import 'package:flutter/material.dart';
import 'package:fluttery/layout.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tinder Matching',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildAppBar() {
    return new AppBar(
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
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0.0,
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new RoundIconButton.small(
              icon: Icons.refresh,
              iconColor: Colors.orange,
            ),
            new RoundIconButton.large(
              icon: Icons.clear,
              iconColor: Colors.red,
            ),
            new RoundIconButton.small(
              icon: Icons.star,
              iconColor: Colors.blue,
            ),
            new RoundIconButton.large(
              icon: Icons.favorite,
              iconColor: Colors.green,
            ),
            new RoundIconButton.small(
              icon: Icons.lock,
              iconColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStack() {
    return new AnchoredOverlay(
      showOverlay: true,
      child: new Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: new Container(
            width: anchorBounds.width,
            height: anchorBounds.height,
            padding: const EdgeInsets.all(16.0),
            child: new ProfileCard(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(),
      body: _buildCardStack(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}

class ProfileCard extends StatelessWidget {
  Widget _buildBackground() {
    return new Image.asset(
      'assets/photo_1.jpg',
      fit: BoxFit.cover,
    );
  }

  Widget _buildProfileSynopsis() {
    return new Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.8),
          ],
        )),
        padding: const EdgeInsets.all(24.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text('First Last',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                      )),
                  new Text('Some description',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      )),
                ],
              ),
            ),
            new Icon(
              Icons.info,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(10.0),
        boxShadow: [
          new BoxShadow(
            color: const Color(0x11000000),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        child: new Material(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double size;
  final VoidCallback onPressed;

  RoundIconButton.large({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 60.0;

  RoundIconButton.small({
    this.icon,
    this.iconColor,
    this.onPressed,
  }) : size = 50.0;

  RoundIconButton({
    this.icon,
    this.iconColor,
    this.size,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
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
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

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
              child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  new ClipRRect(
                    borderRadius: new BorderRadius.circular(10.0),
                    child: new MatchCard(
                      profile: demoMatches[0],
                    ),
                  )
                ],
              ),
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

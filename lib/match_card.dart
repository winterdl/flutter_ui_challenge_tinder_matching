import 'package:flutter/material.dart';
import 'package:prototype/profiles.dart';

class MatchCard extends StatefulWidget {
  final Profile profile;

  MatchCard({
    this.profile,
  });

  @override
  _MatchCardState createState() => new _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  int _photoIndex = 0;

  void _nextImage() {
    if (_photoIndex < widget.profile.photoUrls.length - 1) {
      setState(() => _photoIndex++);
    }

//    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Next Image')));
  }

  void _prevImage() {
    if (_photoIndex > 0) {
      setState(() => _photoIndex--);
    }

//    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text('Prev Image')));
  }

  void _showProfile() {
    // TODO: show profile with hero transition
  }

  Widget _buildPhotoDisplay() {
    return new Image.network(
      widget.profile.photoUrls[_photoIndex],
      fit: BoxFit.cover,
    );
  }

  Widget _buildPhotoControls() {
    // Note: these controls are invisible.
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new GestureDetector(
            onTap: _prevImage,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
        new Expanded(
          child: new GestureDetector(
            onTap: _nextImage,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSelectorIndicator() {
    return new Positioned(
      left: 0.0,
      right: 0.0,
      top: 0.0,
      child: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Container(
          width: double.infinity,
          height: 5.0,
          child: new PhotoIndicator(
            photoCount: widget.profile.photoUrls.length,
            activePhotoIndex: _photoIndex,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSynopsis() {
    return new Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: new GestureDetector(
        onTap: _showProfile,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
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
      child: new ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildPhotoDisplay(),
            _buildPhotoControls(),
            _buildPhotoSelectorIndicator(),
            _buildProfileSynopsis(),
          ],
        ),
      ),
    );
  }
}

class PhotoIndicator extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;

  PhotoIndicator({
    this.photoCount,
    this.activePhotoIndex,
  });

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new PhotoIndicatorPainter(
        photoCount: photoCount,
        activePhotoIndex: activePhotoIndex,
      ),
      child: new Container(),
    );
  }
}

class PhotoIndicatorPainter extends CustomPainter {
  final int photoCount;
  final int activePhotoIndex;
  final Paint trackPaint;
  final Paint thumbPaint;

  PhotoIndicatorPainter({
    this.photoCount,
    this.activePhotoIndex,
  })  : trackPaint = new Paint()
          ..color = const Color(0x22000000)
          ..style = PaintingStyle.fill,
        thumbPaint = new Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw track
    canvas.drawRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
      trackPaint,
    );

    // Draw thumb
    final thumbWidth = size.width / photoCount;
    final thumbLeft = activePhotoIndex * thumbWidth;

    Path thumbPath = new Path();
    thumbPath.addRRect(
      new RRect.fromRectAndCorners(
        new Rect.fromLTWH(
          thumbLeft,
          0.0,
          thumbWidth,
          size.height,
        ),
        topLeft: new Radius.circular(3.0),
        topRight: new Radius.circular(3.0),
        bottomLeft: new Radius.circular(3.0),
        bottomRight: new Radius.circular(3.0),
      ),
    );

    // Thumb shadow
    canvas.drawShadow(
      thumbPath,
      const Color(0x88000000),
      1.0,
      false,
    );

    // Thumb shape
    canvas.drawPath(
      thumbPath,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:boats_challenge/src/data/boats.dart';
import 'package:boats_challenge/src/pages/view_boat_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  AnimationController _animationController;
  Animation<Offset> _trasnlateAnimation;
  Animation<double> _opacityAnimation;
  PageController _controller;
  double _currentPage = 0.0;

  void _listener() => setState(() => _currentPage = _controller.page );

  void callBack(bool animate) => animate ? _animationController.forward() : _animationController.reverse();

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration( milliseconds: 400 )
    );
    _controller = new PageController(
      viewportFraction: 0.75
    );
    _controller.addListener(_listener);
    _trasnlateAnimation = Tween<Offset>( begin: Offset.zero, end: Offset(0.0, -30.0) ).animate(_animationController);
    _opacityAnimation = Tween<double>( begin: 1.0, end: 0.0 ).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() { 
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox( height: 10.0 ),
              AnimatedBuilder(
                animation: _trasnlateAnimation,
                builder: ( _ , child ) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Transform.translate(
                      offset: _trasnlateAnimation.value,
                      child: Container(
                        child: Row(
                          children: [
                            SizedBox( width: 10.0 ),
                            Text('Boats', style: TextStyle( fontSize: 30.0, color: Colors.black, fontWeight: FontWeight.bold )),
                            Spacer(),
                            IconButton(
                              splashRadius: 20.0,
                              icon: Icon(Icons.search_rounded, size: 30.0, color: Colors.black), 
                              onPressed: (){},
                            ),
                            SizedBox( width: 5.0 )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
              Container(
                height: 650.0,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: boats.length,
                  itemBuilder: ( __ , index ) {
                    final percent = ( _currentPage <= index ) 
                      ? ( _currentPage - index ) + 1 
                      : ( index - _currentPage ) + 1;
                    final scale = percent.clamp(0.75, 1.0);
                    final opacity = percent.clamp(0.0, 1.0);
                    return BoatWidget(
                      boat: boats[index],
                      scale: scale,
                      opacity: opacity,
                      callBack: callBack,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class BoatWidget extends StatefulWidget {

  final Boat boat;
  final double scale;
  final double opacity;
  final Function(bool) callBack;

  const BoatWidget({
    Key key,
    @required this.boat,
    @required this.scale,
    @required this.opacity,
    @required this.callBack
  }) : super(key: key);

  @override
  _BoatWidgetState createState() => _BoatWidgetState();
}

class _BoatWidgetState extends State<BoatWidget> {

  bool heroAnimationCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: this.widget.opacity,
      child: Container(
        margin: const EdgeInsets.symmetric( vertical: 10.0 ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: this.widget.scale,
              child: Hero(
                tag: this.widget.boat.image,
                flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                  animation.addStatusListener((status) { 
                    if( status == AnimationStatus.completed ) setState(() => heroAnimationCompleted = true );
                    if( status == AnimationStatus.dismissed ) setState(() => heroAnimationCompleted = false );
                  });
                  return RotationTransition(
                    turns: animation.drive(
                      Tween<double>(begin: ( heroAnimationCompleted ) ? 1.0 : -0.8, end: ( heroAnimationCompleted ) ? 0.8 : -1.0)
                      .chain(
                        CurveTween(
                          curve: ( heroAnimationCompleted ) 
                            ? Cubic(0.4, 0.90, 1.0, 1.250).flipped
                            : Cubic(0.4, 0.90, 1.0, 1.250)
                        )
                      ),
                    ),
                    child: toHeroContext.widget,
                  );
                },
                child: Image.asset(
                  this.widget.boat.image, 
                  height: 450.0,
                  width: 150.0,
                ),
              ),
            ),
            SizedBox( height: 20.0 ),
            Text(this.widget.boat.title, style: TextStyle( fontSize: 30.0, color: Colors.black87, fontWeight: FontWeight.w600)),
            SizedBox( height: 5.0 ),
            RichText(
              text: TextSpan(
                text: 'By ',
                style: TextStyle( fontSize: 14.0, color: Colors.grey ),
                children: [
                  TextSpan(
                    text: this.widget.boat.by,
                    style: TextStyle( fontSize: 14.0, color: Colors.black87, fontWeight: FontWeight.w600)
                  )
                ]
              )
            ),
            SizedBox( height: 20.0 ),
            GestureDetector(
              child: Container(
                width: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('SPEC', style: TextStyle( fontSize: 18.0, color: Colors.blue, fontWeight: FontWeight.w600 ),),
                    Icon(Icons.arrow_forward_ios, size: 18.0, color: Colors.blue),
                  ],
                ),
              ),
              onTap: (){
                this.widget.callBack(true);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration( milliseconds: 500 ),
                    reverseTransitionDuration: const Duration( milliseconds: 600 ),
                    pageBuilder: ( _ , __, ___ ) => ViewBoatPage(boat: this.widget.boat),
                    transitionsBuilder: ( _ , anim1,  __ , child) => FadeTransition(
                      opacity: Tween<double>( begin: 0.0, end: 1.0).animate(anim1),
                      child: child,
                    )
                  )
                ).then((_) => this.widget.callBack(false) );
              },
            ),
          ],
        ),
      ),
    );
  }
}

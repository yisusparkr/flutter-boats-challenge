import 'dart:math';

import 'package:flutter/material.dart';
import 'package:boats_challenge/src/data/boats.dart';

class ViewBoatPage extends StatefulWidget {

  final Boat boat;

  const ViewBoatPage({
    Key key, 
    @required this.boat
  }) : super(key: key);

  @override
  _ViewBoatPageState createState() => _ViewBoatPageState();
}

class _ViewBoatPageState extends State<ViewBoatPage> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration( milliseconds: 400 )
    );

    _offsetAnimation = Tween<Offset>( begin: Offset(0.0, -0.6), end: Offset(0.0, 0.0) ).chain(CurveTween(curve: Curves.elasticInOut)).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() { 
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _animationController.forward();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderContainer(boatImage: this.widget.boat.image),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(this.widget.boat.title, style: TextStyle( fontSize: 30.0, color: Colors.black87, fontWeight: FontWeight.w600)),
              ),
              SizedBox( height: 5.0 ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: RichText(
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
              ),
              SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  padding: const EdgeInsets.only( left: 20.0 ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox( height: 20.0 ),
                      Text(this.widget.boat.description, style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.w300 )),
                      SizedBox( height: 25.0 ),
                      Text('SPEC', style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.w300 )),
                      SizedBox( height: 20.0 ),
                      _SpecContainer(spec: 'Boat Length', value: this.widget.boat.boatLength, space: 40.0,),
                      _SpecContainer(spec: 'Beam', value: '${this.widget.boat.beam}\"', space: 85.0,),
                      _SpecContainer(spec: 'Weight', value: '${this.widget.boat.weight} KG', space: 80.0,),
                      _SpecContainer(spec: 'Fuel Capacity', value: '${this.widget.boat.fuelCapacity} L', space: 35.0,),
                      SizedBox( height: 30.0 ),
                      Text('GALLERY', style: TextStyle( fontSize: 18.0, fontWeight: FontWeight.w300 )),
                      SizedBox( height: 10.0 ),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: this.widget.boat.gallery.length,
                          itemBuilder: ( _ , index) => Container(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.only( right: 10.0 ),
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Image.asset(this.widget.boat.gallery[index], fit: BoxFit.fill),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _SpecContainer extends StatelessWidget {
  
  final String spec;
  final String value;
  final double space;

  const _SpecContainer({
    Key key,
    @required this.spec,
    @required this.value,
    this.space = 50.0
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Text(this.spec, style: TextStyle( fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.w500)),
          SizedBox( width: this.space),
          Text(this.value, style: TextStyle( fontSize: 16.0, fontWeight: FontWeight.w300 )),
        ],
      ),
    );
  }
}

class _HeaderContainer extends StatelessWidget {

  final String boatImage;

  const _HeaderContainer({
    Key key,
    @required this.boatImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -120.0,
            right: -160.0,
            child: Hero(
              tag: this.boatImage,
              child: Transform.rotate(
                angle: -pi / 2,
                child: Image.asset(
                  this.boatImage, 
                  height: 500.0,
                  width: 500.0,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            left: 15.0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 30.0,
                width: 30.0,
                child: Icon(Icons.close, size: 16.0, color: Colors.grey.shade600,),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
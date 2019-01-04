import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int pageIndex = 0;
  double height = 100;
  bool follow = false;
  bool swipeUp;

  AnimationController _controller;
  Animation<Offset> animationSlide;
  Animation<double> animationOpacity;

  AnimationController _controllerButton;
  Animation<double> animationButtonOpacity;
  Animation<double> animationButtonSize;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animationSlide = Tween<Offset>(begin: Offset(0, -0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5),
      ),
    )..addListener(() {
        setState(() {});
      });
    animationOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controllerButton = AnimationController(vsync: this, duration: Duration(milliseconds: 250))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          follow = false;
        }
      });
    animationButtonOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controllerButton, curve: Interval(0.8, 1.0)))
          ..addListener(() {
            setState(() {});
          });
    animationButtonSize = Tween<double>(begin: 120.0, end: 50.0)
        .animate(CurvedAnimation(parent: _controllerButton, curve: Interval(0.0, 0.8)))
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerButton.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 27.0,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 27.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.filter_none),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              FloatingActionButton(
                backgroundColor: Color(0xFFFF4B23),
                child: Icon(Icons.add),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      height -= details.primaryDelta;
      swipeUp = (details.primaryDelta < 0);
      if (height < 100.0) {
        height = 100.0;
      } else if (height > 400.0) {
        height = 400.0;
      }
    });
  }

  _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      if (swipeUp) {
        height = 400.0;
      } else {
        height = 100.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                      follow = people[pageIndex].isFollowing;
                      if (follow) {
                        _controllerButton.forward();
                      } else {
                        _controllerButton.reset();
                      }
                      _controller.reset();
                      _controller.forward();
                    });
                  },
                  itemCount: people.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      people[index].profileImage,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                _buildAppBar(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      height: 100.0,
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Opacity(
                            opacity: animationOpacity.value,
                            child: SlideTransition(
                              position: animationSlide,
                              child: Rating(rating: people[pageIndex].followers, text: "Followers"),
                            ),
                          ),
                          Opacity(
                            opacity: animationOpacity.value,
                            child: SlideTransition(
                              position: animationSlide,
                              child: Rating(rating: people[pageIndex].images, text: "Images"),
                            ),
                          ),
                          Opacity(
                            opacity: animationOpacity.value,
                            child: SlideTransition(
                              position: animationSlide,
                              child: Rating(rating: people[pageIndex].posts, text: "Posts"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onVerticalDragEnd: _onVerticalDragEnd,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: height,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                          child: Container(
                            padding: EdgeInsets.only(left: 32.0),
                            color: Color(0xFFF7F7F7),
                            height: 300.0,
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 32.0, top: 16.0, bottom: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Opacity(
                                        opacity: animationOpacity.value,
                                        child: SlideTransition(
                                          position: animationSlide,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                people[pageIndex].name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25.0,
                                                  fontFamily: "Staatliches",
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                              Text(
                                                people[pageIndex].country,
                                                style: TextStyle(fontSize: 17.0, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: animationOpacity.value,
                                        child: SlideTransition(
                                          position: animationSlide,
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: <Widget>[
                                              InkWell(
                                                splashColor: Colors.deepOrangeAccent,
                                                onTap: () {
                                                  follow = people[pageIndex].isFollowing = true;
                                                  _controllerButton.forward();
                                                },
                                                borderRadius: BorderRadius.circular(30.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: animationButtonSize.value,
                                                  height: 45.0,
                                                  child: Visibility(
                                                    visible: !follow,
                                                    child: Text(
                                                      "FOLLOW",
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.deepOrange,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 2, color: Colors.deepOrange),
                                                    borderRadius: BorderRadius.circular(30.0),
                                                    color: !follow ? Colors.transparent : Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Opacity(
                                                opacity: animationButtonOpacity.value,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    people[pageIndex].isFollowing = false;
                                                    _controllerButton.reverse();
                                                  },
                                                  child: Container(
                                                    width: 50.0,
                                                    padding: EdgeInsets.all(12.0),
                                                    child: Icon(
                                                      Icons.access_alarm,
                                                      color: Colors.white,
                                                    ),
                                                    decoration:
                                                        BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 32.0),
                                  child: Text(
                                    people[pageIndex].description,
                                    style: TextStyle(fontFamily: "Courgette", fontSize: 17.0),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    "Photos",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                  ),
                                ),
                                Container(
                                  height: 150.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: people[pageIndex].imagesList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        width: 170.0,
                                        margin: EdgeInsets.only(right: 10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          image: DecorationImage(
                                              alignment: Alignment.topCenter,
                                              image: AssetImage(people[pageIndex].imagesList[index]),
                                              fit: BoxFit.cover),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }
}

class Rating extends StatelessWidget {
  final int rating;
  final String text;

  const Rating({Key key, this.rating, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "${rating / 1000}K",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25.0),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey[400], fontSize: 18.0, fontFamily: "Kalam"),
        ),
      ],
    );
  }
}

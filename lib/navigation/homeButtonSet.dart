import 'package:flutter/material.dart';

class Button1 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final myDrawerKey;
  Button1(this.myDrawerKey);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          size: 34,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
        // highlight color is used to block grey flash on Tap
        highlightColor: Colors.white,
        onPressed: () {
          myDrawerKey.currentState.openDrawer();
          // _drawerKey.currentState.openDrawer()
        },
      ),
    );
  }
}

class Button11 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final fnc;
  Button11(this.fnc);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: IconButton(
        icon: Icon(
          Icons.calculate_rounded,
          size: 32,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
        // highlight color is used to block grey flash on Tap
        highlightColor: Colors.white,
        onPressed: fnc,
      ),
    );
  }
}

class Button12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 3.5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: Color.fromRGBO(255, 255, 255, 1),
            color: Color.fromRGBO(255, 0, 0, 1),
            width: 3.5,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: Icon(
        Icons.calculate_rounded,
        size: 32,
        color: Color.fromRGBO(255, 0, 0, 1),
      ),
    );
  }
}

class Button21 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final fnc;
  Button21(this.fnc);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: IconButton(
        icon: Icon(
          Icons.event,
          size: 32,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
        // highlight color is used to block grey flash on Tap
        highlightColor: Colors.white,
        onPressed: fnc,
      ),
    );
  }
}

class Button22 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 3.5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: Color.fromRGBO(255, 255, 255, 1),
            color: Color.fromRGBO(255, 0, 0, 1),
            width: 3.5,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: Icon(
        Icons.event,
        size: 32,
        color: Color.fromRGBO(255, 0, 0, 1),
      ),
    );
  }
}

class Button31 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final fnc;
  Button31(this.fnc);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: IconButton(
        icon: Icon(
          Icons.wallet_travel_rounded,
          size: 32,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
        // highlight color is used to block grey flash on Tap
        highlightColor: Colors.white,
        onPressed: fnc,
      ),
    );
  }
}

class Button32 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 3.5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: Color.fromRGBO(255, 255, 255, 1),
            color: Color.fromRGBO(255, 0, 0, 1),
            width: 3.5,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: Icon(
        Icons.wallet_travel_rounded,
        size: 32,
        // color: Color.fromRGBO(255, 255, 255, 1),
        color: Color.fromRGBO(255, 0, 0, 1),
      ),
    );
  }
}

class Button41 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final fnc;
  Button41(this.fnc);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: IconButton(
        icon: Icon(
          Icons.timeline_rounded,
          size: 34,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
        // highlight color is used to block grey flash on Tap
        highlightColor: Colors.white,
        onPressed: fnc,
      ),
    );
  }
}

class Button42 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 3.5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: Color.fromRGBO(255, 255, 255, 1),
            color: Color.fromRGBO(255, 0, 0, 1),
            width: 3.5,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: Icon(
        Icons.timeline_rounded,
        size: 34,
        color: Color.fromRGBO(255, 0, 0, 1),
      ),
    );
  }
}

class Button51 extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final fnc;
  Button51(this.fnc);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: IconButton(
        icon: Icon(
          Icons.movie_creation_rounded,
          size: 34,
          color: Color.fromRGBO(255, 0, 0, 1),
        ),
        // highlight color is used to block grey flash on Tap
        highlightColor: Colors.white,
        onPressed: fnc,
      ),
    );
  }
}

class Button52 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 3.5,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            // color: Color.fromRGBO(255, 255, 255, 1),
            color: Color.fromRGBO(255, 0, 0, 1),
            width: 3.5,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width * (1 / 6),
      child: Icon(
        Icons.movie_creation_rounded,
        size: 34,
        color: Color.fromRGBO(255, 0, 0, 1),
      ),
    );
  }
}

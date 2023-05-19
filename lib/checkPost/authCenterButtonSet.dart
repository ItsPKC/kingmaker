import 'package:flutter/material.dart';

class Button11 extends StatelessWidget {
  final fnc;
  Button11(this.fnc);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: IconButton(
        icon: Icon(
          Icons.email_rounded,
          size: 28,
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      // padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 15,
        ),
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: Icon(
        Icons.email_rounded,
        size: 28,
        color: Color.fromRGBO(0, 0, 255, 1),
      ),
    );
  }
}

class Button21 extends StatelessWidget {
  final fnc;
  Button21(this.fnc);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: IconButton(
        icon: Icon(
          Icons.face_rounded,
          size: 28,
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 15,
        ),
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: Icon(
        Icons.face_rounded,
        size: 28,
        color: Color.fromRGBO(0, 0, 255, 1),
      ),
    );
  }
}

class Button31 extends StatelessWidget {
  final fnc;
  Button31(this.fnc);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: IconButton(
        icon: Icon(
          Icons.menu_book_rounded,
          size: 28,
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 15,
        ),
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: Icon(
        Icons.menu_book_rounded,
        size: 28,
        color: Color.fromRGBO(0, 0, 255, 1),
      ),
    );
  }
}

class Button41 extends StatelessWidget {
  final fnc;
  Button41(this.fnc);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: IconButton(
        icon: Icon(
          Icons.menu_book_rounded,
          size: 28,
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 15,
        ),
        shape: BoxShape.circle,
      ),
      width: MediaQuery.of(context).size.width * 0.15,
      child: Icon(
        Icons.menu_book_rounded,
        size: 28,
        color: Color.fromRGBO(0, 0, 255, 1),
      ),
    );
  }
}

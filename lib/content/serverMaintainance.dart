import 'dart:math';

import 'package:flutter/material.dart';

class UnderMaintenance extends StatefulWidget {
  final _data;
  const UnderMaintenance(this._data, {Key? key}) : super(key: key);

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: (() async {
          return false;
        }),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Icon(
                  Icons.timer,
                  size: min(MediaQuery.of(context).size.width * 0.5,
                      MediaQuery.of(context).size.height * 0.5),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    widget._data['maintenanceTime'] == ''
                        ? 'We\'ll Be Right Back!'
                        : widget._data['maintenanceTime'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Segnika',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    'Sorry, we are down for maintenance\nbut\nwe will back in no time!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.75,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

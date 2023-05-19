import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../content/globalVariable.dart';

class AnalyticsViews extends StatefulWidget {
  final Function pageNumberSelector;
  const AnalyticsViews(this.pageNumberSelector, {super.key});

  @override
  State<AnalyticsViews> createState() => _AnalyticsViewsState();
}

class _AnalyticsViewsState extends State<AnalyticsViews> {
  final _controller = ScrollController();
  // var dayFilterAnalyticsViews = prefs.get('dayFilterAnalyticsViews') ?? '15d';
  // List<List<dynamic>> data = [];

  // var showChart = true;
  // setChartStatus() {
  //   setState(() {
  //     showChart = !showChart;
  //   });
  // }

  // dateBeauty(value) {
  //   if (value.toString().length == 1) {
  //     return '0$value';
  //   } else {
  //     return value;
  //   }
  // }

  // getDate(element) {
  //   return '${dateBeauty(element['date'].toDate().day)}-${dateBeauty(element['date'].toDate().month)}-${element['date'].toDate().year.toString()[2]}${element['date'].toDate().year.toString()[3]}';
  // }

  // filterData(filter) async {
  //   dayFilterAnalyticsViews = filter;
  //   await prefs.setString('dayFilterAnalyticsViews', dayFilterAnalyticsViews);

  //   switch (filter) {
  //     case '7d':
  //       data = [];
  //       var tempdata = creatorInfo['vcHistory'].sublist(
  //           creatorInfo['vcHistory'].length - 7 > 0
  //               ? creatorInfo['vcHistory'].length - 7
  //               : 0);

  //       tempdata.forEach((element) {
  //         data.add([getDate(element), element['vc']]);
  //       });
  //       break;
  //     case '15d':
  //       data = [];
  //       var tempdata = creatorInfo['vcHistory'].sublist(
  //           creatorInfo['vcHistory'].length - 15 > 0
  //               ? creatorInfo['vcHistory'].length - 15
  //               : 0);

  //       tempdata.forEach((element) {
  //         data.add([getDate(element), element['vc']]);
  //       });
  //       break;
  //     case '30d':
  //       data = [];
  //       var tempdata = creatorInfo['vcHistory'].sublist(
  //           creatorInfo['vcHistory'].length - 30 > 0
  //               ? creatorInfo['vcHistory'].length - 30
  //               : 0);

  //       tempdata.forEach((element) {
  //         data.add([getDate(element), element['vc']]);
  //       });
  //       break;
  //     case '90d':
  //       data = [];
  //       var tempdata = creatorInfo['vcHistory'].sublist(
  //           creatorInfo['vcHistory'].length - 90 > 0
  //               ? creatorInfo['vcHistory'].length - 90
  //               : 0);

  //       tempdata.forEach((element) {
  //         data.add([getDate(element), element['vc']]);
  //       });
  //       break;
  //     case 'Lifetime':
  //       data = [];
  //       var tempdata = creatorInfo['vcHistory'];

  //       tempdata.forEach((element) {
  //         data.add([getDate(element), element['vc']]);
  //       });
  //       break;
  //   }
  //   setState(() {
  //     dayFilterAnalyticsViews;
  //     data;
  //   });
  // }

  // @override
  // void initState() {
  //   filterData(prefs.get('dayFilterAnalyticsViews') ?? '15d');
  //   super.initState();
  // }

  var dayFilterAnalyticsViews = prefs.get('dayFilterAnalyticsViews') ?? '15d';
  List<List<dynamic>> dataViews = [];

  var showChart = true;
  setChartStatus() {
    setState(() {
      showChart = !showChart;
    });
  }

  dateBeauty(value) {
    if (value.toString().length == 1) {
      return '0$value';
    } else {
      return value;
    }
  }

  getDate(element) {
    return '${dateBeauty(element['date'].toDate().day)}-${dateBeauty(element['date'].toDate().month)}-${element['date'].toDate().year.toString()[2]}${element['date'].toDate().year.toString()[3]}';
  }

  filterData(filter) async {
    var filterDateList = [];
    var allDataViews = {};
    dataViews = [];

    setFilterData(value) {
      var currentTime = DateTime.now();
      if (value != 'Lifetime') {
        for (var i = 0; i < value; i++) {
          var tempDate = DateTime(
              currentTime.year, currentTime.month, currentTime.day - i);
          var resultantDate =
              '${dateBeauty(tempDate.day)}-${dateBeauty(tempDate.month)}-${tempDate.year.toString()[2]}${tempDate.year.toString()[3]}';
          filterDateList.add(resultantDate);
        }
        print(filterDateList);
      } else {
        print('------------------------------------');
        var shouldContinue = true;
        var i = 0;
        while (shouldContinue) {
          var tempDate = DateTime(
              currentTime.year, currentTime.month, currentTime.day - i);
          var resultantDate =
              '${dateBeauty(tempDate.day)}-${dateBeauty(tempDate.month)}-${tempDate.year.toString()[2]}${tempDate.year.toString()[3]}';
          filterDateList.add(resultantDate);
          i += 1;
          if (resultantDate == getDate(creatorInfo['vcHistory'][0])) {
            shouldContinue = false;
          }
        }
      }

      // To manage cc according to vc

      creatorInfo['vcHistory'].forEach((element) {
        // getDate(element) - Provides date
        allDataViews[getDate(element)] = element['vc'];
      });

      for (var element in filterDateList) {
        if (allDataViews[element] != null) {
          dataViews.add([element, allDataViews[element]]);
        } else {
          dataViews.add([element, 0]);
        }
      }
      dataViews = dataViews.reversed.toList();
      if (_controller.hasClients) {
        _controller.position.jumpTo(0);
      }
    }

    // ------------------------------------------------------------------

    dayFilterAnalyticsViews = filter;
    await prefs.setString('dayFilterAnalyticsViews', dayFilterAnalyticsViews);

    switch (filter) {
      case '7d':
        setFilterData(7);

        break;
      case '15d':
        setFilterData(15);

        break;
      case '30d':
        setFilterData(30);

        break;
      case '90d':
        setFilterData(90);

        break;
      case 'Lifetime':
        setFilterData('Lifetime');
        break;
    }

    setState(() {
      dayFilterAnalyticsViews;
      dataViews;
    });
  }

  @override
  void initState() {
    filterData(prefs.get('dayFilterAnalyticsViews') ?? 'Lifetime');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!showChart) {
          setChartStatus();
        } else {
          widget.pageNumberSelector(6);
        }
        return false;
      },
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showChart)
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: EdgeInsets.only(top: 65),
                  child: SfCartesianChart(
                    zoomPanBehavior: ZoomPanBehavior(
                      // Enables pinch zooming
                      enablePinching: true,
                      enablePanning: true,
                      zoomMode: ZoomMode.x,
                    ),
                    primaryXAxis: CategoryAxis(),
                    // title: ChartTitle(
                    //   text: 'Views',
                    //   alignment: ChartAlignment.center,
                    //   textStyle: TextStyle(
                    //     fontFamily: 'Signika',
                    //     fontWeight: FontWeight.w600,
                    //     letterSpacing: 2,
                    //     color: Color.fromRGBO(36, 14, 123, 1),
                    //   ),
                    // ),
                    // Enable legend
                    tooltipBehavior: TooltipBehavior(enable: true),
                    // legend: Legend(
                    //   isVisible: true,
                    //   borderColor: Colors.amber,
                    //   legendItemBuilder: (legendText, series, point, seriesIndex) {
                    //     return Text(legendText);
                    //   },
                    // ),
                    series: <ColumnSeries<List, String>>[
                      ColumnSeries<List, String>(
                        dataSource: dataViews,
                        xValueMapper: (sales, _) => sales[0],
                        yValueMapper: (sales, _) => sales[1],
                        xAxisName: 'Date',
                        yAxisName: 'Views',
                        name: 'Views',

                        markerSettings: MarkerSettings(
                          isVisible: true,
                          height: 2,
                          width: 2,
                          shape: DataMarkerType.circle,
                          borderWidth: 3,
                        ),
                        // Enable data label
                        color: Color.fromRGBO(36, 14, 123, 1),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding:
                      showChart ? EdgeInsets.only(top: 15) : EdgeInsets.all(0),
                  child: Stack(
                    children: [
                      ListView(
                        controller: _controller,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          ...dataViews.reversed.toList().mapIndexed(
                            (index, element) {
                              var _changes = index == dataViews.length - 1
                                  ? 0
                                  : (element[1] -
                                          dataViews.reversed.toList()[index + 1]
                                              [1]) *
                                      100 /
                                      dataViews.reversed.toList()[index + 1][1];
                              return Container(
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                color: _changes >= 0
                                    ? Color.fromRGBO(247, 255, 247, 1)
                                    : Color.fromRGBO(255, 247, 247, 1),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${element[0]}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${element[1]}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 17.2,
                                        color: Colors.transparent,
                                        alignment: Alignment.centerRight,
                                        child: FittedBox(
                                          child: Text(
                                            index == dataViews.length - 1
                                                ? '-------'
                                                : dataViews.reversed.toList()[
                                                            index + 1][1] ==
                                                        0
                                                    ? '-------'
                                                    : '${_changes.toStringAsFixed(1)}%',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: _changes >= 0
                                                  ? Color.fromRGBO(
                                                      37, 211, 102, 1)
                                                  : Color.fromRGBO(
                                                      230, 0, 0, 1),
                                              fontFamily: 'Signika',
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(36, 14, 123, 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              offset: Offset(0, 0.5),
                              blurRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setChartStatus();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Date',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Signika',
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Views',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: 'Signika',
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Changes (%)',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Signika',
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Transform(
                          transform: showChart
                              ? Matrix4.translationValues(0, -7, 0)
                              : Matrix4.translationValues(0, 31, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Material(
                              color: Color.fromRGBO(36, 14, 123, 1),
                              child: InkWell(
                                onTap: () {
                                  setChartStatus();
                                },
                                child: Container(
                                  height: 16,
                                  width: 24,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    showChart
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    size: 16,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showChart)
            Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(170, 170, 170, 1),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          widget.pageNumberSelector(6);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.fromLTRB(8, 8, 15, 8),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            shape: BoxShape.circle,
                            // image: DecorationImage(
                            //   image: AssetImage('assets/logoAppBar.png'),
                            // ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                offset: Offset(0, 0),
                                blurRadius: 1,
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color.fromRGBO(36, 14, 123, 1),
                          ),
                        ),
                      ),
                      Text(
                        'Views',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontSize: 20,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(36, 14, 123, 1),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Container(
                            width: double.infinity,
                            color: Color.fromRGBO(255, 255, 255, 0.85),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Material(
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            Navigator.pop(context);
                                            filterData('7d');
                                          });
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '7 Days',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Material(
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            Navigator.pop(context);
                                            filterData('15d');
                                          });
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '15 Days',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Material(
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            Navigator.pop(context);
                                            filterData('30d');
                                          });
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '30 Days',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Material(
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            Navigator.pop(context);
                                            filterData('90d');
                                          });
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '90 Days',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Material(
                                      color: Color.fromRGBO(36, 14, 123, 1),
                                      child: InkWell(
                                        onTap: () {
                                          Future.delayed(
                                              Duration(milliseconds: 200), () {
                                            Navigator.pop(context);
                                            filterData('Lifetime');
                                          });
                                        },
                                        child: Container(
                                          width: 200,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Lifetime',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1),
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Material(
                                      color: Color.fromRGBO(230, 0, 0, 1),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.close_rounded,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(230, 0, 0, 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(12, 1, 10, 1),
                                child: Text(
                                  dayFilterAnalyticsViews,
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Signika',
                                    letterSpacing: 0.75,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down_circle_rounded,
                              size: 28,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

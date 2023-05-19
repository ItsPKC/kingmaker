import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Analytics extends StatefulWidget {
  final Function pageNumberSelector;
  const Analytics(this.pageNumberSelector, {super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  var dayFilterAnalytics = prefs.get('dayFilterAnalytics') ?? '15d';
  List<List<dynamic>> dataViews = [];
  List<List<dynamic>> dataEarning = [];

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
    var allDataEarning = {};
    var allDataViews = {};
    dataEarning = [];
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
        while (shouldContinue && i < 50) {
          var tempDate = DateTime(
              currentTime.year, currentTime.month, currentTime.day - i);
          var resultantDate =
              '${dateBeauty(tempDate.day)}-${dateBeauty(tempDate.month)}-${tempDate.year.toString()[2]}${tempDate.year.toString()[3]}';
          filterDateList.add(resultantDate);
          print('-----------------------$resultantDate');

          print(
              '-----------------------${getDate(creatorInfo['ccHistory'][0])}');
          i += 1;
          if (resultantDate == getDate(creatorInfo['ccHistory'][0])) {
            shouldContinue = false;
          }
        }
      }

      // To manage cc according to vc

      creatorInfo['ccHistory'].forEach((element) {
        // getDate(element) - Provides date
        allDataEarning[getDate(element)] = element['cc'] / 10000;
      });
      print(allDataEarning);

      for (var element in filterDateList) {
        print(allDataEarning[element]);
        if (allDataEarning[element] != null) {
          dataEarning.add([element, allDataEarning[element]]);
        } else {
          dataEarning.add([element, 0]);
        }
      }
      print(dataEarning);
      dataEarning = dataEarning.reversed.toList();

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
    }

    // ------------------------------------------------------------------

    dayFilterAnalytics = filter;
    await prefs.setString('dayFilterAnalytics', dayFilterAnalytics);

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
        setFilterData(360);

        break;
      case 'Lifetime':
        setFilterData('Lifetime');
        break;
    }

    setState(() {
      dayFilterAnalytics;
      dataViews;
      dataEarning;
    });
  }

  @override
  void initState() {
    filterData(prefs.get('dayFilterAnalytics') ?? 'Lifetime');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.pageNumberSelector(6);
        return false;
      },
      child: Stack(
        children: [
          ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                margin: EdgeInsets.only(top: 65),
                child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                    // Enables pinch zooming
                    enablePinching: true,
                    enablePanning: true,
                    zoomMode: ZoomMode.x,
                  ),
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(
                    text: 'Views',
                    alignment: ChartAlignment.center,
                    textStyle: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Color.fromRGBO(36, 14, 123, 1),
                    ),
                  ),
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

                      // markerSettings: MarkerSettings(
                      //   isVisible: true,
                      //   height: 2,
                      //   width: 2,
                      //   shape: DataMarkerType.circle,
                      //   borderWidth: 3,
                      // ),
                      // Enable data label
                      color: Color.fromRGBO(36, 14, 123, 1),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                    // Enables pinch zooming
                    enablePinching: true,
                    enablePanning: true,
                    zoomMode: ZoomMode.x,
                  ),
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(
                    text: 'Earning (₹)',
                    alignment: ChartAlignment.center,
                    textStyle: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Color.fromRGBO(255, 140, 0, 1),
                    ),
                  ),
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
                      dataSource: dataEarning,
                      xValueMapper: (sales, _) => sales[0],
                      yValueMapper: (sales, _) => sales[1],
                      xAxisName: 'Date',
                      yAxisName: 'Views',
                      name: 'Earning',

                      // markerSettings: MarkerSettings(
                      //   isVisible: true,
                      //   height: 2,
                      //   width: 2,
                      //   shape: DataMarkerType.circle,
                      //   borderWidth: 3,
                      // ),
                      // Enable data label
                      color: Color.fromRGBO(255, 140, 0, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
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
                          color: Color.fromRGBO(230, 0, 0, 1),
                        ),
                      ),
                    ),
                    Text(
                      'Analytics',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Signika',
                        fontSize: 20,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(230, 0, 0, 1),
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
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
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
                                dayFilterAnalytics,
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

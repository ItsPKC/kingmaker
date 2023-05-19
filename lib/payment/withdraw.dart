import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingmaker/content/globalVariable.dart';
import 'package:share_plus/share_plus.dart';

class Withdraw extends StatefulWidget {
  final Function _pageNumberSelector;
  Withdraw(this._pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  var requestingCashout = false;
  var _bestPracticeVisibility = true;

  _requestCashout(context) async {
    if (piprocessingPayout == false) {
      if (pipaymentMethod.isEmpty) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Icon(
                    Icons.payments_rounded,
                    size: 150,
                    color: Color.fromRGBO(35, 15, 123, 1),
                  ),
                  content: Text(
                    'Payment method not found. Please complete payout settings to proceed.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'Signika',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(230, 0, 0, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            widget._pageNumberSelector(5);
                          },
                          child: Container(
                            height: 35,
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(35, 15, 123, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
        return;
      }
      setState(() {
        requestingCashout = true;
      });
      var _cashout = FirebaseFunctions.instanceFor(region: 'asia-south1')
          .httpsCallable('cashOutRequest');
      await _cashout().then((value) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(
              '${value.data}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(35, 15, 123, 1),
                fontFamily: 'Signika',
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Signika',
                    letterSpacing: 1,
                    color: Color.fromRGBO(230, 0, 0, 1),
                  ),
                ),
              ),
            ],
          ),
        );
        setState(() {
          requestingCashout = false;
        });
        if (value.data == 'Successful') {
          refreshCreatorData();
        }
      }).catchError((e) {
        print(e);
        setState(() {
          requestingCashout = false;
        });
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Processing Cashout',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(35, 15, 123, 1),
              fontFamily: 'Signika',
              fontSize: 18,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                widget._pageNumberSelector(7);
              },
              child: Text(
                'Know more',
                style: TextStyle(
                  fontFamily: 'Signika',
                  letterSpacing: 1,
                  color: Color.fromRGBO(230, 0, 0, 1),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  refreshCreatorData() async {
    // It helps to refresh just after getCreatorInfo Invoked
    setState(() {});
    await getCreatorInfo();
    _refresher() {
      if (mounted) {
        setState(() {});
      }
      if (isGettingCreatorInfo && mounted) {
        Future.delayed(Duration(milliseconds: 100), () {
          _refresher();
        });
      }
    }

    _refresher();
  }

  refreshTillCreatorInfoIsNull() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {});
      }
      if (creatorInfo == null && mounted) {
        refreshTillCreatorInfoIsNull();
      }
    });
  }

  @override
  void initState() {
    refreshTillCreatorInfoIsNull();
    super.initState();
  }

  // String? _paymentOption;
  @override
  Widget build(BuildContext context) {
    if (creatorInfo == null) {
      return WillPopScope(
        onWillPop: () async {
          widget._pageNumberSelector(4);
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  isGettingCreatorInfo || isGettingPrivateInfo
                      ? 'Please wait, fetching details.'
                      : 'Failed to fetch data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: 18,
                    letterSpacing: 1.5,
                    height: 2,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                isGettingCreatorInfo || isGettingPrivateInfo
                    ? CupertinoActivityIndicator(
                        radius: 20,
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Color.fromRGBO(230, 0, 0, 1),
                          ),
                        ),
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult != ConnectivityResult.none) {
                            if (!isGettingPrivateInfo) {
                              getPrivateInfo();
                              setState(() {});
                            } else {
                              setState(() {});
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          'No internet  ?',
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            letterSpacing: 1,
                                            color:
                                                Color.fromRGBO(36, 14, 123, 1),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Icon(
                                          Icons.network_check,
                                          size: 48,
                                          color: Color.fromRGBO(36, 14, 123, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: TextButton(
                                        child: Text(
                                          'Close',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                            letterSpacing: 2,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            'Refresh',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(230, 0, 0, 1),
                              fontFamily: 'Signika',
                              fontSize: 16,
                              // fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () => widget._pageNumberSelector(4),
        child: RefreshIndicator(
          onRefresh: () async {
            refreshCreatorData();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(220, 255, 220, 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        padding: EdgeInsets.fromLTRB(15, 0, 5, 0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 255, 220, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Icon(
                                  //   Icons.monetization_on,
                                  //   color: Colors.deepOrange,
                                  //   size: 40,
                                  // ),
                                  Container(
                                    height: 36,
                                    width: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 140, 0, 1),
                                      border: Border.all(
                                        color: Color.fromRGBO(255, 140, 0, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        colors: const [
                                          Color.fromRGBO(255, 155, 0, 1),
                                          Color.fromRGBO(255, 100, 0, 1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Text(
                                      '₹',
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontFamily: 'Signika',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      height: 37,
                                      child: FittedBox(
                                        child: Text(
                                          picc == 0
                                              ? '0.0'
                                              : '${picc / 10000}'.trim(),
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: 'Signika',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      widget._pageNumberSelector(7);
                                    },
                                    icon: Icon(
                                      Icons.payments_rounded,
                                      color: Color.fromRGBO(35, 15, 123, 1),
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      widget._pageNumberSelector(5);
                                    },
                                    icon: Icon(
                                      Icons.settings,
                                      color: Color.fromRGBO(35, 15, 123, 1),
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$pivc',
                                      style: TextStyle(
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 48,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    rateMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Signika',
                                      letterSpacing: 0.75,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: refreshCreatorData,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: isGettingCreatorInfo
                                        ? CupertinoActivityIndicator()
                                        : Icon(Icons.refresh_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            backgroundColor: Color.fromRGBO(220, 220, 220, 1),
                            color: Color.fromRGBO(35, 15, 123, 1),
                            value: minimumCashOut != 0
                                ? picc / 10000 / minimumCashOut
                                : 0,
                            minHeight: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹0',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Minimum ₹$minimumCashOut to cash out',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹$minimumCashOut',
                              style: TextStyle(
                                fontFamily: 'Signika',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: piprocessingPayout ||
                                (picc / 10000 < minimumCashOut)
                            ? 0.4
                            : 1,
                        child: GestureDetector(
                          onTap: () {
                            if (picc / 10000 >= minimumCashOut) {
                              _requestCashout(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text(
                                    'You must have at least\n\n₹$minimumCashOut',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(35, 15, 123, 1),
                                      fontFamily: 'Signika',
                                      fontSize: 18,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          fontFamily: 'Signika',
                                          letterSpacing: 1,
                                          color: Color.fromRGBO(230, 0, 0, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 210,
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(25),
                              // boxShadow: const [
                              //   BoxShadow(
                              //     color: Color.fromRGBO(0, 0, 0, 0.35),
                              //     offset: Offset(0, 1),
                              //     blurRadius: 1,
                              //   ),
                              // ],
                              border: Border.all(
                                color: Color.fromRGBO(230, 0, 0, 1),
                              ),
                            ),
                            child: requestingCashout
                                ? CupertinoActivityIndicator()
                                : Text(
                                    !piprocessingPayout
                                        ? 'Request Cash Out'
                                        : 'Processing Cashout',
                                    style: TextStyle(
                                      color: Color.fromRGBO(230, 0, 0, 1),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 5, 15, 12.5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.35),
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget._pageNumberSelector(16);
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.analytics_rounded,
                                  size: 34,
                                  color: Color.fromRGBO(36, 14, 123, 1),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Views',
                                  style: TextStyle(
                                    color: Color.fromRGBO(36, 14, 123, 1),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget._pageNumberSelector(17);
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.analytics_rounded,
                                  size: 34,
                                  color: Color.fromRGBO(255, 120, 0, 1),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Earning',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 120, 0, 1),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget._pageNumberSelector(15);
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.analytics_rounded,
                                  size: 34,
                                  color: Color.fromRGBO(0, 165, 65, 1),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'Analytics',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 165, 65, 1),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (creatorInfo['creatorAccountStatus'] > 0)
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(15, 12.5, 15, 12.5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          blurRadius: 0.5,
                          offset: Offset(0, 0.5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: creatorInfo[
                                                'creatorAccountStatus'] ==
                                            0
                                        ? [
                                            Color.fromRGBO(0, 165, 60, 1),
                                          ]
                                        : creatorInfo['creatorAccountStatus'] ==
                                                1
                                            ? [
                                                Color.fromRGBO(255, 140, 0, 1),
                                                Color.fromRGBO(255, 140, 0, 1),
                                                Color.fromRGBO(0, 0, 0, 0.05),
                                                Color.fromRGBO(0, 0, 0, 0.05),
                                              ]
                                            : [Color.fromRGBO(0, 0, 0, 0.05)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: creatorInfo[
                                                'creatorAccountStatus'] ==
                                            0
                                        ? [1]
                                        : creatorInfo['creatorAccountStatus'] ==
                                                1
                                            ? [0.5, 0.5, 0.5, 1]
                                            : [1],
                                  ),
                                ),
                                child: Text(''),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: creatorInfo[
                                                  'creatorAccountStatus'] ==
                                              0
                                          ? Color.fromRGBO(0, 165, 60, 1)
                                          : creatorInfo[
                                                      'creatorAccountStatus'] ==
                                                  1
                                              ? Color.fromRGBO(255, 140, 0, 1)
                                              : Color.fromRGBO(230, 0, 0, 1),
                                      border: Border.all(
                                        color: creatorInfo[
                                                    'creatorAccountStatus'] ==
                                                0
                                            ? Color.fromRGBO(0, 165, 60, 1)
                                            : creatorInfo[
                                                        'creatorAccountStatus'] ==
                                                    1
                                                ? Color.fromRGBO(255, 140, 0, 1)
                                                : Color.fromRGBO(230, 0, 0, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: creatorInfo[
                                                  'creatorAccountStatus'] ==
                                              0
                                          ? Color.fromRGBO(0, 165, 60, 1)
                                          : creatorInfo[
                                                      'creatorAccountStatus'] ==
                                                  1
                                              ? Color.fromRGBO(255, 140, 0, 1)
                                              : Color.fromRGBO(
                                                  255, 255, 255, 1),
                                      border: Border.all(
                                        color: creatorInfo[
                                                    'creatorAccountStatus'] ==
                                                0
                                            ? Color.fromRGBO(0, 165, 60, 1)
                                            : Color.fromRGBO(255, 140, 0, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color:
                                          creatorInfo['creatorAccountStatus'] ==
                                                  0
                                              ? Color.fromRGBO(0, 165, 60, 1)
                                              : Color.fromRGBO(
                                                  255, 255, 255, 1),
                                      border: Border.all(
                                        color: Color.fromRGBO(0, 165, 60, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                          decoration: BoxDecoration(
                            color: creatorInfo['creatorAccountStatus'] == 0
                                ? Color.fromRGBO(0, 165, 60, 0.1)
                                : creatorInfo['creatorAccountStatus'] == 1
                                    ? Color.fromRGBO(255, 140, 0, 0.1)
                                    : Color.fromRGBO(230, 0, 0, 0.1),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Account Status',
                                  style: TextStyle(
                                    color: creatorInfo[
                                                'creatorAccountStatus'] ==
                                            0
                                        ? Color.fromRGBO(0, 165, 60, 1)
                                        : creatorInfo['creatorAccountStatus'] ==
                                                1
                                            ? Color.fromRGBO(255, 140, 0, 1)
                                            : Color.fromRGBO(230, 0, 0, 1),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Signika',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Text(
                                creatorInfo['creatorAccountStatus'] == 0
                                    ? 'Healthy'
                                    : creatorInfo['creatorAccountStatus'] == 1
                                        ? 'At risk'
                                        : 'Disabled',
                                style: TextStyle(
                                  color: creatorInfo['creatorAccountStatus'] ==
                                          0
                                      ? Color.fromRGBO(0, 165, 60, 1)
                                      : creatorInfo['creatorAccountStatus'] == 1
                                          ? Color.fromRGBO(255, 140, 0, 1)
                                          : Color.fromRGBO(230, 0, 0, 1),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(15, 12.5, 15, 12.5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.35),
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/Referral.png'),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        width: double.infinity,
                        child: Text(
                          'Share with your friends',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromRGBO(35, 15, 123, 1),
                            fontSize: 18,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        child: FittedBox(
                          child: Text(
                            'Having 100K+ followers on any social platform.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromRGBO(35, 15, 123, 1),
                              // fontSize: 18,
                              fontFamily: 'Signika',
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Share.shareWithResult(
                            '*Hello !*\n\nTry the most advanced *App Opener* and *Bio Tool* like me -\n\n👉  Interconnect all social profiles\n👉  Open every link in the app\n👉  Create one *Bio Link* to connect and share everything.\n\n*Check my Bio Link :*\n👉  dpgram.com/$piuserID\n\n- - - - - - - - - - - - - - - - - - -\n\n*Create your Bio Link :*\n👉  https://play.google.com/store/apps/details?id=com.icyindia.kingmaker\n\n*Tutorial links :*\n👉  https://dpgram.com/en/HowToUse/Kingmaker\n\n- - - - - - - - - - - - - - - - - - -\n\n*Additional Features :*\n\n*Latest trending Hashtag, Audio, Reels, Shorts, Snap, Memes and many more.*',
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(5),
                            // boxShadow: const [
                            //   BoxShadow(
                            //     color: Color.fromRGBO(0, 0, 0, 0.35),
                            //     offset: Offset(0, 1),
                            //     blurRadius: 1,
                            //   ),
                            // ],
                            border: Border.all(
                              color: Color.fromRGBO(35, 15, 123, 1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Share now',
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 18,
                                  fontFamily: 'Signika',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.share,
                                color: Color.fromRGBO(35, 15, 123, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(15, 12.5, 15, 100),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.35),
                        blurRadius: 0.5,
                        offset: Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _bestPracticeVisibility =
                                    !_bestPracticeVisibility;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Expanded(
                                    child: Text(
                                      'Best practices to earn more',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Color.fromRGBO(230, 0, 0, 1),
                                        fontSize: 18,
                                        fontFamily: 'Signika',
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 28,
                                    color: Color.fromRGBO(230, 0, 0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _bestPracticeVisibility,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '1: Add dpGram link in bio',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 16,
                                  fontFamily: 'Signika',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Add your dpGram link in the bio of all social media like Instagram, Josh, Hipi, Moj, Snapchat, Tiki, Twitter, Koo, etc.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2: Share short videos',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 16,
                                  fontFamily: 'Signika',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Record a short video requesting your followers to connect on other platforms; and post it wherever you are active.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'It helps you to grow on other platforms and also increase earnings.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '3: Add Story regularly',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 16,
                                  fontFamily: 'Signika',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Add story regularly to remind your followers to connect on other platforms.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '4: Insert / Pin',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 16,
                                  fontFamily: 'Signika',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'If you are a YouTuber or Twitch streamer :-',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Add your dpGram link in the description of the video.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Share your "dpGram link" in the comment and pin it to the top.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '5: Bonus',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontSize: 16,
                                  fontFamily: 'Signika',
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                'Bonus will be awarded for every new visitors.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color.fromRGBO(35, 15, 123, 1),
                                  fontFamily: 'Signika',
                                  letterSpacing: 0.5,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // SizedBox(
                //   height: MediaQuery.of(context).size.height -
                //       50 -
                //       50 -
                //       MediaQuery.of(context).padding.top -
                //       MediaQuery.of(context).size.width * 2 / 7,
                //   // color: Color.fromRGBO(220, 255, 220, 1),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(8),
                //           boxShadow: const [
                //             BoxShadow(
                //               color: Color.fromRGBO(0, 0, 0, 1),
                //               blurRadius: 0.5,
                //               offset: Offset(0, 0.5),
                //             ),
                //           ],
                //         ),
                //         // padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
                //         child: TextFormField(
                //           decoration: InputDecoration(
                //             hintText: 'Full Name',
                //             suffixIcon: Icon(
                //               Icons.person_rounded,
                //               size: 30,
                //               color: Color.fromRGBO(255, 0, 0, 1),
                //             ),
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8),
                //               borderSide: BorderSide.none,
                //             ),
                //             filled: true,
                //             fillColor: Color.fromRGBO(255, 255, 255, 1),
                //             // It also override default padding
                //             contentPadding: EdgeInsets.only(
                //               top: 20,
                //               right: 20,
                //               bottom: 15,
                //               left: 15,
                //             ),
                //           ),
                //           keyboardType: TextInputType.emailAddress,
                //           style: TextStyle(
                //             fontFamily: 'Signika',
                //             fontWeight: FontWeight.w600,
                //             letterSpacing: 1.5,
                //             fontSize: 20,
                //           ),
                //           onChanged: (value) {
                //             // email = value;
                //           },
                //           // onEditingComplete: () =>
                //           //     FocusScope.of(context).nextFocus(),
                //         ),
                //       ),
                //       Container(
                //         decoration: BoxDecoration(
                //           color: Color.fromRGBO(255, 255, 255, 1),
                //           borderRadius: BorderRadius.circular(8),
                //           boxShadow: const [
                //             BoxShadow(
                //               color: Color.fromRGBO(0, 0, 0, 1),
                //               blurRadius: 0.5,
                //               offset: Offset(0, 0.5),
                //             ),
                //           ],
                //         ),
                //         margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                //         padding: EdgeInsets.fromLTRB(15, 5, 12, 5),
                //         child: DropdownButton<String>(
                //           value: _paymentOption,
                //           isExpanded: true,
                //           dropdownColor: Color.fromRGBO(225, 255, 255, 1),
                //           hint: Text('Payment Method'),
                //           style: TextStyle(
                //             color: Colors.black,
                //             fontFamily: 'Signika',
                //             fontSize: 20,
                //             fontWeight: FontWeight.w600,
                //             letterSpacing: 1.5,
                //           ),
                //           items: <String>['Paytm', 'PayPal', 'PhonePe', 'GooglePay']
                //               .map(
                //             (String value) {
                //               return DropdownMenuItem<String>(
                //                 value: value,
                //                 child: Text(
                //                   value,
                //                   style: TextStyle(
                //                     color: Colors.black,
                //                     fontFamily: 'Signika',
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.w600,
                //                     letterSpacing: 1.5,
                //                   ),
                //                 ),
                //               );
                //             },
                //           ).toList(),
                //           underline: Container(),
                //           // selectedItemBuilder: (BuildContext context) {
                //           //   return <String>['Paytm', 'PhonePe', 'GooglePay']
                //           //       .map<Widget>((String item) {
                //           //     return Text(item);
                //           //   }).toList();
                //           // },
                //           onChanged: (value) {
                //             setState(() {
                //               _paymentOption = value;
                //             });
                //           },
                //         ),
                //         // child: DropdownButtonFormField(
                //         //   value: 3,
                //         //   items: [
                //         //     DropdownMenuItem(
                //         //       enabled: true,
                //         //       child: Text('Pankaj'),
                //         //       value: 1,
                //         //       onTap: () {},
                //         //     ),
                //         //     DropdownMenuItem(
                //         //       enabled: true,
                //         //       child: Text('Pankaj'),
                //         //       onTap: () {},
                //         //       value: 2,
                //         //     ),
                //         //   ],
                //         // ),
                //       ),
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(8),
                //           boxShadow: const [
                //             BoxShadow(
                //               color: Color.fromRGBO(0, 0, 0, 1),
                //               blurRadius: 0.5,
                //               offset: Offset(0, 0.5),
                //             ),
                //           ],
                //         ),
                //         // padding: EdgeInsets.all(10),
                //         margin: EdgeInsets.fromLTRB(20, 15, 20, 40),
                //         child: TextFormField(
                //           decoration: InputDecoration(
                //             hintText: 'Payment ID',
                //             suffixIcon: Icon(
                //               Icons.verified_rounded,
                //               size: 24,
                //               color: Color.fromRGBO(255, 0, 0, 1),
                //             ),
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(8),
                //               borderSide: BorderSide.none,
                //             ),
                //             filled: true,
                //             fillColor: Color.fromRGBO(255, 255, 255, 1),
                //             // It also override default padding
                //             contentPadding: EdgeInsets.only(
                //               top: 20,
                //               right: 20,
                //               bottom: 15,
                //               left: 15,
                //             ),
                //           ),
                //           keyboardType: TextInputType.emailAddress,
                //           style: TextStyle(
                //             fontFamily: 'Signika',
                //             fontWeight: FontWeight.w600,
                //             letterSpacing: 1.5,
                //             fontSize: 20,
                //           ),
                //           onChanged: (value) {
                //             // email = value;
                //           },
                //           // onEditingComplete: () =>
                //           //     FocusScope.of(context).nextFocus(),
                //         ),
                //       ),

                //       // child: OutlinedButton(
                //       //   style: ButtonStyle(
                //       //     backgroundColor: MaterialStateProperty.all(
                //       //         Color.fromRGBO(255, 0, 0, 1)),
                //       //     padding: MaterialStateProperty.all(
                //       //       EdgeInsets.fromLTRB(30, 8, 30, 8),
                //       //     ),
                //       //   ),
                //       //   onPressed: () {},
                //       //   child: Text(
                //       //     'Withdraw',
                //       //     style: TextStyle(
                //       //       color: Color.fromRGBO(255, 255, 255, 1),
                //       //       fontFamily: 'Signika',
                //       //       fontWeight: FontWeight.w600,
                //       //       letterSpacing: 2,
                //       //       fontSize: 22,
                //       //     ),
                //       //   ),
                //       // ),
                //       GestureDetector(
                //         child: Container(
                //           height: 50,
                //           margin: EdgeInsets.fromLTRB(15, 5, 15, 50),
                //           padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //             color: Color.fromRGBO(230, 0, 0, 1),
                //             borderRadius: BorderRadius.circular(10),
                //             boxShadow: const [
                //               BoxShadow(
                //                 color: Color.fromRGBO(0, 0, 0, 0.35),
                //                 offset: Offset(0, 1),
                //                 blurRadius: 1,
                //               ),
                //             ],
                //           ),
                //           child: Text(
                //             'Request Cash Out',
                //             style: TextStyle(
                //               color: Color.fromRGBO(255, 255, 255, 1),
                //               fontSize: 18,
                //               fontFamily: 'Signika',
                //               fontWeight: FontWeight.w600,
                //               letterSpacing: 1.5,
                //             ),
                //           ),
                //         ),
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

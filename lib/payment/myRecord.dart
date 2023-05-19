import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:kingmaker/content/globalVariable.dart';

class MyRecord extends StatefulWidget {
  final Function pageNumberSelector;
  MyRecord(this.pageNumberSelector, {Key? key}) : super(key: key);

  @override
  _MyRecordState createState() => _MyRecordState();
}

class _MyRecordState extends State<MyRecord> {
  var _rebuildkey = 1;
  var data = [];
  var cancellingRequest = false;
  final _textStyle = TextStyle(
    fontFamily: 'Signika',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  getTime(time) {
    var tempValue = time.indexOf(',') + 5;
    return time.str(0, tempValue);
  }

  cancelRequest() async {
    setState(() {
      cancellingRequest = true;
    });
    var cancelRequest = FirebaseFunctions.instanceFor(region: 'asia-south1')
        .httpsCallable('cancelCashoutRequest');
    await cancelRequest().then(
      (value) {
        if (value.data == 'Successful') {
          _rebuildkey += 1;
          setState(() {
            cancellingRequest = false;
          });
          refreshCreatorData();
        } else {
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
        }
      },
    ).onError((error, stackTrace) {
      setState(() {
        cancellingRequest = false;
      });
    });
  }

  refreshCreatorData() {
    // It helps to refresh just after getCreatorInfo Invoked
    _refresher() {
      setState(() {
        data = creatorInfo['payoutHistory'].reversed.toList();
      });
      if (isGettingCreatorInfo) {
        Future.delayed(Duration(milliseconds: 100), () {
          _refresher();
        });
      }
    }

    getCreatorInfo();

    _refresher();
  }

  dateBeauty(value) {
    if (value.toString().length == 1) {
      return '0$value';
    } else {
      return value;
    }
  }

  @override
  void initState() {
    super.initState();
    if (creatorInfo != null) {
      data = creatorInfo['payoutHistory'].reversed.toList(); // Null Safe
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: WillPopScope(
        onWillPop: () => widget.pageNumberSelector(6),
        child: Container(
          color: Color.fromRGBO(247, 247, 247, 1),
          child: Stack(
            children: [
              ListView(
                key: Key('$_rebuildkey'),
                children: [
                  SizedBox(
                    height: 75,
                  ),
                  if (data.isEmpty)
                    Container(
                      height: MediaQuery.of(context).size.height - 180,
                      alignment: Alignment.center,
                      child: Text(
                        'No Record Found',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ...data.mapIndexed(
                    (index, element) => Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0.5),
                            blurRadius: 0.25,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: element['status'] == 'Processing'
                                  ? Color.fromRGBO(35, 15, 123, 1)
                                  : element['status'] == 'Paid'
                                      ? Color.fromRGBO(37, 211, 102, 1)
                                      : element['status'] == 'Rejected'
                                          ? Color.fromRGBO(230, 0, 0, 1)
                                          : Color.fromRGBO(52, 183, 241, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '27 Nov 2022',
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '₹${element['requestedAmount']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${element['status']}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 16,
                                      fontFamily: 'Signika',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Balance',
                                      style: _textStyle,
                                    ),
                                    Text(
                                      '${element['totalBalance']}',
                                      style: _textStyle,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Requested Amount',
                                      style: _textStyle,
                                    ),
                                    Text(
                                      '${element['requestedAmount']}',
                                      style: _textStyle,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Remaining Amount',
                                      style: _textStyle,
                                    ),
                                    Text(
                                      '${element['remainingAmount'].toStringAsFixed(2)}',
                                      style: _textStyle,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Request',
                                      style: _textStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${dateBeauty(element['requestTime'].toDate().hour)}:${dateBeauty(element['requestTime'].toDate().minute)}',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  Color.fromRGBO(220, 0, 0, 1),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '   ${dateBeauty(element['requestTime'].toDate().day)}-${dateBeauty(element['requestTime'].toDate().month)}-${element['requestTime'].toDate().year}',
                                            style: TextStyle(
                                              fontFamily: 'Signika',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // 'Completion',
                                      'Response',
                                      style: _textStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (element['completionTime'] == '--')
                                      Expanded(
                                        child: Text(
                                          element['completionTime'],
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: _textStyle,
                                        ),
                                      ),
                                    if (element['completionTime'] != '--')
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${dateBeauty(element['completionTime'].toDate().hour)}:${dateBeauty(element['completionTime'].toDate().minute)}',
                                              style: TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    220, 0, 0, 1),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '   ${dateBeauty(element['completionTime'].toDate().day)}-${dateBeauty(element['completionTime'].toDate().month)}-${element['completionTime'].toDate().year}',
                                              style: TextStyle(
                                                fontFamily: 'Signika',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Beneficiary',
                                      style: _textStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${element['paymentMethod']['fullName']}',
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: _textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Platform',
                                      style: _textStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${element['paymentMethod']['platform']}',
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: _textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ID',
                                      style: _textStyle,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${element['paymentMethod']['paymentID']}',
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: _textStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                if (index == 0 &&
                                    element['status'] == 'Processing')
                                  Center(
                                    child: Container(
                                      width: 160,
                                      margin: EdgeInsets.only(top: 25),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          if (cancellingRequest == false) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Cancel request?',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        230, 0, 0, 1),
                                                  ),
                                                ),
                                                content: Text(
                                                  'Doing so will terminate this cashout request immediately.\n\nAny subsequent request will be treated as a fresh request and will cause further delay.\n\nAre you sure to cancel?',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        35, 15, 123, 1),
                                                    fontFamily: 'Signika',
                                                    fontSize: 16,
                                                    letterSpacing: 0.75,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                actions: [
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                        fontFamily: 'Signika',
                                                        letterSpacing: 1,
                                                        color: Color.fromRGBO(
                                                            230, 0, 0, 1),
                                                      ),
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      cancelRequest();
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                        fontFamily: 'Signika',
                                                        letterSpacing: 1,
                                                        color: Color.fromRGBO(
                                                            230, 0, 0, 1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        child: cancellingRequest ||
                                                isGettingCreatorInfo
                                            ? CupertinoActivityIndicator()
                                            : Text(
                                                'Cancel Request',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      230, 0, 0, 1),
                                                  fontFamily: 'Signika',
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                if (element['status'] == 'Rejected') Divider(),
                                if (element['status'] == 'Rejected')
                                  Text(
                                    element['remarks'],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      color: Color.fromRGBO(220, 0, 0, 1),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        widget.pageNumberSelector(6);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.fromLTRB(8, 8, 0, 8),
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
                        child: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Payout History',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Signika',
                          fontSize: 22,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(230, 0, 0, 1),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 56,
                        child: Icon(
                          Icons.payments_rounded,
                          size: 34,
                          color: Color.fromRGBO(35, 15, 123, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cardiofit_dashboard/pages/admin_dashboard/doctor_view/constant.dart';
import 'dart:math' as math;

class ActiceDevice extends StatefulWidget {
  @override
  _ActiceDeviceState createState() => _ActiceDeviceState();
}

class _ActiceDeviceState extends State<ActiceDevice> {
  final hasuraService = HasuraService();
  // The following list is already sorted by id
  List<bool> _selected = [];
  List<dynamic> items = [];
  var responseval;
  var hasuraclaim;
  late final HasuraConnect _client;
  late final Snapshot _snapshot;
  Stream<dynamic>? _stream;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        await _getData(user);
      }
    });
  }

  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  Future<String> _getData(User? user) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    print("userpresent :$userDocRef");
    var userid = user.uid;
    String idTokenResult = await (user.getIdToken(true));
    print('claims : $idTokenResult.claims');
    setState(() {
      hasuraclaim = idTokenResult;
    });

    _client = HasuraConnect(
      'http://api.cardiofit.in/v1/graphql',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraclaim',
        'x-hasura-role': 'doctor',
        'x-hasura-user-id': userid
      },
    );
    final subscription = '''
      subscription MySubscription(\$_eq: String = $userid) {
  device_info(where: {attached_uid: {_eq: \$_eq},device_status: {_eq: true}}) {
    id
    device_serial
    device_name
    device_status
    created_at
  }
}
    ''';

    final finalsnapshot = await _client.subscription(subscription).then(
        (snapshot) => _stream = snapshot.map((event) => event).distinct());

    print(finalsnapshot);

    _stream!.listen((event) {
      print(event);
      if (event['data']['device_info'] is Iterable) {
        print('object is iterable');
        List<dynamic> eventData = [];
        eventData.addAll(
          (event['data']['device_info'] as Iterable).map((item) => {
                'id': item['id'],
                'device_serial': item['device_serial'],
                'device_name': item['device_name'],
                'created_at': item['created_at'],
                'device_status': item['device_status'],
              }),
        );
        print(eventData);
        setState(() {
          items.clear();
          items.addAll(eventData);
        });
      } else if (event['data']['device_info'] is Map) {
        print('object is map');
        setState(() {
          items.add({
            'id': event['data']['device_info']['id'],
            'device_serial': event['data']['device_info']['device_serial'],
            'device_name': event['data']['device_info']['device_name'],
            'created_at': event['data']['device_info']['created_at'],
            'device_status': event['data']['device_info']['device_status'],
          });
        });
      }
    });
    print(items);
    var data = '4';

    return data;
  }

  checkif() async {
    var data = '';
    if (responseval == null) {
    } else {
      setState(() {
        data = "true";
      });
    }
    await Future.delayed(Duration(seconds: 3));

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
            future: checkif(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.hasError) {
                return const Text('Error');
              } else if (dataSnapshot.hasData) {
                return ListView(
                  children: [_createDataTable()],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      sortColumnIndex: _currentSortColumn,
      sortAscending: _isSortAsc,
      headingTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.black),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
        label: Text('ID'),
        onSort: (columnIndex, _) {
          setState(() {
            _currentSortColumn = columnIndex;
            if (_isSortAsc) {
              items.sort((a, b) => b['id'].compareTo(a['id']));
            } else {
              items.sort((a, b) => a['id'].compareTo(b['id']));
            }
            _isSortAsc = !_isSortAsc;
          });
        },
      ),
      DataColumn(label: Text('Deivce Name')),
      DataColumn(label: Text('Serial Number ')),
      DataColumn(label: Text('device_status')),
      DataColumn(label: Text('Status')),
    ];
  }

  List<DataRow> _createRows() {
    return items
        .map((book) => DataRow(cells: [
              DataCell(Text('#' + book['id'].toString())),
              DataCell(Text(book['device_name'].toString())),
              DataCell(Text(book['device_serial'].toString())),
              DataCell(Text(book['device_status'].toString())),
              DataCell(Text(book['created_at'].toString())),
            ]))
        .toList();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Container(
            width: double.infinity,
            height: 200,
            color: Colors.black,
            child: SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.speed,
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Internet speed (Mbps)'))),
          ),
        );
        // AlertDialog(
        //   title: const Text('Basic dialog title'),
        //   content: const Text('A dialog is a type of modal window that\n'
        //       'appears in front of app content to\n'
        //       'provide critical information, or prompt\n'
        //       'for a decision to be made.'),
        //   actions: <Widget>[
        //     TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Disable'),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //     TextButton(
        //       style: TextButton.styleFrom(
        //         textStyle: Theme.of(context).textTheme.labelLarge,
        //       ),
        //       child: const Text('Enable'),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }

  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 42),
      LiveData(1, 47),
      LiveData(2, 43),
      LiveData(3, 49),
      LiveData(4, 54),
      LiveData(5, 41),
      LiveData(6, 58),
      LiveData(7, 51),
      LiveData(8, 98),
      LiveData(9, 41),
      LiveData(10, 53),
      LiveData(11, 72),
      LiveData(12, 86),
      LiveData(13, 52),
      LiveData(14, 94),
      LiveData(15, 92),
      LiveData(16, 86),
      LiveData(17, 72),
      LiveData(18, 94)
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}

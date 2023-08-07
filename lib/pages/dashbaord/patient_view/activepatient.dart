import 'dart:async';
import 'dart:convert';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;

class ActicePatient extends StatefulWidget {
  @override
  _ActicePatientState createState() => _ActicePatientState();
}

class _ActicePatientState extends State<ActicePatient> {
  // The following list is already sorted by i
  List<dynamic> items = [];
  List<dynamic> filteredData = [];
  var responseval;
  var hasuraclaim;
  late final HasuraConnect _client;
  Stream<dynamic>? _stream;
  final searchController = TextEditingController();
  final List<DataRow> rows = [];

  late Auth0 _auth0;
  late Auth0Web _auth0Web;

  @override
  Future<void> initState() async {
    super.initState();
    _auth0 = Auth0("dev-hfw6wda5wtf8l13c.au.auth0.com",
        "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");
    _auth0Web = Auth0Web("dev-hfw6wda5wtf8l13c.au.auth0.com",
        "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");

    Credentials _credentials =
        _auth0.credentialsManager.credentials() as Credentials;

    if (_credentials.user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
      await _getData(_credentials);
    }
  }

  // int _currentSortColumn = 0;
  // bool _isSortAsc = true;

  Future<String> _getData(Credentials credentials) async {
    final userDocRef = credentials.user;

    print("userpresent :$userDocRef");
    var userid = userDocRef.sub;
    String? idTokenResult = (credentials.idToken);
    print('$userid');
    print('claims : $idTokenResult.claims');
    setState(() {
      hasuraclaim = idTokenResult;
    });

    _client = HasuraConnect(
      'http://backend.cardiofit.in/v1/graphql',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraclaim',
      },
    );
    final subscription = '''
    subscription MySubscription {
  patient_data(where: {is_active: {_eq: "active"}, device_info: {attached_uid: {_eq: $userid}}}) {
    is_active
    weight
    uid
    name
    mobile
    id
    height
    gender
    email
    dob
    attached_device
  }
}

    ''';

    final finalsnapshot = await _client.subscription(subscription).then(
        (snapshot) => _stream = snapshot.map((event) => event).distinct());

    _stream!.listen((event) {
      print(event);
      print('////////////////');
      // var listview = json.encode(event);
      // print(listview);
      // List<dynamic> patientDataList = event['data']['device_info']
      //     .map((deviceInfo) => deviceInfo['patient_data'])
      //     .expand((patientData) => patientData)
      //     .toList();
      // print(patientDataList);
      //end
      // final List<dynamic> jsonData = event;
      String jsonString = json.encode(event);
      print('working 1');
      Map<String, dynamic> data = json.decode(jsonString);
      print('working 2 $data');
      final List<dynamic> userList = data.values.toList();
      print('working 3$userList');
      // final List<dynamic> userList = usersMap.values.toList();

      // print(usersMap);

      if (event['data']['patient_data'] is Iterable) {
        print('object is iterable');
        List<dynamic> eventData = [];
        eventData.addAll(
          (event['data']['patient_data'] as Iterable).map((item) => {
                'id': item['id'],
                'mobile': item['mobile'],
                'dob': item['dob'],
                'weight': item['weight'],
                'name': item['name'],
                'height': item['height'],
                'gender': item['gender'],
                'attached_device': item['attached_device'],
                'is_active': item['is_active'],
              }),
        );
        print(eventData);
        setState(() {
          items.clear();
          items.addAll(eventData);
          filteredData = items;
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

      // if (event['data']['patient_data'] is Iterable) {
      //   print('object is iterable');
      //   List<dynamic> eventData = [];
      //   (event['data']['patient_data'] as Iterable).forEach((device) {
      //     List<dynamic> patientData = [];
      //     (device['patient_data'] as Iterable).forEach((patient) {
      //       patientData.add({
      //         'id': patient['id'],
      //         'height': patient['height'],
      //         'mobile': patient['mobile'],
      //         'name': patient['name'],
      //         'gender': patient['gender'],
      //         'email': patient['email'],
      //         'dob': patient['dob'],
      //         'created_at': patient['created_at'],
      //         'attached_device': patient['attached_device'],
      //         'uid': patient['uid'],
      //       });
      //     });
      //     eventData.add({
      //       'device_serial': device['device_serial'],
      //       'device_name': device['device_name'],
      //       'patient_data': patientData,
      //     });
      //   });
      //   print(eventData);
      //   setState(() {
      //     items.clear();
      //     items.addAll(eventData);
      //     filteredData = items;
      //   });
      // }

      // setState(() {
      //   var itemslist = userList.map((user) => Device.fromJson(user)).toList();
      //   items.add(userList);
      //   filteredData = items;
      //   // print('items ${items.iterator.current}');
      //   // for (var device in items) {
      //   //   print('object ${device.deviceName}');
      //   //   if (device.patientData != null) {
      //   //     print('not null');
      //   //     for (var patient in device.patientData!) {
      //   //       final deviceInfo = patient.deviceInfo;
      //   //       print('deviceSerial: ${device.deviceSerial}');
      //   //       print('deviceName: ${device.deviceName}');
      //   //       print('id: ${patient.id}');
      //   //       print('height: ${patient.height}');
      //   //       print('mobile: ${patient.mobile}');
      //   //       print('name: ${patient.name}');
      //   //       print('gender: ${patient.gender}');
      //   //       print('email: ${patient.email}');
      //   //       print('dob: ${patient.dob}');
      //   //       print('createdAt: ${patient.createdAt}');
      //   //       print('attachedDevice: ${patient.attachedDevice}');
      //   //       print('uid: ${patient.uid}');
      //   //       print('deviceStatus: ${deviceInfo?.deviceStatus}');
      //   //       rows.add(DataRow(cells: [
      //   //         DataCell(Text(device.deviceSerial)),
      //   //         DataCell(Text(device.deviceName)),
      //   //         DataCell(Text(patient.id)),
      //   //         DataCell(Text(patient.height.toString())),
      //   //         DataCell(Text(patient.mobile)),
      //   //         DataCell(Text(patient.name)),
      //   //         DataCell(Text(patient.gender)),
      //   //         DataCell(Text(patient.email)),
      //   //         DataCell(Text(patient.dob)),
      //   //         DataCell(Text(patient.createdAt.toString())),
      //   //         DataCell(Text(patient.attachedDevice)),
      //   //         DataCell(Text(patient.uid)),
      //   //         DataCell(
      //   //             Text(deviceInfo?.deviceStatus.toString() ?? 'Unknown')),
      //   //       ]));
      //   //     }
      //   //   }
      //   //   print('Null');
      //   // }
      // });
      // if (event['data']['device_info']['patient_data'] is Iterable) {
      //   print('object is iterable');
      //   List<dynamic> eventData = [];
      //   eventData.addAll(
      //     (event['data']['device_info']['patient_data'] as Iterable)
      //         .map((item) => {
      //               'id': item['id'],
      //               'name': item['name'],
      //               'gender': item['gender'],
      //               'email': item['email'],
      //               'dob': item['dob'],
      //               'attached_device': item['attached_device'],
      //             }),
      //   );
      //   print(eventData);
      //   setState(() {
      //     items.clear();
      //     items.addAll(eventData);
      //   });
      // } else if (event['data']['device_info']['patient_data'] is Map) {
      //   print('object is map');
      //   setState(() {
      //     items.add({
      //       'id': event['data']['device_info']['patient_data']['id'],
      //       'device_serial': event['data']['device_info']['patient_data']
      //           ['name'],
      //       'device_name': event['data']['device_info']['patient_data']
      //           ['height'],
      //       'created_at': event['data']['device_info']['patient_data']
      //           ['gender'],
      //       'device_status': event['data']['device_info']['patient_data']
      //           ['dob'],
      //     });
      //   });
      // }
    });
    print("added item $items");
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

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? items
          : items
              .where((item) =>
                  item['name'].toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
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
                return Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _onSearchTextChanged,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Patient Name')),
                        DataColumn(label: Text('Height')),
                        DataColumn(label: Text('Number')),
                        // DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Gender')),
                        // DataColumn(label: Text('Email')),
                        DataColumn(label: Text('DOB')),
                        DataColumn(label: Text('Attached Device')),
                        DataColumn(label: Text('Device Status')),
                        DataColumn(label: Text('View Live')),
                        DataColumn(label: Text('Reports')),
                      ],
                      rows: List.generate(filteredData.length, (index) {
                        final item = filteredData[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(item['name'].toString())),
                            DataCell(Text(item['height'].toString())),
                            DataCell(Text(item['mobile'].toString())),
                            DataCell(Text(item['gender'].toString())),
                            DataCell(Text(item['dob'].toString())),
                            DataCell(Text(item['attached_device'].toString())),
                            DataCell(Text(item['is_active'].toString())),
                            // DataCell(Text(item['device_info']['patientData']
                            //         ['deviceInfo']['deviceStatus']
                            //     .toString())),
                            // DataCell(Text(item['device_info']['patientData']
                            //         ['deviceInfo']['device_serial']
                            //     .toString())),
                            // DataCell(Text(item.toString())),
                            // DataCell(Text(item['device_info']['patientData']
                            //         ['deviceInfo']['dob']
                            //     .toString())),
                            DataCell(
                              IconButton(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: const Icon(Icons.remove_red_eye_rounded),
                                onPressed: () => _dialogBuilder(context),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: const Icon(Icons.report),
                                onPressed: () => _dialogBuilder(context),
                              ),
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                ]);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  // DataTable _createDataTable() {
  //   return DataTable(
  //     columns: _createColumns(),
  //     rows: _createRows(),
  //     sortColumnIndex: _currentSortColumn,
  //     sortAscending: _isSortAsc,
  //     headingTextStyle:
  //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //     headingRowColor:
  //         MaterialStateProperty.resolveWith((states) => Colors.black),
  //   );
  // }

  // List<DataColumn> _createColumns() {
  //   return [
  //     DataColumn(
  //       label: Text('ID'),
  //       onSort: (columnIndex, _) {
  //         setState(() {
  //           _currentSortColumn = columnIndex;
  //           if (_isSortAsc) {
  //             items.sort((a, b) => b.deviceInfo[0].patientData[0].id
  //                 .compareTo(a.deviceInfo[0].patientData[0].id));
  //           } else {
  //             items.sort((a, b) => a.deviceInfo[0].patientData[0].id
  //                 .compareTo(b.deviceInfo[0].patientData[0].id));
  //           }
  //           _isSortAsc = !_isSortAsc;
  //         });
  //       },
  //     ),
  //     DataColumn(label: Text('Name and Age')),
  //     DataColumn(label: Text('Device Status')),
  //     DataColumn(label: Text('Device Serial')),
  //     DataColumn(label: Text('gender')),
  //     DataColumn(label: Text('Date of birth')),
  //     DataColumn(label: Text('Action')),
  //     DataColumn(label: Text('Reports'))
  //   ];
  // }

  // List<DataRow> _createRows() {
  //   return items
  //       .map((book) => DataRow(cells: [
  //             DataCell(
  //                 Text('#' + book.deviceInfo[0].patientData[0].id.toString())),
  //             DataCell(Text(book.deviceInfo[0].patientData[0].name.toString())),
  //             DataCell(Text(book
  //                 .deviceInfo[0].patientData[0].deviceInfo.deviceStatus
  //                 .toString())),
  //             DataCell(Text(book
  //                 .deviceInfo[0].patientData[0].deviceInfo.deviceSerial
  //                 .toString())),
  //             DataCell(
  //                 Text(book.deviceInfo[0].patientData[0].gender.toString())),
  //             DataCell(Text(book.deviceInfo[0].patientData[0].dob.toString())),
  //             DataCell(
  //               IconButton(
  //                 hoverColor: Colors.transparent,
  //                 splashColor: Colors.transparent,
  //                 icon: const Icon(Icons.remove_red_eye_rounded),
  //                 onPressed: () => _dialogBuilder(context),
  //               ),
  //             ),
  //             DataCell(
  //               IconButton(
  //                 hoverColor: Colors.transparent,
  //                 splashColor: Colors.transparent,
  //                 icon: const Icon(Icons.report),
  //                 onPressed: () => _dialogBuilder(context),
  //               ),
  //             )
  //           ]))
  //       .toList();
  // }

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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;
import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_scaffold.dart';

class ActicePatient extends StatefulWidget {
  final Credentials credentialAuth0;

  ActicePatient(this.credentialAuth0);

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
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _getData();
    _textEditingController =
        TextEditingController(text: widget.credentialAuth0.idToken.toString());
  }

  // int _currentSortColumn = 0;
  // bool _isSortAsc = true;

  Future<String> _getData() async {
    final _credentials = widget.credentialAuth0;

    print("User is signed in!${_credentials.user.sub}");

    if (_credentials.user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in what !${_credentials.user}');
    }

    final userDocRef = _credentials.user;

    print("userpresent :$userDocRef");
    var userid = userDocRef.sub;
    String? idTokenResult = (_credentials.idToken);
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
    subscription MySubscription(\$userid: String) {
    patient(where: {patient_device_info: {attached_uid: {_eq: \$userid}}, is_active: {_eq: "true"}}) {
    attached_device
    dob
    email
    gender
    height
    is_active
    mobile
    name
    uid
    weight
  }   
}''';

    final finalsnapshot = await _client.subscription(subscription, variables: {
      "userid": userid
    }).then((snapshot) => _stream = snapshot.map((event) => event).distinct());

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

      if (event['data']['patient'] is Iterable) {
        print('object is iterable');
        List<dynamic> eventData = [];
        eventData.addAll(
          (event['data']['patient'] as Iterable).map((item) => {
                'uid': item['uid'],
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

  void _showDialog(BuildContext context, String patient_uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return reportpopup(patient_uid, widget.credentialAuth0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var textFieldValue = widget.credentialAuth0.idToken;
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
            future: checkif(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.hasError) {
                return const Text('Error');
              } else if (dataSnapshot.hasData) {
                return Column(children: [
                  TextField(
                    controller: _textEditingController,
                    onChanged: (newValue) {
                      setState(() {
                        textFieldValue = newValue; // Update the value
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter text here',
                    ),
                  ),
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
                                  onPressed: () {
                                    var patient_uid = item['uid'].toString();
                                    _showDialog(context, patient_uid);
                                  }),
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

class reportpopup extends StatefulWidget {
  final String patient_uid;
  final Credentials credentialAuth0;

  reportpopup(this.patient_uid, this.credentialAuth0);

  @override
  State<reportpopup> createState() => _reportpopupState();
}

class _reportpopupState extends State<reportpopup> {
  // The following list is already sorted by i
  List<dynamic> items = [];
  List<dynamic> filteredData = [];
  var responseval;
  var hasuraclaim;
  late final HasuraConnect _client;
  Stream<dynamic>? _stream;
  final searchController = TextEditingController();
  final List<DataRow> rows = [];

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future _getData() async {
    Credentials _credentials = widget.credentialAuth0;

    print("User is signed in!${_credentials.user.sub}");

    if (_credentials.user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in what !${_credentials.user}');
    }

    final userDocRef = _credentials.user;

    print("userpresent :$userDocRef");
    var userid = userDocRef.sub;
    var patentid = widget.patient_uid;
    String? idTokenResult = (_credentials.idToken);
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
        'X-Hasura-Role': "doctor"
      },
    );
    final subscription = '''
  subscription MySubscription(\$patentid: String) {
  patient_reports(where: {uid: {_eq: \$patentid}}) {
    created_at
    patient_name
    report_url
    uid
    upload_at
    upload_by
  }
  }
''';

    final finalsnapshot = await _client.subscription(subscription, variables: {
      "patentid": patentid
    }).then((snapshot) => _stream = snapshot.map((event) => event).distinct());

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

      if (event['data']['patient_reports'] is Iterable) {
        print('object is iterable');
        List<dynamic> eventData = [];
        eventData.addAll(
          (event['data']['patient_reports'] as Iterable).map((item) => {
                'upload_by': item['upload_by'],
                'upload_at': item['upload_at'],
                'report_url': item['report_url'],
                'patient_name': item['patient_name'],
                'created_at': item['created_at'],
                'uid': item['uid'],
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
    return Center(
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder(
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
                        DataColumn(label: Text('Upload at')),
                        DataColumn(label: Text('Report Name')),
                        // DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Uploaded By')),
                        // DataColumn(label: Text('Email')),

                        DataColumn(label: Text('View')),
                      ],
                      rows: List.generate(filteredData.length, (index) {
                        final item = filteredData[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(item['patient_name'].toString())),
                            DataCell(Text(item['upload_at'].toString())),
                            DataCell(Text(item['report_url'].toString())),
                            DataCell(Text(item['upload_by'].toString())),
                            DataCell(
                              IconButton(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  icon: const Icon(Icons.report),
                                  onPressed: () {
                                    print('clicked');
                                    _getPresignedUrl(item['report_url']);
                                  }),
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

  Future<String> _getPresignedUrl(String objectKey) async {
    try {
      final result = await Amplify.Storage.getUrl(
        key: objectKey,
        options: const StorageGetUrlOptions(
          accessLevel: StorageAccessLevel.guest,
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: true,
            expiresIn: Duration(days: 1),
          ),
        ),
      ).result;

      print(result.url.toString());
      var pdfUrl = result.url.toString();

      html.window.open(pdfUrl, '_blank');
      return result.url.toString();
    } on StorageException catch (e) {
      safePrint('Could not get a downloadable URL: ${e.message}');
      rethrow;
    }
  }
}

Future<void> openPDFFromS3InNewTab(String s3Url) async {
  // Make an HTTP GET request to fetch the PDF content from the S3 URL
  http.Response response = await http.get(Uri.parse(s3Url));

  if (response.statusCode == 200) {
    Uint8List pdfBytes = response.bodyBytes;

    final blob = js.JsObject.jsify([pdfBytes]);
    final url = js.JsObject.jsify({'type': 'application/pdf', 'data': blob});
    js.context.callMethod('open', [url, '_blank']);
  } else {
    print('Failed to fetch PDF from S3. Status code: ${response.statusCode}');
  }
}

class PDFScreen extends StatelessWidget {
  final String pathPDF;

  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}

import 'dart:async';

import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_theme.dart';
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_util.dart';
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:hasura_connect/hasura_connect.dart';

import 'adddevicemodel.dart';
export 'adddevicemodel.dart';

class AddDeviceView extends StatefulWidget {
  @override
  State<AddDeviceView> createState() => _AddDeviceViewState();
}

class _AddDeviceViewState extends State<AddDeviceView> {
  late AddDeviceModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  var hasuraclaim;
  final List<dynamic> items = [];
  late final HasuraConnect _client;
  late final Snapshot _snapshot;

  Stream<dynamic>? _stream;
  List<dynamic> data = [];

  int? _sortColumnIndex;
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddDeviceModel());

    _model.textController1 ??= TextEditingController();
    _model.textController2 ??= TextEditingController();

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        await waitForCustomClaims(user);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _snapshot.close();
    _unfocusNode.dispose();
    super.dispose();
  }

  Future waitForCustomClaims(User? user) async {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    print("userpresent :$userDocRef");

    // DocumentReference userDocRef = FirebaseFirestore.instance
    //     .collection('users')
    //     .document(user.uid);
    // userDocRef.snapshots(includeMetadataChanges: false);

    // DocumentSnapshot data = await docs.firstWhere((DocumentSnapshot snapshot) =>
    //  snapshot?.data && snapshot.data. != null);
    // snapshot?.data != null && snapshot.data.containsKey('createdAt'));

    // DocumentSnapshot data = await docs.firstWhere((DocumentSnapshot snapshot) =>
    //     (snapshot.data() as Map<String, dynamic>).containsKey("createdAt") &&
    //     snapshot.data() != null);

    String? idTokenResult = await (user.getIdToken(true));
    print('claims : $idTokenResult.claims');
    setState(() {
      hasuraclaim = idTokenResult;
    });
    _subscribeToDataChanges();
  }

  _subscribeToDataChanges() async {
    _client = HasuraConnect(
      'http://api.cardiofit.in/v1/graphql',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraclaim',
        'x-hasura-role': 'admin'
      },
    );
    final subscription = '''
      subscription {
        device_info(order_by: {created_at: desc}){
           device_serial
            device_name
            created_at
            device_status
        }
      }
    ''';

    //   Snapshot snapshot = await hasuraConnect.subscription(docSubscription);
    // snapshot.listen((data) {
    //   print(data);
    // }).onError((err) {
    //   print(err);
    // });

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
            'device_serial': event['data']['device_info']['device_serial'],
            'device_name': event['data']['device_info']['device_name'],
            'created_at': event['data']['device_info']['created_at'],
            'device_status': event['data']['device_info']['device_status'],
          });
        });
      }
    });
    print(items);
    // explicitly cast to List<dynamic>

    // _snapshot = await _client.subscription(subscription);

    // _snapshot.listen((event) {
    // setState(() {
    //   items.addAll(
    //     (event['data']['device_info'] as Iterable).map((item) => {
    //           'device_serial': item['device_serial'],
    //           'device_name': item['device_name'],
    //           'created_at': item['created_at'],
    //           'device_status': item['device_status'],
    //         }),
    //   );
    // });

    // if (event['data']['device_info'] is Iterable) {
    //   setState(() {
    //     items.addAll(
    //       (event['data']['device_info'] as Iterable).map((item) => {
    //             'device_serial': item['device_serial'],
    //             'device_name': item['device_name'],
    //             'created_at': item['created_at'],
    //             'device_status': item['device_status'],
    //           }),
    //     );
    //   });
    // } else if (event['data']['device_info'] is Map) {
    //   setState(() {
    //     items.add({
    //       'device_serial': event['data']['device_info']['device_serial'],
    //       'device_name': event['data']['device_info']['device_name'],
    //       'created_at': event['data']['device_info']['created_at'],
    //       'device_status': event['data']['device_info']['device_status'],
    //     });
    //   });
    // }

    //   print('$items');
    // });

    // Snapshot snapshot = await client.subscription(subscription);
    // snapshot.listen((data) {
    //   setState(() {
    //     this.data.add(data['data']['device_info']);
    //   });
    //   print(data);
    // });
    // snapshot.listen((data) {
    //   _subscriptionData.add(data['data']['device_info']);
    // String jsonString = _convertToJsonStringQuotes(raw: encode);
    // print("Test 1: $jsonString");

    // final String result = encode.replaceAll('[', '').replaceAll(']', '');
    // print('Test 2: $result');

    // List<DeviceModule> listview = json
    //     .decode(encode)
    //     .map((data) => DeviceModule.fromJson(data))
    //     .toList();

    // var listview =
    //     DeviceModule.fromJson(jsonDecode(encode) as Map<String, dynamic>);

    // print("Test 2: ${listview.deviceInfo}");

    // setState(() {
    //   // print(data['data']);
    //   // var encode = jsonEncode(data['data']['device_info']);
    //   // print("Test 0: $encode");

    //   _subscriptionData.add(data['data']['device_info']);
    //   print('$_subscriptionData');
    // });
    // }).onError((err) {
    //   print(err);
    // });

    // subscriptioncall.stream().listen((data) {
    //   print(data);
    //   subscriptionData.add(data);
    // });

    // subscriptionData.stream.listen((data) {
    //   setState(() {
    //     _subscriptionData.add(data['data']);
    //   });
    //   print(_subscriptionData);
    // });

    // subscriptionData.stream.listen((data) {
    //   // handle subscription data here
    //   print(data['data']['device_info']);
    // });

    // Snapshot snapshot = await client.subscription(subscription);

    // snapshot.listen((data) {
    //   print(data['data']['device_info']);

    //   String responseString = "${data['data']['device_info']}";

    // Map<String, dynamic> viewlist =
    //     json.encode(data['data']) as Map<String, dynamic>;
    // print(viewlist);
    // dataList.add(data['data']['device_info'] as Map);
    // print(dataList);
    // setState(() {
    //   print('working here $data');
    //   List<DeviceModule> allMealPlanModelFromJson(String str) =>
    //       List<DeviceModule>.from(
    //           json.decode(str).map((x) => DeviceModule.fromJson(x)));

    //   dataList.add(allMealPlanModelFromJson as Map);
    //   print(dataList);
    // });

    // setState(() {
    //   print('working here $data');
    //   // List<String> categoriesList =
    //   //     List<String>.from(data['data']['device_info'] as List);
    //   var checkjson =
    //       DeviceModule.fromJson(jsonDecode(data) as Map<String, dynamic>);

    //   // print('working here $dataList');
    //   var filttermore = json.encode(checkjson);

    //   // dataList.add(data['data']['device_info'].join(", "));
    //   print('working encode $checkjson');
    //   // dataList.add(jsonData as Map);
    //   // var datalistview = jsonData;
    //   print('working decode $dataList');
    // });

    // print("streamline${dataList.length}");

    // """
    //  subscription DeviceName {
    //         device_info {
    //          device_serial
    //      device_name
    //        device_status
    //        id
    //         }
    //         }
    // """;
  }

  Future<String> finaltoken() async {
    await Future.delayed(Duration(seconds: 3));
    String finaltoken = '';
    if (hasuraclaim == null) {
      print('token is null');
    } else {
      finaltoken = hasuraclaim;
      print('tokengerated');
    }

    print("no data $finaltoken");

    return finaltoken;
  }
  // Future<void> fetchData() async {
  //   try {
  //     // var query = ("{ device_info {device_name device_serial device_status }}");

  //     var query = '''
  //             subscription DeviceName {
  //             device_info {
  //             device_serial
  //             device_name
  //             device_status
  //             id
  //             }
  //             }
  //             ''';

  //     // final result = await client.subscription(query).asStream().isBroadcast{

  //     // }
  //     subscription = client.subscription('subscription_query').asStream(() {
  //       setState(() {
  //         dataList.add(data['data']);
  //       });
  //     });

  //     print(stream);

  //     // final response = await http.post(
  //     //   Uri.parse('http://api.cardiofit.in/v1/graphql'),
  //     //   headers: {
  //     //     'Content-Type': 'application/json',
  //     //     'Authorization': 'Bearer $hasuraclaim',
  //     //     'x-hasura-role': 'admin'
  //     //   },
  //     //   body: jsonEncode({
  //     //     'query': query,
  //     //   }),
  //     // );

  //     // if (response.statusCode == 200) {
  //     //   final data = jsonDecode(response.body);
  //     //   if (data['data'] != null) {
  //     //     setState(() {
  //     //       _list = data['data']['device_info'];
  //     //     });
  //     //     print("data${data['data']['device_info']}");
  //     //   } else {
  //     //     throw Exception('GraphQL query failed: ${data['errors']}');
  //     //   }
  //     // } else {
  //     //   throw Exception('Failed to query Hasura API: ${response.statusCode}');
  //     // }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> postHasuraQuery() async {
    var devicetext = _model.textController1.text.toString();
    var deviceSerial = _model.textController2.text.toString();

    final client = HasuraConnect(
      'http://api.cardiofit.in/v1/graphql',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraclaim',
        'x-hasura-role': 'admin'
      },
    );

    final mutation = r'''
    mutation MyMutation($device_name: String!, $device_serial: String!) {
  insert_device_info_one(object: {device_name: $device_name, device_serial: $device_serial}) {
    id
    device_name
    device_serial
  }
}
  ''';

    final result = await client.mutation(
      mutation,
      variables: {'device_serial': deviceSerial, 'device_name': devicetext},
    );

    // if (result.hasErrors) {
    //   print(result.errors);
    // } else {
    //   print(result.data);
    // }

    // if (result.statusCode == 200) {
    //   final data = jsonDecode(result.body);
    //   if (data['data'] != null) {
    //     setState(() {
    //       _list = data['data']['insert_device_info_one'];
    //     });
    //     print("data${data['data']['insert_device_info_one']}");
    //   } else {
    //     throw Exception('GraphQL query failed: ${data['errors']}');
    //   }
    // } else {
    //   throw Exception('Failed to query Hasura API: ${result.statusCode}');
    // }

    // final data = result.data['insert_device_info_one'];
    // print('User added with ID: $data');
  }

  @override
  Widget build(BuildContext context) {
    return // Generated code for this Column Widget...
        FutureBuilder(
            future: finaltoken(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (dataSnapshot.connectionState == ConnectionState.done) {
                if (dataSnapshot.hasError) {
                  return const Text('Error');
                } else if (dataSnapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(30, 50, 30, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    50, 0, 50, 0),
                                child: TextFormField(
                                  controller: _model.textController1,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Device Name',
                                    hintStyle:
                                        FlutterFlowTheme.of(context).bodySmall,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                  validator: _model.textController1Validator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _model.textController2,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Device Serial',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).bodySmall,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).error,
                                      width: 1,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                validator: _model.textController2Validator
                                    .asValidator(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () {
                            print("value");
                            print(_model.textController1.text);
                            print(_model.textController2.text);
                            postHasuraQuery();

                            _model.textController1!.clear();
                            _model.textController2!.clear();
                            // fetchData();
                            // _subscribeToDataChanges();
                          },
                          text: 'Submit',
                          options: FFButtonOptions(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(40, 20, 40, 20),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {}
                          return Expanded(
                            child: ListView(
                              children: [_createDataTable()],
                            ),
                          );
                        },
                      )
                    ],
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${dataSnapshot.connectionState}');
              }
            });
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      headingTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => Colors.black),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      // DataColumn(
      //   label: Text('ID'),
      //   onSort: (columnIndex, _) {
      //     // setState(() {
      //     //   _currentSortColumn = columnIndex;
      //     //   if (_isSortAsc) {
      //     //     _books.sort((a, b) => b['id'].compareTo(a['id']));
      //     //   } else {
      //     //     _books.sort((a, b) => a['id'].compareTo(b['id']));
      //     //   }
      //     //   _isSortAsc = !_isSortAsc;
      //     // });
      //   },
      // ),
      DataColumn(label: Text('Deivce Name')),
      DataColumn(label: Text('Serial Number ')),
      DataColumn(
        label: Text('Created at'),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortColumnIndex = columnIndex;
            _sortAscending = ascending;
            if (ascending) {
              items.sort((a, b) => a['created_at'].compareTo(b['created_at']));
            } else {
              items.sort((a, b) => b['created_at'].compareTo(a['created_at']));
            }
          });
        },
      ),
      DataColumn(label: Text('Status')),
    ];
  }

  List<DataRow> _createRows() {
    return items
        .map((book) => DataRow(cells: [
              // DataCell(Text('#' + book['id'].toString())),
              DataCell(Text(book['device_name'])),
              DataCell(Text(book['device_serial'])),
              DataCell(Text(book['created_at'])),
              DataCell(Text(book['device_status'].toString())),
            ]))
        .toList();
  }

  // DataTable _createDataTable() {
  //   return DataTable(
  //     columns: _createColumns(),
  //     rows: _createRows(),
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
  //     ),
  //     DataColumn(label: Text('Deivce Name')),
  //     DataColumn(label: Text('Serial Number ')),
  //     DataColumn(label: Text('Last seen')),
  //   ];
  // }

  // List<DataRow> _createRows() {
  //   return dataList
  //       .map((book) => DataRow(cells: [
  //             DataCell(Text('#' + book['device_serial'].toString())),
  //             DataCell(Text(book['device_name'].toString())),
  //             DataCell(Text(book['device_status'].toString())),
  //             DataCell(Text(book['id'].toString())),
  //           ]))
  //       .toList();
  // }
}

class MyData extends ChangeNotifier {
  List _data = [];

  List get data => _data;

  void setData(List newData) {
    _data = newData;
    notifyListeners();
  }
}

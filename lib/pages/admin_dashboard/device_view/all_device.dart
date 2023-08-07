import 'dart:async';

import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_theme.dart';
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_util.dart';
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
  List<Map> dataList = [];
  MyData myData = MyData();
  var clientvar;
  var subvar;

  late StreamSubscription<QueryResult> subscription;

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
    return idTokenResult;
  }

  Future _subscribeToDataChanges() async {
    HasuraConnect client = HasuraConnect(
      'http://api.cardiofit.in/v1/graphql',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraclaim',
        'x-hasura-role': 'admin'
      },
    );

    final subscription = '''
      subscription {
        device_info {
           device_serial
            device_name
            device_status
            id
        }
      }
    ''';

    Snapshot<dynamic> snapshot = await client.subscription(subscription);
    snapshot.listen((data) {
      myData.setData(data['data']['device_info']);
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
    }).onError((err) {
      print(err);
    });

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

    if (result.hasErrors) {
      print(result.errors);
    } else {
      print(result.data);
    }

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

  // finaltoken() {
  //   var finaltoken = '5';
  //   if (hasuraclaim == null) {
  //     print('token is null');
  //   } else {
  //     finaltoken = hasuraclaim;
  //     print('tokengerated');
  //   }

  //   return finaltoken;
  // }

  checkhasura() async {
    // final HttpLink httpLink = HttpLink(
    //   'https://api.cardiofit.in/v1/graphql',
    // );

    // final Map<String, String> headers = {
    //   'Authorization': 'Bearer $hasuraclaim',
    //   'x-hasura-role': 'admin',
    // };

    // final AuthLink authLink = AuthLink(
    //   getToken: () async => 'Bearer $hasuraclaim',
    // );

    // final WebSocketLink webSocketLink = WebSocketLink(
    //   'https://api.cardiofit.in/v1/graphql',
    //   config: SocketClientConfig(
    //       autoReconnect: true,
    //       inactivityTimeout: Duration(seconds: 30),
    //       initialPayload: () => {
    //             'headers': {
    //               'Content-Type': 'application/json',
    //               'Authorization': 'Bearer $hasuraclaim',
    //               'x-hasura-role': 'admin'
    //             },
    //           }),
    // );

    // final WebSocketLink websocketLink = WebSocketLink(
    //   'wss://api.cardiofit.in/v1/graphql',
    //   config: SocketClientConfig(
    //     initialPayload: () => {
    //       'headers': {
    //         'Content-Type': 'application/json',
    //         'Authorization': 'Bearer $hasuraclaim',
    //         'x-hasura-role': 'admin'
    //       },
    //     },
    //   ),
    //   headers: {
    //     'Authorization': 'Bearer <your Hasura JWT token>',
    //   },
    // );

    // final Link link = httpLink.concat(websocketLink);

    // final GraphQLClient client = GraphQLClient(
    //   cache: GraphQLCache(),
    //   link: link,
    // );

    // final HttpLink httpLink =
    //     HttpLink('http://api.cardiofit.in/v1/graphql', defaultHeaders: {});

    // final WebSocketLink webSocketLink = WebSocketLink(
    //   'ws://api.cardiofit.in/v1/graphql',
    //   // config: SocketClientConfig(
    //   //   autoReconnect: true,
    //   //   inactivityTimeout: Duration(seconds: 30),
    //   //   initialPayload: () async {
    //   //     return {
    //   //       'Content-Type': 'application/json',
    //   //       'Authorization': 'Bearer $hasuraclaim',
    //   //       'x-hasura-role': 'admin'
    //   //     };
    //   //   },
    //   // ),
    // );

    final client = HasuraConnect(
      'http://api.cardiofit.in/v1/graphql',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraclaim',
        'x-hasura-role': 'admin'
      },
    );

    // final GraphQLClient client = GraphQLClient(
    //   cache: GraphQLCache(),
    //   link: link,
    // );

    final subscriptionQuery = gql('''
  subscription DeviceName {
  device_info {
    device_serial
    device_name
    device_status
    id
  }
}

''');

    // Future<Snapshot> snapshot = client.subscription(subscriptionQuery);
    // snapshot.listen((data) {
    //   print(data);
    // }).onError((err) {
    //   print(err);
    // });
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: finaltoken(), // async work
      builder: (BuildContext context, dataSnapshot) {
        switch (dataSnapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            if (dataSnapshot.hasError)
              return Text('Error:');
            else
              checkhasura();
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
                          padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 0),
                          child: TextFormField(
                            controller: _model.textController1,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: 'Device Name',
                              hintStyle: FlutterFlowTheme.of(context).bodySmall,
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
                                  color: FlutterFlowTheme.of(context).primary,
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
                            hintStyle: FlutterFlowTheme.of(context).bodySmall,
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
                                color: FlutterFlowTheme.of(context).primary,
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

                      // _model.textController1!.clear();
                      // _model.textController2!.clear();
                      // fetchData();
                    },
                    text: 'Submit',
                    options: FFButtonOptions(
                      padding: EdgeInsetsDirectional.fromSTEB(40, 20, 40, 20),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
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
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: dataList.length,
                //     itemBuilder: (context, index) {
                //       final item = dataList[index];
                //       return ListTile(
                //         title: Text(item["device_serial"]),
                //         subtitle: Text(item["device_name"]),
                //       );
                //     },
                //   ),
                // )

                // Expanded(
                //   child: StreamBuilder<List<dynamic>>(
                //     stream: _stream,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasError) {
                //         return Text('Error: ${snapshot.error}');
                //       }
                //       if (!snapshot.hasData) {
                //         return Center(child: CircularProgressIndicator());
                //       }
                //       final data = snapshot.data!;
                //       return ListView.builder(
                //         itemCount: data.length,
                //         itemBuilder: (context, index) {
                //           final item = data[index];
                //           return ListTile(
                //             title: Text(item['device_serial']),
                //             subtitle: Text(item['device_name']),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),

                // Expanded(
                //   child: ListView(
                //     children: [_createDataTable()],
                //   ),
                // )
                //   ListView.builder(
                //     itemCount: dataList.length,
                //     itemBuilder: (BuildContext context, index) {
                //       final item = dataList[index];
                //       return Padding(
                //         padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                //         child: Column(
                //           children: [
                //             Row(
                //               mainAxisSize: MainAxisSize.max,
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Expanded(
                //                   child: Column(
                //                     mainAxisSize: MainAxisSize.max,
                //                     children: [
                //                       Text(
                //                         item['device_serial'].toString(),
                //                         style: FlutterFlowTheme.of(context)
                //                             .bodyMedium
                //                             .override(
                //                               fontFamily: 'Poppins',
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.bold,
                //                             ),
                //                       ),
                //                       Text(
                //                         dataList[index].deviceInfo[index].deviceName,
                //                         style: FlutterFlowTheme.of(context)
                //                             .bodyMedium
                //                             .override(
                //                               fontFamily: 'Poppins',
                //                               fontSize: 12,
                //                             ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Expanded(
                //                   child: Text(
                //                     dataList[index].deviceInfo[index].deviceSerial,
                //                     textAlign: TextAlign.center,
                //                     style: FlutterFlowTheme.of(context).bodyMedium,
                //                   ),
                //                 ),
                //               ],
                //             )
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // ChangeNotifierProvider<MyData>(
                //   create: (context) => myData,
                //   child: Expanded(
                //     child: ListView.builder(
                //       itemCount: myData.data.length,
                //       itemBuilder: (context, index) {
                //         return ListTile(
                //           title: Text(myData.data[index]['device_name']),
                //           subtitle: Text(myData.data[index]['device_serial']),
                //         );
                //       },
                //     ),
                //   ),
                // )
              ],
            );
        }
      },
    ); // Generated code for this Column Widget...
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

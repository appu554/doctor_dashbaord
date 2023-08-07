
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_theme.dart';
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_widgets.dart';
import 'package:cardiofit_dashboard/pages/admin_dashboard/doctor_view/constant.dart';
import 'package:flutter/material.dart';

class ViweAllDoctor extends StatefulWidget {
  @override
  State<ViweAllDoctor> createState() => _ViweAllDoctorState();
}

class _ViweAllDoctorState extends State<ViweAllDoctor> {
  final hasuraService = HasuraService();
  List<dynamic> items = [];
  int? _sortColumnIndex;
  bool _sortAscending = false;
  var responseval;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _getData() async {
    try {
      final response = await hasuraService.query('''
        query MyQuery {
          user_data(where: {user_role: {_eq: "doctor"}}) {
          name
          number
          uid
          email
          device_infos {
              device_serial
            }
          }
        }
      ''');

      // Use the response data here
      print(response);

      //add user
      final jsonString = response['data']['user_data'];
      // final List<dynamic> dataList = jsonString as List;
      // List<String> stringList = dataList.cast<String>().toList();

      setState(() {
        items = jsonString;
        responseval = jsonString;
      });
      print("Added list $items");
    } catch (e) {
      // Handle any errors here
      print(e);
    }

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
    return FutureBuilder(
        future: checkif(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.hasError) {
            return const Text('Error');
          } else if (dataSnapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [_createDataTable()],
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
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
      DataColumn(label: Text('Doctor Name')),
      DataColumn(label: Text('Address')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('UID')),
      // DataColumn(
      //   label: Text('Created at'),
      //   onSort: (columnIndex, ascending) {
      //     setState(() {
      //       _sortColumnIndex = columnIndex;
      //       _sortAscending = ascending;
      //       if (ascending) {
      //         items.sort((a, b) => a['created_at'].compareTo(b['created_at']));
      //       } else {
      //         items.sort((a, b) => b['created_at'].compareTo(a['created_at']));
      //       }
      //     });
      //   },
      // ),
      DataColumn(label: Text('Attached Device')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createRows() {
    return items
        .map(
          (book) => DataRow(cells: [
            // DataCell(Text('#' + book['id'].toString())),
            DataCell(Text(book['name'].toString())),
            DataCell(Text(book['number'].toString())),
            DataCell(Text(book['email'].toString())),
            DataCell(Text(book['uid'].toString())),
            DataCell(FFButtonWidget(
              onPressed: () async {
                print('Button pressed ...');
              },
              text: 'View',
              options: FFButtonOptions(
                width: 130,
                height: 40,
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            )),
            DataCell(FFButtonWidget(
              onPressed: () async {
                print('Button pressed ...');
              },
              text: 'Edit',
              options: FFButtonOptions(
                width: 130,
                height: 40,
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            )),
          ]),
        )
        .toList();
  }
}

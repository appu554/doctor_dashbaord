import 'package:auth0_flutter_platform_interface/src/credentials.dart';
import 'package:cardiofit_dashboard/flutter_flow/flutter_flow_theme.dart';
import 'package:cardiofit_dashboard/responsive.dart';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';

class DashboardView extends StatefulWidget {
  final Credentials credentialAuth0;

  DashboardView(this.credentialAuth0);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final String getDeviceAndPatientCounts = '''
  query MyQuery(\$attachedUid: String!) {
    patient_aggregate(where: {patient_device_info: {attached_uid: {_eq: \$attachedUid}}}) {
      aggregate {
        count
      }
    }
    device_info_aggregate(where: {attached_uid: {_eq: \$attachedUid}, }) {
      aggregate {
        count
      }
    }
  }
  ''';

  late final HasuraConnect hasuraConnect;

  @override
  void initState() {
    super.initState();
    final _credentials = widget.credentialAuth0.idToken;
    hasuraConnect = HasuraConnect('http://backend.cardiofit.in/v1/graphql',
        headers: {
          "Authorization": "Bearer $_credentials",
          "x-hasura-role": "doctor"
        });
  }

  Future<Map<String, dynamic>> fetchData() async {
    final _credentials = widget.credentialAuth0;
    final userId = _credentials.user.sub;
    var response = await hasuraConnect
        .query(getDeviceAndPatientCounts, variables: {"attachedUid": userId});
    return response['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (Responsive.isDesktop(context))
        FutureBuilder<Map<String, dynamic>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final int patientCount = snapshot.data?['patient_aggregate']
                      ['aggregate']['count'] ??
                  0;
              final int deviceCount = snapshot.data?['device_info_aggregate']
                      ['aggregate']['count'] ??
                  0;

              return Center(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Color(0xFFE3F5FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Patients ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 20, 0, 0),
                                  child: Text(
                                    patientCount.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Color(0xFFE3F5FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Device ',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 20, 0, 0),
                                    child: Text(
                                      deviceCount.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      if (Responsive.isMobile(context))
        Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 30),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F5FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Device ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Text(
                              '20',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFE3F5FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Patients ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Text(
                                '20',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFFE3F5FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Patients ',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Text(
                              '20',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
    ]);
  }
}

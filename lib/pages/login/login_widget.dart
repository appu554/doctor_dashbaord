import 'dart:async';

import 'package:cardiofit_dashboard/pages/admin_dashboard/admin_dashboard.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/dashboard.dart';
import 'package:cardiofit_dashboard/screens/main/main_screen.dart';
import 'package:cardiofit_dashboard/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  ThemeMode _mode = ThemeMode.dark;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _userSignedIn = false;
  final Authentication _authentication = Authentication();
  var hasuraToken;

  @override
  void initState() {
    super.initState();

    /// Events are fired when the following occurs:
    /// - Right after the listener has been registered.
    /// - When a user is signed in.
    /// - When the current user is signed out.
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
        setState(() => _userSignedIn = false);
      } else {
        print('User is signed in!');
        // Timer.periodic(Duration(seconds: 20), (timer) async {
        //   var result = (await (user.getIdToken(true)));
        //   print('claims : $result');
        //   print(DateTime.now());
        // });

        // await waitForCustomClaims(user);
        setState(() {
          // hasuraToken = token;
        });
        String userid = user.uid;
        print(userid);
        print(user.displayName);

        if (user.displayName!.contains("admin")) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminDashBoardExample(
                      onModeChanged: (value) {
                        setState(() {
                          _mode = value;
                        });
                      },
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DashBoardExample(
                      onModeChanged: (value) {
                        setState(() {
                          _mode = value;
                        });
                      },
                    )),
          );
        }

        // print("claim:$token");
        // generateJWT();
        // queryHasuraGraphQL();
        setState(
          () => _userSignedIn = true,
        );
      }
    });
  }

  // Query Hasura GraphQL endpoint
  Future<http.Response> queryHasuraGraphQL() async {
    var user = FirebaseAuth.instance.currentUser;
    final IdTokenResult idTokenResult = await user!.getIdTokenResult();
    final String? token = idTokenResult.token;
    final hasuraToken = token;

    var query =
        ("{ user_data { address email name number password uid user_role}}");

    final response = await http.post(
      Uri.parse("https://api.cardiofit.in/v1/graphql"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $hasuraToken',
      },
      body: jsonEncode(<String, dynamic>{
        'query': query,
      }),
    );

    print(response.body);
    return response;
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF4B39EF),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(100.0, 70.0, 100.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Status: ${_userSignedIn ? "Signed In" : "Signed Out"}",
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 20,
                    ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 60.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/template-screens-hpce0u/assets/xofl99y11az0/@3xlogo_primary_color_white.png',
                      width: 240.0,
                      height: 60.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                      child: TextFormField(
                        controller: _emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          hintText: 'Enter your email...',
                          hintStyle:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 24.0, 20.0, 24.0),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF0F1113),
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                        maxLines: null,
                        // validator: _model.emailAddressCreateControllerValidator
                        //     .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 0.0),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          hintText: 'Enter your password...',
                          hintStyle:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              20.0, 24.0, 20.0, 24.0),
                          // suffixIcon: InkWell(
                          //   onTap: () => setState(
                          //     () => _model.passwordCreateVisibility =
                          //         !_model.passwordCreateVisibility,
                          //   ),
                          //   focusNode: FocusNode(skipTraversal: true),
                          //   child: Icon(
                          //     _model.passwordCreateVisibility
                          //         ? Icons.visibility_outlined
                          //         : Icons.visibility_off_outlined,
                          //     color: Color(0xFF57636C),
                          //     size: 20.0,
                          //   ),
                          // ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: Color(0xFF0F1113),
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                        // validator: _model.passwordCreateControllerValidator
                        // .asValidator(context),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () {
                          // _signUpPressed();
                        },
                        text: 'Sigin up',
                        options: FFButtonOptions(
                          width: 230.0,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Colors.white,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () {
                          _signInPressed();
                        },
                        text: 'login',
                        options: FFButtonOptions(
                          width: 230.0,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Colors.white,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () {
                          _signOutPressed();
                        },
                        text: 'Sign out',
                        options: FFButtonOptions(
                          width: 230.0,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: Colors.white,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF4B39EF),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                          elevation: 3.0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
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

  // void _signUpPressed() async {
  //   _authentication.signUp(
  //     _emailController.text.trim(),
  //     _passwordController.text.trim(),

  //   );
  // }

  void _signInPressed() async {
    _authentication.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  void _signOutPressed() async {
    _authentication.signOut();
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

    String idTokenResult = await (user.getIdToken(true));
    print('claims : $idTokenResult.claims');
  }
}

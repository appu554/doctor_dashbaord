
import 'package:cardiofit_dashboard/pages/admin_dashboard/doctor_view/constant.dart';
import 'package:cardiofit_dashboard/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'add_doctor_model.dart';
export 'add_doctor_model.dart';

class AddDorctorWidget extends StatefulWidget {
  const AddDorctorWidget({Key? key}) : super(key: key);

  @override
  _AddDorctorWidgetState createState() => _AddDorctorWidgetState();
}

class _AddDorctorWidgetState extends State<AddDorctorWidget> {
  late AddDoctorModel _model;
  List<String> yourData = [];
  var deviceinfo;
  var finaldevice = [];
  ThemeMode _mode = ThemeMode.dark;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  final hasuraService = HasuraService();
  bool _isDataLoaded = false;
  final Authentication _authentication = Authentication();

  bool _isVisible = true;

  void _toggleVisibility() {}

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddDoctorModel());

    _model.textController1 ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
    _model.textController3 ??= TextEditingController();
    _model.textController4 ??= TextEditingController();
    _model.textController5 ??= TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getData();
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  Future<String> _getData() async {
    try {
      final response = await hasuraService.query('''
        query MyQuery {
            device_info(where: {attached_uid: {_is_null: true}}) {
            created_at
            device_name
            device_serial
            device_status
            id
          }
        }
      ''');

      final List<dynamic> dataList = response['data']['device_info'];
      final List<String> stringList =
          dataList.map((item) => item['device_serial'] as String).toList();

      // Use the response data here
      print(response);
      setState(() {
        yourData = stringList;
      });
    } catch (e) {
      // Handle any errors here
      print(e);
    }

    List<DeviceName> devices = List<DeviceName>.generate(
      yourData.length,
      (index) => DeviceName(
        name: yourData[index],
        iso: yourData[index].substring(0, 2),
      ),
    );

    deviceinfo = devices;
    print(yourData);

    var data = '4';

    return data;
  }

  checkif() async {
    var data = '';
    if (deviceinfo == null) {
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
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Color(0xFFF7F9FB),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(20, 30, 20, 0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1EFEF),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 50, 0, 0),
                                    child: Text(
                                      'Create an account',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 30, 30, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 30, 0),
                                            child: TextFormField(
                                              controller:
                                                  _model.textController1,
                                              autofocus: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Doctor\'s Email ID',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                              validator: _model
                                                  .textController1Validator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _model.textController2,
                                            autofocus: true,
                                            obscureText:
                                                !_model.passwordVisibility1,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Password',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              suffixIcon: InkWell(
                                                onTap: () => setState(
                                                  () => _model
                                                          .passwordVisibility1 =
                                                      !_model
                                                          .passwordVisibility1,
                                                ),
                                                focusNode: FocusNode(
                                                    skipTraversal: true),
                                                child: Icon(
                                                  _model.passwordVisibility1
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            validator: _model
                                                .textController2Validator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 50, 0, 0),
                                    child: Text(
                                      'Add Info',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Poppins',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 30, 30, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 30, 0),
                                            child: TextFormField(
                                              controller:
                                                  _model.textController3,
                                              autofocus: true,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Name',
                                                hintStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .accent1,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0x00000000),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0),
                                                  ),
                                                ),
                                              ),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                              validator: _model
                                                  .textController3Validator
                                                  .asValidator(context),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _model.textController4,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText: 'Mobile Number',
                                              hintStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .accent1,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            validator: _model
                                                .textController4Validator
                                                .asValidator(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 30, 30, 0),
                                    child: TextFormField(
                                      controller: _model.textController5,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Add Address',
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .accent1,
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
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      validator: _model.textController5Validator
                                          .asValidator(context),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 30, 30, 0),
                                    child: MultipleSearchSelection<
                                        DeviceName>.creatable(
                                      title: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          'Add devices to this doctor',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                      onItemAdded: (c) {
                                        finaldevice.add(c.name);
                                        print("added ${c.name}");
                                      },
                                      onItemRemoved: (c) {
                                        finaldevice.remove(c.name);
                                        print('removed${c.name}');
                                      },
                                      showClearSearchFieldButton: true,
                                      createOptions: CreateOptions(
                                        createItem: (text) {
                                          return DeviceName(
                                              name: text, iso: text);
                                        },
                                        onItemCreated: (c) =>
                                            print('Country ${c.name} created'),
                                        createItemBuilder: (text) => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Not found "$text"'),
                                          ),
                                        ),
                                        pickCreatedItem: false,
                                      ),
                                      items: deviceinfo, // List<Country>
                                      fieldToCheck: (c) {
                                        return c.name;
                                      },
                                      itemBuilder: (country, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 20.0,
                                                horizontal: 12,
                                              ),
                                              child: Text(country.name),
                                            ),
                                          ),
                                        );
                                      },

                                      pickedItemBuilder: (country) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.grey[400]!),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(country.name),
                                          ),
                                        );
                                      },

                                      sortShowedItems: true,
                                      sortPickedItems: true,
                                      selectAllButton: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.blue),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Select All',
                                              style: kStyleDefault,
                                            ),
                                          ),
                                        ),
                                      ),

                                      clearAllButton: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.red),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Clear All',
                                              style: kStyleDefault,
                                            ),
                                          ),
                                        ),
                                      ),

                                      caseSensitiveSearch: false,
                                      fuzzySearch: FuzzySearch.none,
                                      itemsVisibility:
                                          ShowedItemsVisibility.alwaysOn,
                                      showSelectAllButton: true,
                                      maximumShowItemsHeight: 200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              register(_model.textController1.text,
                                  _model.textController2.text);

                              print('Button pressed ...');
                            },
                            text: 'Add Doctor',
                            options: FFButtonOptions(
                              width: 130,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future register(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      print('New user created with email: ${user!.email}');
      print('User ID: ${user.uid}');
      user.updateDisplayName('doctor');
      print('User role: ${user.displayName}');
      var useremail = user.email;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Newdocotruid', user.uid);
      prefs.setString('Newdocotremail', useremail!);

      print("Getting from saved${prefs.getString('Newdocotruid')}");
      print("Getting from saved ${prefs.getString('Newdocotremail')}");

      if (user.uid == null) {
      } else {
        postusertohasura();
      }
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided for that user.");
      } else {
        print("An error occurred: \"${e.message}\"");
      }
    }

    await app.delete();
  }

  Future postusertohasura() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = _model.textController3.text;
    var uuid = prefs.getString('Newdocotruid').toString();
    var useremail = prefs.getString('Newdocotremail').toString();
    var userrole = 'doctor';
    var password = _model.textController2.text;
    var address = _model.textController4.text;
    var number = _model.textController5.text;
    try {
      final result = await hasuraService.createRecord(
          username, useremail, uuid, userrole, password, address, number);
      print(result);

      if (result.isEmpty) {
        print("empty");
      } else {
        print("done");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor Created')),
        );
        postdevicetohasura();
      }
    } catch (e) {
      print(e);
    }
  }

  Future postdevicetohasura() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = prefs.getString('Newdocotruid').toString();
    List<String> stringList = finaldevice.cast<String>().toList();
    try {
      final result = await hasuraService.updateRecord(uuid, stringList);
      print(result);

      if (result.isEmpty) {
        print("empty");
      } else {
        print("done");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successful Added Device')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddDorctorWidget()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}

class DeviceName {
  final String name;
  final String iso;

  const DeviceName({
    required this.name,
    required this.iso,
  });
}

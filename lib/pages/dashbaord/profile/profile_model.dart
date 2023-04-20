import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for yourName widget.
  TextEditingController? yourNameController1;
  String? Function(BuildContext, String?)? yourNameController1Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController2;
  String? Function(BuildContext, String?)? yourNameController2Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController3;
  String? Function(BuildContext, String?)? yourNameController3Validator;
  // State field(s) for yourName widget.
  TextEditingController? yourNameController4;
  String? Function(BuildContext, String?)? yourNameController4Validator;
  // State field(s) for myBio widget.
  TextEditingController? myBioController;
  String? Function(BuildContext, String?)? myBioControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    yourNameController1?.dispose();
    yourNameController2?.dispose();
    yourNameController3?.dispose();
    yourNameController4?.dispose();
    myBioController?.dispose();
  }

  /// Additional helper methods are added here.
}

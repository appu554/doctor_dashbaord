import 'package:cardiofit_dashboard/controllers/MenuAppController.dart';
import 'package:cardiofit_dashboard/responsive.dart';
import 'package:cardiofit_dashboard/screens/dashboard/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainPatient extends StatefulWidget {
  @override
  State<MainPatient> createState() => _MainPatientState();
}

class _MainPatientState extends State<MainPatient> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MyMainPatient(),
    );
  }
}

class MyMainPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: Patientview(),
            ),
          ],
        ),
      ),
    );
  }
}

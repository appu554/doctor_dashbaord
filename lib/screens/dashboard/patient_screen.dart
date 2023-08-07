import 'package:cardiofit_dashboard/responsive.dart';
import 'package:cardiofit_dashboard/screens/dashboard/components/patientlist.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

class Patientview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      PatientListView(),
                      if (Responsive.isMobile(context)) PatientListView(),
                      SizedBox(height: defaultPadding),

                      // RecentFiles(),
                      // if (Responsive.isMobile(context))
                      //   SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

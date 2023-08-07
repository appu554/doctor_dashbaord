import 'package:cardiofit_dashboard/index.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/components/dashboard.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/deivice_view/active_device.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/deivice_view/all_devices.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/patient_view/activepatient.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/patient_view/allpatient.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/profile/profile.dart';
import 'package:cardiofit_dashboard/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:ready/ready.dart';


class DashBoardExample extends StatelessWidget {
  final ValueChanged<ThemeMode> onModeChanged;
  DashBoardExample({Key? key, required this.onModeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReadyDashboard(
      currentUser: const CurrentUser.admin(),
      drawerOptions: (phone) => DrawerOptions(
        headers: (ctrl) => [
          const DrawerHeader(child: CircleAvatar()),
          Builder(builder: (context) {
            var isDark = Theme.of(context).brightness == Brightness.dark;
            return CheckboxListTile(
              title: const Text('Dr Apoorva'),
              onChanged: (bool? value) {
                onModeChanged(isDark ? ThemeMode.light : ThemeMode.dark);
              },
              value: isDark,
            );
          }),
          const Divider()
        ],
        footer: (ctrl) => [
          const Align(
            alignment: AlignmentDirectional.bottomStart,
            child: ListTile(
              title: Text('© cardiofit @ 2023'),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notification_add),
        ),
      ],
      items: [
        DashboardItem(
          builder: (Map<String, dynamic> parameters) {
            return DashboardView();
          },
          icon: const Icon(Icons.animation_rounded),
          id: 'animated2',
          label: 'Dashboard',
        ),
        DashboardItem.items(
          icon: const Icon(Icons.personal_injury),
          label: 'Patient',
          subItems: [
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return ActicePatient();
              },
              icon: const Icon(Icons.table_chart),
              id: 'active patient',
              label: 'Active Patient',
            ),
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return AllPatient();
              },
              icon: const Icon(Icons.local_cafe),
              id: 'all patient',
              label: 'All Patient',
            ),
          ],
        ),
        DashboardItem.items(
          icon: const Icon(Icons.device_hub),
          label: 'Device',
          subItems: [
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return ActiceDevice();
              },
              icon: const Icon(Icons.table_chart),
              id: 'active device',
              label: 'Active Device',
            ),
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return AllDevice();
              },
              icon: const Icon(Icons.local_cafe),
              id: 'all device',
              label: 'All Device',
            ),
          ],
        ),
        DashboardItem(
          builder: (Map<String, dynamic> parameters) {
            return const ProfileWidget();
          },
          icon: const Icon(Icons.person),
          id: 'profile',
          label: 'Profile',
        ),
        DashboardItem(
          builder: (Map<String, dynamic> parameters) {
            return DialogFb1();
          },
          icon: const Icon(Icons.logout),
          id: 'logout',
          label: 'Logout',
        ),

        // Call this in a function
// ()=> showDialog<Dialog>(context: context, builder: (BuildContext context) => DialogFb1())
        // DashboardItem(
        //   builder: (Map<String, dynamic> parameters) {
        //     return const AnimatedItemsExample();
        //   },
        //   authorization: Authorization(types: [
        //     AccessType.supervisor(const ['user'])
        //   ]),
        //   icon: const Icon(Icons.animation),
        //   id: 'animated',
        //   label: 'Animated items',
        // ),
        // DashboardItem(
        //   builder: (Map<String, dynamic> parameters) {
        //     return const AnimatedScopeItemsExample();
        //   },
        //   icon: const Icon(Icons.animation_rounded),
        //   id: 'animated2',
        //   label: 'Animated scope items',
        // ),
        // DashboardItem(
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.message),
        //     )
        //   ],
        //   builder: (Map<String, dynamic> parameters) {
        //     return Builder(
        //       builder: (context) {
        //         return CustomScrollView(
        //           slivers: [
        //             SliverOverlapInjector(
        //                 handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
        //                     context)),
        //             const SliverToBoxAdapter(child: Text('App bar actions')),
        //             const SliverToBoxAdapter(child: TextField())
        //           ],
        //         );
        //       },
        //     );
        //   },
        //   icon: const Icon(Icons.attractions),
        //   id: 'actions',
        //   label: 'App bar actions',
        // ),
        // DashboardItem(
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(Icons.message),
        //     )
        //   ],
        //   builder: (Map<String, dynamic> parameters) {
        //     return Builder(
        //       builder: (context) {
        //         return CustomScrollView(
        //           slivers: [
        //             SliverOverlapInjector(
        //                 handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
        //                     context)),
        //             const SliverToBoxAdapter(
        //                 child: Text('Override app bar actions')),
        //           ],
        //         );
        //       },
        //     );
        //   },
        //   icon: const Icon(Icons.attractions),
        //   id: 'actions2',
        //   overrideActions: true,
        //   label: 'Override app bar actions',
        // ),
        // DashboardItem(
        //   builder: (Map<String, dynamic> parameters) {
        //     return const ReadyListExample(
        //       shimmer: false,
        //     );
        //   },
        //   icon: const Icon(Icons.list),
        //   id: 'list1',
        //   label: 'List',
        // ),
        // DashboardItem(
        //   builder: (Map<String, dynamic> parameters) {
        //     return const ReadyListExample(shimmer: true);
        //   },
        //   icon: const Icon(Icons.list),
        //   id: 'list2',
        //   label: 'List with shimmer',
        // ),
        // DashboardItem.items(
        //   icon: const Icon(Icons.category),
        //   label: 'Grid',
        //   subItems: [
        //     DashboardItem(
        //       builder: (Map<String, dynamic> parameters) {
        //         return const ReadyGridExample(gridDelegate: Grids.columns_1);
        //       },
        //       icon: const Icon(Icons.local_cafe),
        //       id: 'grid 1',
        //       label: 'Grid 1',
        //     ),
        //     DashboardItem(
        //       builder: (Map<String, dynamic> parameters) {
        //         return const ReadyGridExample(gridDelegate: Grids.columns_2);
        //       },
        //       icon: const Icon(Icons.local_cafe),
        //       id: 'grid 2',
        //       label: 'Grid 2',
        //     ),
        //     DashboardItem(
        //       builder: (Map<String, dynamic> parameters) {
        //         return const ReadyGridExample(gridDelegate: Grids.columns_3);
        //       },
        //       icon: const Icon(Icons.local_cafe),
        //       id: 'grid 3',
        //       label: 'Grid 3',
        //     ),
        //     DashboardItem(
        //       builder: (Map<String, dynamic> parameters) {
        //         return const ReadyGridExample(gridDelegate: Grids.columns_4);
        //       },
        //       icon: const Icon(Icons.local_cafe),
        //       id: 'grid 4',
        //       label: 'Grid 4',
        //     ),
        //     DashboardItem(
        //       builder: (Map<String, dynamic> parameters) {
        //         return ReadyGridExample(gridDelegate: Grids.extent(150));
        //       },
        //       icon: const Icon(Icons.local_cafe),
        //       id: 'extent grid',
        //       label: 'Extent grid',
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class DialogFb1 extends StatelessWidget {
  DialogFb1({Key? key}) : super(key: key);
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);
  final Authentication _authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 25,
              child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/FlutterBricksLogo-Med.png?alt=media&token=7d03fedc-75b8-44d5-a4be-c1878de7ed52"),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Are you sure ?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 3.5,
            ),
            const Text("This is a sub text, use it to clarify",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w300)),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SimpleBtn1(
                    text: "yes",
                    onPressed: () {
                      _authentication.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginWidget()),
                      );
                    }),
                SimpleBtn1(
                  text: "No",
                  onPressed: () {},
                  invertedColors: true,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false,
      Key? key})
      : super(key: key);
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}

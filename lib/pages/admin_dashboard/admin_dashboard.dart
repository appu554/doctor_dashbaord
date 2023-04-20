import 'package:cardiofit_dashboard/pages/admin_dashboard/components/admin_view_dashboard.dart';
import 'package:cardiofit_dashboard/pages/admin_dashboard/device_view/add_device.dart';
import 'package:cardiofit_dashboard/pages/admin_dashboard/doctor_view/All_doctor_view.dart';
import 'package:cardiofit_dashboard/pages/admin_dashboard/doctor_view/add_doctor.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/components/animated_items.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/components/dashboard.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/components/ready_grid.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/deivice_view/active_device.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/patient_view/activepatient.dart';
import 'package:cardiofit_dashboard/pages/dashbaord/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:ready/ready.dart';

class AdminDashBoardExample extends StatelessWidget {
  final ValueChanged<ThemeMode> onModeChanged;
  const AdminDashBoardExample({Key? key, required this.onModeChanged})
      : super(key: key);

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
              title: const Text('Dear Admin'),
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
            return AdminDashboardView();
          },
          icon: const Icon(Icons.animation_rounded),
          id: 'animated2',
          label: 'Dashboard',
        ),
        DashboardItem.items(
          icon: const Icon(Icons.personal_injury),
          label: 'Doctor',
          subItems: [
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return AddDorctorWidget();
              },
              icon: const Icon(Icons.table_chart),
              id: 'add doctor',
              label: 'Add Doctor',
            ),
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return ViweAllDoctor();
              },
              icon: const Icon(Icons.local_cafe),
              id: 'all Doctor',
              label: 'All Doctor',
            ),
          ],
        ),
        DashboardItem.items(
          icon: const Icon(Icons.device_hub),
          label: 'Device',
          subItems: [
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return AddDeviceView();
              },
              icon: const Icon(Icons.table_chart),
              id: 'add device',
              label: 'Add Device',
            ),
            DashboardItem(
              builder: (Map<String, dynamic> parameters) {
                return const ReadyGridExample(gridDelegate: Grids.responsive);
              },
              icon: const Icon(Icons.local_cafe),
              id: 'all device',
              label: 'All Device',
            ),
          ],
        ),
        // DashboardItem(
        //   builder: (Map<String, dynamic> parameters) {
        //     return const ProfileWidget();
        //   },
        //   icon: const Icon(Icons.person),
        //   id: 'profile',
        //   label: 'Profile',
        // ),
        DashboardItem(
          builder: (Map<String, dynamic> parameters) {
            return const ProfileWidget();
          },
          icon: const Icon(Icons.logout),
          id: 'logout',
          label: 'Logout',
        ),
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

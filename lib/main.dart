// import 'package:cardiofit_dashboard/controllers/MenuAppController.dart';
// import 'package:cardiofit_dashboard/firebase_options.dart';
// import 'package:cardiofit_dashboard/screens/main/main_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'flutter_flow/flutter_flow_theme.dart';
// import 'flutter_flow/flutter_flow_util.dart';
// import 'flutter_flow/internationalization.dart';
// import 'flutter_flow/nav/nav.dart';
// import 'index.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await FlutterFlowTheme.initialize();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//   @override
//   State<MyApp> createState() => _MyAppState();

//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }

// class _MyAppState extends State<MyApp> {
//   Locale? _locale;
//   ThemeMode _themeMode = FlutterFlowTheme.themeMode;

//   late AppStateNotifier _appStateNotifier;
//   late GoRouter _router;

//   @override
//   void initState() {
//     super.initState();
//     _appStateNotifier = AppStateNotifier();
//     _router = createRouter(_appStateNotifier);
//   }

//   void setLocale(String language) {
//     setState(() => _locale = createLocale(language));
//   }

//   void setThemeMode(ThemeMode mode) => setState(() {
//         _themeMode = mode;
//         FlutterFlowTheme.saveThemeMode(mode);
//       });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'cardiofit dashboard',
//       localizationsDelegates: [
//         FFLocalizationsDelegate(),
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       home: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//             create: (context) => MenuAppController(),
//           ),
//         ],
//         child: MainScreen(),
//       ),
//       locale: _locale,
//       supportedLocales: const [Locale('en', '')],
//       theme: ThemeData(brightness: Brightness.light),
//       themeMode: _themeMode,
//     );
//   }
// }

import 'package:cardiofit_dashboard/firebase_options.dart';
import 'package:cardiofit_dashboard/index.dart';
import 'package:cardiofit_dashboard/pages/admin_dashboard/admin_dashboard.dart';

import 'package:cardiofit_dashboard/pages/dashbaord/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ready/ready.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _mode = ThemeMode.light;
  var homepage;
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
        setState(() => homepage = LoginWidget());
      } else {
        print('User is signed in!');
        String userid = user.uid;
        print(userid);
        print(user.displayName);
        // print("claim:$token");
        // generateJWT();
        // queryHasuraGraphQL();
        if (user.displayName!.contains("admin")) {
          setState(
            () => homepage = AdminDashBoardExample(
              onModeChanged: (value) {
                setState(() {
                  _mode = value;
                });
              },
            ),
          );
        } else {
          setState(
            () => homepage = DashBoardExample(
              onModeChanged: (value) {
                setState(() {
                  _mode = value;
                });
              },
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        Ready.delegate,
      ],
      themeMode: _mode,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: const Locale('en'),
      home: homepage,
      // DashBoardExample(
      //   onModeChanged: (value) {
      //     setState(() {
      //       _mode = value;
      //     });
      //   },
      // ),
      debugShowCheckedModeBanner: false,
    );
  }
}

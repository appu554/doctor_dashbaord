import 'dart:async';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../dashbaord/dashboard.dart';
import 'hero.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

ThemeMode _modeTheme = ThemeMode.dark;

class ExampleApp extends StatefulWidget {
  final Auth0? auth0;
  const ExampleApp({this.auth0, final Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  UserProfile? _user;
  Credentials? _credentialsDetails;

  late Auth0 auth0;
  late Auth0Web auth0Web;
  Timer? _timer;

  @override
  void initState() {
    auth0 = widget.auth0 ??
        Auth0("dev-hfw6wda5wtf8l13c.au.auth0.com",
            "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");
    auth0Web = Auth0Web("dev-hfw6wda5wtf8l13c.au.auth0.com",
        "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");

    if (kIsWeb) {
      auth0Web.onLoad().then((final credentials) => setState(() {
            _user = credentials?.user;
            _credentialsDetails = credentials;
          }));
    }
    // Navigate to the DashBoardExample route after successful login
    if (_user != null && _credentialsDetails != null) {}
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _everySecond();
    });
    // if (_credentialsDetails != null) {
    //   print("cred is exsting");
    // } else {
    //   print("cred id not having any thing");
    // }
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _everySecond() async {
    print('This function runs every second.');
    if (_credentialsDetails != null) {
      print("cred is exsting");

      final credentials = _credentialsDetails;
      print(credentials!.expiresAt);
    } else {
      print("cred id not having any thing");
    }
    // Add your desired function call or logic here.
  }

  Future login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(
            redirectUrl: 'https://doctor.cardiofit.in');
      }

      var credentials =
          await auth0.webAuthentication(scheme: "vaidshala").login();

      setState(() {
        _user = credentials.user;
        _credentialsDetails = credentials;
      });
      print("whats user name$_user");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'https://doctor.cardiofit.in');
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();
        setState(() {
          _user = null;
          _credentialsDetails = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future refreshIdToken() async {
    print("working");
    final auth0 = Auth0("dev-hfw6wda5wtf8l13c.au.auth0.com",
        "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");
    final refreshToken = await auth0.credentialsManager
        .credentials(); // Retrieve the refresh token from secure storage

    final newTokens = await auth0.api
        .renewCredentials(refreshToken: refreshToken.refreshToken!);
    debugPrintSynchronously(newTokens.idToken);
    // Use the new ID token as needed
    // _idTokenMessage = newTokens.idToken;
    auth0.credentialsManager.storeCredentials(newTokens);
    print("working");
  }

  @override
  Widget build(final BuildContext context) {
    print("_user ${_user?.email}");
    // print("_cred ${_credentialsDetails?.idToken}");

    return MaterialApp(
      home: Authenticator(
        child: Scaffold(
            body: Padding(
          padding: const EdgeInsets.only(),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Row(children: [
              _user != null
                  ? Expanded(
                      child: DashBoardExample(
                      onModeChanged: (value) {
                        setState(() {
                          _modeTheme = value;
                        });
                      },
                      credentialAuth0: _credentialsDetails!,
                    ))
                  : const Expanded(child: HeroWidget())
            ])),
            _user != null
                ? ElevatedButton(
                    onPressed: logout,
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: const Text('Logout'),
                  )
                : ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    child: const Text('Login'),
                  )
          ]),
        )),
      ),
    );
  }
}

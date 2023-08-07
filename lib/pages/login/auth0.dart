import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../dashbaord/dashboard.dart';
import 'constants.dart';
import 'hero.dart';
import 'user.dart';

class ExampleApp extends StatefulWidget {
  final Auth0? auth0;
  const ExampleApp({this.auth0, final Key? key}) : super(key: key);

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  UserProfile? _user;

  late Auth0 auth0;
  late Auth0Web auth0Web;

  ThemeMode _mode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    auth0 = widget.auth0 ??
        Auth0("dev-hfw6wda5wtf8l13c.au.auth0.com",
            "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");
    auth0Web = Auth0Web("dev-hfw6wda5wtf8l13c.au.auth0.com",
        "Y5u631Qz0f3yOfyB0F0GGFXLykNrltjL");

    if (kIsWeb) {
      auth0Web.onLoad().then((final credentials) => setState(() {
            _user = credentials?.user;
          }));

      print("_user $_user");

      if (_user == null) {
        print("nulled");
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
    }
  }

  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:8000');
      }

      var credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          .login();

      setState(() {
        _user = credentials.user;
        auth0.credentialsManager.storeCredentials(credentials);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'http://localhost:8000');
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            .logout();
        setState(() {
          _user = null;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              child: Row(children: [
            _user != null
                ? Expanded(child: DashBoardExample(
                    onModeChanged: (value) {
                      setState(() {
                        _mode = value;
                      });
                    },
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
                  onPressed: login,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: const Text('Login'),
                )
        ]),
      )),
    );
  }
}

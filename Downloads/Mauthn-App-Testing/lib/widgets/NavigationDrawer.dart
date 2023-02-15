import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/async.dart';
import 'dart:ui';
import '../login/loginPage.dart';
import '../pages/iot.dart';
import 'dart:io';
import 'package:intl/intl.dart';

const Color MainColor = Color.fromRGBO(114, 118, 252, 1);

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  print('path ${path}');
  return File('$path/id');
}

Future<int> deleteFile() async {
  try {
    final file = await _localFile;

    await file.delete();
    return 1;
  } catch (e) {
    return 0;
  }
}

class NavigationDrawer extends StatelessWidget {
  final String id;

  const NavigationDrawer({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              // decoration: const BoxDecoration(color: MainColor),
              child:
                  Container(child: Image.asset("assets/login/MAuthNLogo.png")),
            ),
            ListTile(
              leading: Icon(
                Icons.pages,
                color: MainColor,
              ),
              title: Text("IoT Services"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((BuildContext context) =>
                        iotServices(id: this.id))),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: MainColor,
              ),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                //logout mechanism
                deleteFile().then((value) => value == 1
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginPage()),
                        (route) => false)
                    : print("Some issue make this into logs"));
              },
            )
          ],
        ),
      );
}

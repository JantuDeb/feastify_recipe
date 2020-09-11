import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/common_widgets/platform_alert_dialog.dart';
import 'package:recipe/services/auth.dart';

class DrawerList extends StatefulWidget {
  DrawerList(context, {Key key}) : super(key: key);

  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  bool switchControl = false;
  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
      });
      //TODO notification setting
    } else {
      setState(() {
        switchControl = false;
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF263238),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                      contentPadding: EdgeInsets.all(2.0),
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Notifiaction Setting",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      trailing: Switch(
                        onChanged: toggleSwitch,
                        value: switchControl,
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                      )),
                  ListTile(
                    contentPadding: EdgeInsets.all(2.0),
                    leading: Image.asset('images/icon/user.png',
                        width: 25.0, height: 25.0),
                    title: Text(
                      "Profile",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(2.0),
                    leading: Image.asset('images/icon/favorite.png',
                        width: 25.0, height: 25.0),
                    title: Text(
                      "Saved Recipe",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(2.0),
                    leading: Image.asset('images/icon/basket.png',
                        width: 25.0, height: 25.0),
                    title: Text(
                      "Shopping List",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(2.0),
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    title: Text(
                      "Invite Friends",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.all(2.0),
                    leading: Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    title: Text(
                      "Feedback",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () => _confirmSignOut(context),
                    contentPadding: EdgeInsets.all(2.0),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: 60.0,
                child: InkWell(
                  child: Image.asset(
                    'images/icon/close.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  onTap: () => Navigator.pop(context),
                ))
          ],
        ),
      ),
      //  child: child,
    );
  }
}

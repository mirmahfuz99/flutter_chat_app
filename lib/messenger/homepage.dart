import 'package:flutter/material.dart';
import 'package:flutter_chat_app/messenger/latest_user.dart';
import 'user_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Container(
                  width: 60.0,
                  child: new Tab(
                    text: "CONTACT",
                  ),
                ),

                Container(
                  width: 70.0,

                  child: new Tab(
                    text: "CHAT Tab",
                  ),
                ),

              ],
            ),
            title: Text('Messenger Tab'),
          ),
          body: TabBarView(
            children: [
              new UserList(),
              new LatestUserList(),

            ],
          ),
        ),
      ),
    );
  }
}
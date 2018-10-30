import 'package:flutter/material.dart';
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
                    text: "CHAT",
                  ),
                ),

              ],
            ),
            title: Text('Messenger'),
          ),
          body: TabBarView(
            children: [
              new UserList(),
              new Text('Recently Chat'),
            ],
          ),
        ),
      ),
    );
  }
}
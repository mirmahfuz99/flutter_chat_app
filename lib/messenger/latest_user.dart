import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_chat_app/ChatScreen.dart';

class LatestUserList extends StatefulWidget {
  @override
  _LatestUserListState createState() => _LatestUserListState();
}

class _LatestUserListState extends State<LatestUserList> {

  List<Users> zoom_users = List();

  DatabaseReference database;

  @override
  void initState() {
    super.initState();

    database = FirebaseDatabase.instance.reference().child("messages");

  }


  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      defaultChild: Center(child: new CircularProgressIndicator(backgroundColor: Colors.deepPurpleAccent,)),
      query: database,
      sort: (a,b) => (b.key.compareTo(a.key)), // last added item will be show first
      itemBuilder: (_, DataSnapshot userSnapshot, Animation<double> animation, int index) {
        //get last message data
        return new FutureBuilder<DataSnapshot>(
          future: database.child(userSnapshot.key).once(),
          builder: (BuildContext context, userDataSnapshot){
            if(userDataSnapshot.hasData){
              //get last message user data. like I sent message to you. so I need your information
              return FutureBuilder<DataSnapshot>(
                future: database.child(userSnapshot.key).once(),
                builder: (BuildContext context, userSnapshot){
                  if(userSnapshot.hasData){
                    String name = userSnapshot.data.value['senderName'];
                    String email = userSnapshot.data.value['email'];
                    String photoUrl  = userSnapshot.data.value['senderPhotoUrl'];

                    Users lastMessages = new Users(
                      name: name,
                      email: email,
                      photoUrl: photoUrl,
                    );
                    return userListWidget(lastMessages, context);
                  }
                  else{
                    return new Container();
                  }
                },
              );
            }
            else
              return new Container();
          },
        );
      },
    );

  }
}

Widget userListWidget(Users users, BuildContext context){
  return SafeArea(
    child: new Column(
      children: <Widget>[
        new Divider(
          height: 10.0,
        ),
        new ListTile(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new ChatScreen()),
            );
          },
          leading: new CircleAvatar(
            backgroundImage:
            new NetworkImage(users.photoUrl),
          ),
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                users.name,
              ),
              new Text(
                users.email,
              )
            ],
          ),
        ),
      ],
    ),
  );
}
class Users {
  String key;
  String name;
  String email;
  String photoUrl;
  Users({this.name, this.email, this.photoUrl});
}
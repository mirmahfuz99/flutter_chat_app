import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/ChatMessageListItem.dart';
import 'package:flutter_chat_app/messenger/homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  final reference = FirebaseDatabase.instance.reference().child('users');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Main Project'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: FlatButton(
                onPressed: (){
                  _handleSignIn();
                  /*_ensureLoggedIn();
                  var user_info = <String, dynamic>{
                    'email':googleSignIn.currentUser.email,
                    'senderName':googleSignIn.currentUser.displayName,
                    'senderPhotoUrl':googleSignIn.currentUser.photoUrl,
                  };
                  reference.push().set(user_info);*/
                },
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Color(0xffdd4b39),
                highlightColor: Color(0xffff7f7f),
                splashColor: Colors.transparent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
          ),
          // Loading
          Positioned(
            child: isLoading
                ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
                : Container(),
          ),
        ],
      ));
  }

  Future<Null> _handleSignIn() async {

    setState(() {
      isLoading = true;
    });

    await _ensureLoggedIn();
      var user_info = <String, dynamic>{
        'email':googleSignIn.currentUser.email,
        'name':googleSignIn.currentUser.displayName,
        'photoUrl':googleSignIn.currentUser.photoUrl,
      };
      reference.push().set(user_info);


    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new HomePage()),
    );
  }



  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }
    currentUserEmail = googleSignIn.currentUser.email;

    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
      await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
          idToken: credentials.idToken, accessToken: credentials.accessToken);
    }
  }
}


import 'dart:io';

import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  //Add a loading spinner
  var _isLoading = false;

  final _auth = FirebaseAuth.instance;
  void _submitAuthForm(String email, String pass, String userName, bool isLogIn, BuildContext ctx, File img) async {
    //17_07: Connect the AuthScreen State with Auth Form
    ///17_07: Use Firebase SDK to create a new user
    UserCredential authResult;

    try{
      setState(() {
        _isLoading = true;
      });
      if(isLogIn){
        authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: pass);
      }
      else{
        //Sign Up case
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: pass);

        //24_07: Perform the image upload
        final imgRef = FirebaseStorage.instance.ref().child('user_image').child(authResult.user!.uid + '.jpg');
        await imgRef.putFile(img);//Start the upload
        final imgURL = await imgRef.getDownloadURL();

        ///17_07: Store additional data
        await FirebaseFirestore.instance.collection('userName').doc(
          authResult.user!.uid
        ).set({
          'username': userName,
          'email': email,
          'imageURL': imgURL,
        });
      }
    }on PlatformException catch(error){
      var message = 'An error occurred, please check again';
      if(error.message != null){
        print('Error in auth: ${error.message}');
        message = error.message!;
        // ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message),
        //   backgroundColor: Theme.of(ctx).errorColor,),
        // );
      }
      setState(() {
        _isLoading = false;
      });
    }catch(error){
      print('More general error: $error');
      // ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}

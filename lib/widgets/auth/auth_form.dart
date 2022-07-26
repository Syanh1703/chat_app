import 'dart:io';

import '/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      String email,
      String pass,
      String userName,
      bool isLogIn,
      BuildContext ctx,
      File userImgFile,
      ) submitForm;

  final bool isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  RegExp passRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final  _submitKey = GlobalKey<FormState>();
  var _isLogIn = true;
  String userEmail = '';
  String userName = '';
  String userPass = '';
  File? _userImgFile;

  void _pickImg(File img){
      _userImgFile = img;//23_07: Store the image from the image picker
  }

  void _submitForm(){
   final isValid =  _submitKey.currentState!.validate();
   FocusScope.of(context).unfocus();//Close the soft keyboard as soon as we hit submit button

   print('User Email: $userEmail');
   print('User Name: $userName');
   print('User Pass: $userPass');

   widget.submitForm(
     userEmail.trim(),
       userPass.trim(),
       userName.trim(),
       _isLogIn,
       context,
     _userImgFile!,
   );

   //23_07: Make sure the image is not left empty
   if(_userImgFile == null && !_isLogIn){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('You did not upload the your avatar'),
     backgroundColor: Theme.of(context).errorColor,
     ),);
     return;
   }

   if(isValid){
     _submitKey.currentState!.save();
   }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _submitKey,
                  child: Column(
                    children: <Widget>[
                      if(!_isLogIn) UserImagePicker(_pickImg),
                      TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        key: const ValueKey('Email'),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.mail),
                          labelText: 'Email',
                          hintText: 'Please enter your e-mail address',
                        ),
                        validator: (value){
                          if(value!.isEmpty || !emailRegex.hasMatch(value)){
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (savedValue){
                          userEmail = savedValue!;
                        },
                      ),
                      if(!_isLogIn)
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          key: const ValueKey('userName'),
                          decoration: const InputDecoration(
                            labelText: 'UserName',
                            icon: Icon(Icons.person)
                          ),
                          validator: (value){
                            if(value!.isEmpty || value.length<3){
                              return 'Invalid Username, it must contain more than 3 characters';
                            }
                            return null;
                          },
                          onSaved: (savedValue){
                            userName = savedValue!;
                          },
                        ),
                      TextFormField(
                        key: const ValueKey('pass'),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.password),
                          labelText: 'Password',
                          hintText: 'Please enter your password'
                        ),
                        obscureText: true,
                        validator: (value){
                          if(value!.isEmpty || !passRegex.hasMatch(value)){
                            return 'Please enter a valid password';
                          }
                          if(value.length < 8){
                            return 'The password must contain more than 8 characters';
                          }
                          return null;
                        },
                        onSaved: (savedValue){
                          userPass = savedValue!;
                        },
                      ),
                      const SizedBox(height: 12,),
                      if(widget.isLoading)
                        const CircularProgressIndicator(),
                      if(!widget.isLoading)
                        ElevatedButton(onPressed: _submitForm,
                          child: Text(_isLogIn ? 'Log In' : 'Sign Up'),
                        ),
                      if(!widget.isLoading)
                        TextButton(onPressed: (){
                          //Switch Login and Sign Up mode
                          setState(() {
                            _isLogIn = !_isLogIn;
                          });
                          }, child: Text(_isLogIn ? 'Create new Account' : 'Already have an account'),
                          style:TextButton.styleFrom(
                            primary: Theme.of(context).primaryColor
                          ),
                        ),
                    ],
                    mainAxisSize: MainAxisSize.min,//take the smallest space at possible
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
            ),
          ),
      );
  }
}

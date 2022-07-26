import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';

import '../widgets/chat/new_message.dart';

import '../widgets/chat/messages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String chatId = '7JYhkUE15jy9JZ1WEkYe';

  final String firebaseUrl = 'chats/7JYhkUE15jy9JZ1WEkYe/messages';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat App'),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
              items: [
                DropdownMenuItem(child: Container(
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.exit_to_app, color: Colors.black,),
                      const Text('Log Out', style: TextStyle(
                        fontSize: 18,
                        color: Colors.black
                      ),),
                      const SizedBox(width: 8,),
                    ],
                  ),
                ),
                  value: 'Logout', //act as an identifier
                ),
              ],
              onChanged: (itemIdentifier){
                if(itemIdentifier == 'Logout'){
                  //Log out the user
                  FirebaseAuth.instance.signOut();//Destroy the token
                }
              },
              icon: const Icon(Icons.more_vert, color: Colors.indigo),style: TextStyle(
            color: Colors.indigo,
          ),),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}

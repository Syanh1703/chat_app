import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _messageController = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();//make the keyboard disappear
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('userName').doc(user!.uid).get();
    ///18_07: Use Firestore to create new message
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'messageTimeStamp': Timestamp.now(),
      //22_07: Add another field to distinguish the message from the sender or receiver
      'userId': user.uid,
      'userName': userData['username'],
      'userImg': userData['imageURL'],
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField( //Contain the inout text
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(hintText: 'Type anything...'),
              onChanged: (value){
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

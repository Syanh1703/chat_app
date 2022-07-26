import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String userImg;
  MessageBubble(this.message, this.isMe,this.key, this.userName, this.userImg);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.purpleAccent : Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)
                  ),
                ),
                width: 140,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(userName, style: TextStyle(
                            fontWeight: FontWeight.bold,
                          color: isMe ? Colors.black : Theme.of(context).textTheme.headline1?.color
                        ),
                    ),
                    Text(message, style: TextStyle(
                    color: isMe ? Colors.black :Theme.of(context).textTheme.headline1?.color,
                  ),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  ],
                ),
             ),
            ],
          ),
        Positioned(
            top: 0,
            right: isMe ? 120 : null,
            left: !isMe ? 120 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImg),
            ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}

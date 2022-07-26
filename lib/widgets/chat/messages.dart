import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/message_bubble.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
          ///18_07: Use QuerySnapshot to get data.docs
          builder: (ctx, chat) {
            if (chat.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = (chat.data as QuerySnapshot).docs;
            return ListView.builder(
              reverse: true,
              itemBuilder: (ctx, index) =>
                  MessageBubble(
                      chatDocs[index]['text'],
                      chatDocs[index]['userId'] == user!.uid,
                      ValueKey(chatDocs[index].id),
                    chatDocs[index]['userName'],
                    chatDocs[index]['userImg'],
                  ),
              itemCount: chatDocs.length,
            );
          },
          stream: FirebaseFirestore.instance.collection('chat').orderBy(
              'messageTimeStamp', descending: true).snapshots(),
        );
  }
}

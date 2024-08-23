import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:s14_firebase_chat/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // snapshot.error will return the error from the Exception
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found'),
          );
        }

        final loadedMessages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final firstMsg = loadedMessages[index].data();
            final nextMsg = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final msgUsername = firstMsg['username'];
            final msgUserImage = firstMsg['userImage'];
            final msgUserId = firstMsg['userId'];
            final msgText = firstMsg['text'];
            final nextmsgUserId = nextMsg != null ? nextMsg['userId'] : null;
            final nextUserIsSame = nextmsgUserId == msgUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: msgText,
                isMe: currentUser!.uid == msgUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: msgUserImage,
                username: msgUsername,
                message: msgText,
                isMe: currentUser!.uid == msgUserId,
              );
            }
          },
        );
      },
    );
  }
}

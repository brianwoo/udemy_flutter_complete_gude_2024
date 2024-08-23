import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _msgController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _msgController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMsg = _msgController.text;

    if (enteredMsg.trim().isEmpty) {
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser!;
    final userDataGet = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    final userData = userDataGet.data();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMsg,
      'createdAt': Timestamp.now(),
      'userId': currentUser.uid,
      'username': userData!['username'],
      'userImage': userData!['image_url'],
    });
    _msgController.clear();

    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}

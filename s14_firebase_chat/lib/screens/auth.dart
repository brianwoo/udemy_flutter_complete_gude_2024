import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:s14_firebase_chat/widgets/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  late String _enteredEmail;
  late String _enteredPassword;
  late String _enteredUsername;
  File? _selectedImage;
  bool _isAuthenticating = false;

  void _selectImage(File pickedImage) {
    _selectedImage = pickedImage;
  }

  void _submit() async {
    final isValidated = _formKey.currentState!.validate();

    if (!isValidated || (!_isLogin && _selectedImage == null)) {
      return;
    }
    _formKey.currentState!.save();
    print('$_enteredEmail $_enteredPassword');

    try {
      setState(() {
        _isAuthenticating = true;
      });

      if (_isLogin) {
        final userCred = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print('userCred: $userCred');
      } else {
        final userCred = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        print('userCred: $userCred');

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCred.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();
        print(imageUrl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/images/chat.png'),
                  ),
                  Card(
                    margin: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: _isAuthenticating
                              ? const CircularProgressIndicator()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (!_isLogin)
                                      UserImagePicker(
                                          onPickImage: _selectImage),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Email Address',
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      autocorrect: false,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !value.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) =>
                                          _enteredEmail = newValue!,
                                    ),
                                    if (!_isLogin)
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            labelText: 'Username'),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().length < 4) {
                                            return 'Username must be >= 4 chars long';
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) {
                                          _enteredUsername = newValue!;
                                        },
                                      ),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Password',
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().length < 6) {
                                          return 'Password must be >= 6 chars long';
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) =>
                                          _enteredPassword = newValue!,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                        onPressed: _submit,
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer),
                                        child: _isLogin
                                            ? const Text('Login')
                                            : const Text('Signup')),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                        });
                                      },
                                      child: _isLogin
                                          ? const Text('Create an account')
                                          : const Text(
                                              'I already have an account'),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

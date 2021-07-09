import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Authform extends StatefulWidget {
  @override
  _AuthformState createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  // -------------------------------------------------------
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool _isLoginPage = false;

  // -------------------------------------------------------
  startAuththentication() {
    final validity = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (validity) {
      _formkey.currentState.save();
      submidform(_username, _email, _password);
    }
  }

  // -------------------------------------------------------
  submidform(String username, String email, String password) async {
    final auth = FirebaseAuth.instance;
    UserCredential _usercredention;
    try {
      if (_isLoginPage) {
        _usercredention = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _usercredention = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(_usercredention.user.uid)
            .set({'username': username, 'email': email, 'password': password});
      }
    } catch (err) {
      print(err);
    }
  }

  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  if (!_isLoginPage)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, right: 10, left: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(),
                          ),
                          labelText: 'UserName',
                          labelStyle: GoogleFonts.lobster(fontSize: 18),
                        ),
                      ),
                    ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15),
                          borderSide: new BorderSide(),
                        ),
                        labelText: 'Email',
                        labelStyle: GoogleFonts.lobster(fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password Empty or simple ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(),
                        ),
                        labelText: 'PassWord',
                        labelStyle: GoogleFonts.lobster(fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          startAuththentication();
                        },
                        child: _isLoginPage
                            ? Text(
                                'Login',
                                style: GoogleFonts.roboto(fontSize: 16),
                              )
                            : Text(
                                'SingUp',
                                style: GoogleFonts.roboto(fontSize: 16),
                              ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          primary: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoginPage = !_isLoginPage;
                        });
                      },
                      child: _isLoginPage
                          ? Text('Not a Member')
                          : Text('Alrady Member'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailo/medules/auth/register_screen.dart';
import 'package:dailo/shared/component/components.dart';
import 'package:dailo/shared/component/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../layout/home_screen.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/remote/auth_service.dart';
import '../../shared/network/remote/database_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  AuthService authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                  top: 30.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Dailo',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Login now and see what we are talking',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset("assets/images/login.png"),
                      TextFormField(
                        decoration: Components.textInputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: Constants.emailIcon,
                        ),
                        validator: (value) {
                          return RegExp(
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                  .hasMatch(value!)
                              ? null
                              : 'Please enter a valid mail';
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value.trim();
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      TextFormField(
                        decoration: Components.textInputDecoration.copyWith(
                            labelText: 'Password',
                            prefixIcon: Constants.passwordIcon),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        obscureText: true,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'password must be at least 6 characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Sign In'),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      Text.rich(TextSpan(
                        text: 'Don\'t have an account? ',
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Register here',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Components.nextScreen(
                                      context, RegisterScreen());
                                }),
                        ],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          // saving the values to our shared preferences
          await CacheHelper.saveUserLoginState(true);
          await CacheHelper.saveUserEmail(email);
          await CacheHelper.saveUserName(snapshot.docs[0]['fullName']);
          Components.nextScreenReplace(context, const HomeScreen());
        } else {
          Components.showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

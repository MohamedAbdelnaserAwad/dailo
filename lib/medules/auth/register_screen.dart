import 'package:dailo/layout/home_screen.dart';
import 'package:dailo/medules/auth/login_screen.dart';
import 'package:dailo/shared/component/components.dart';
import 'package:dailo/shared/component/constants.dart';
import 'package:dailo/shared/network/local/cache_helper.dart';
import 'package:dailo/shared/network/remote/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
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
                        'Create your account now to chat and explore',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset("assets/images/register.png"),
                      TextFormField(
                        decoration: Components.textInputDecoration.copyWith(
                          labelText: 'Full Name',
                          prefixIcon: Constants.fullNameIcon,
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'Name cannot be empty';
                          }
                        },
                        onChanged: (value) {
                          setState(() {
                            fullName = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
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
                            email = value;
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
                          child: Text('ٌRegister'),
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          onPressed: () {
                            register();
                          },
                        ),
                      ),
                      Text.rich(TextSpan(
                        text: 'Already have an account ',
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Login now',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Components.nextScreen(context, LoginScreen());
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


  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await CacheHelper.saveUserLoginState(true);
          await CacheHelper.saveUserEmail(email);
          await CacheHelper.saveUserName(fullName);
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

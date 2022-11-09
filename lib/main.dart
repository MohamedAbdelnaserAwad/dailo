import 'package:dailo/layout/home_screen.dart';
import 'package:dailo/medules/auth/login_screen.dart';
import 'package:dailo/shared/component/constants.dart';
import 'package:dailo/shared/network/local/cache_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isSignedIn =false;
  @override
  void initState() {
    super.initState();
    getUserLoginStatus();
  }
  getUserLoginStatus ()async{
    await CacheHelper.getUserLoginState().then((value){
      if(value !=null){
        isSignedIn = value;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constants.primaryColor,
      ),
      home: isSignedIn? HomeScreen(): LoginScreen(),
    );
  }
}



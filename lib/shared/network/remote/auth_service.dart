import 'package:dailo/shared/network/remote/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../local/cache_helper.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

 //register
 Future registerUserWithEmailAndPassword(String fullName,String email,String password)async{
   try{
     User user = (await firebaseAuth.createUserWithEmailAndPassword(
         email: email, password: password))
     .user!;

     if(user != null){
       //call database service to update the user data
       await DatabaseService(uid: user.uid).updateUserData(fullName, email);
       return true ;
     }
   }on FirebaseAuthException catch(e){
     return e;
   }

 }

  // sign out
  Future signOut() async {
    try {
      await CacheHelper.saveUserLoginState(false);
      await CacheHelper.saveUserEmail("");
      await CacheHelper.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }



}
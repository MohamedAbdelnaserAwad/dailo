import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static String userLoginKey = "USER_LOGIN_KEY";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
    //this line to clear shared
    //await sharedPreferences!.clear();
  }


  //saving data to shared preferences
  static Future<bool> saveUserLoginState(bool isUserLoggedIn) async {
    return await sharedPreferences!.setBool(userLoginKey,isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    return await sharedPreferences!.setString(userNameKey,userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    return await sharedPreferences!.setString(userEmailKey,userEmail);
  }


  //getting the data from shared preferences
  static Future<bool?> getUserLoginState() async {
    return sharedPreferences!.getBool(userLoginKey);
  }
  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }


}
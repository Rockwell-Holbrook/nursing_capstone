///This page holds the classes and functions needed to authenticate
import 'dart:convert';
import 'stuff.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User{

  String username;
  String email;
  String password;
  bool admin;
  CognitoUserPool userPool;
  CognitoUserSession session;

  SharedPreferences prefs;
  CustomStorage customStore;

  ///Wait for init to complete before using other functions
  Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      customStore = new CustomStorage(prefs);
      return true;
    } else {
      return false;
    }
  }

  ///Updates the default user of this phone to be an admin
  Future<bool> saveAsAdmin(String uname) async {
    if(uname.contains('admin/')) {
      admin = true;
      await prefs.setString('admin', 'admin');
    } else {
      admin = false;
      await prefs.setString('admin', '');
    }
    return true;
  }

  ///Checks local storage to see if the user is an admin
  setUserType() {
    String type = '';
    String temp = prefs.getString('admin');
    if(temp != null) {
      type = temp;
    }
    if(type == 'admin') {
      admin = true;
      userPool = new CognitoUserPool(userPoolID, adminAppClientID, storage: customStore);
    } else {
      admin = false;
      userPool = new CognitoUserPool(userPoolID, appClientID, storage: customStore);
    }
  }

  ///Registers a new gem user. If successful, returns true
  Future<bool> register(String uname, String email, String password) async {
    bool ready = await init();
    await saveAsAdmin(uname);
    setUserType();
      if(ready) {
      final userAttributes = [
        new AttributeArg(name: 'email', value: email),
      ];
      try {
        await userPool.signUp(uname, password, userAttributes: userAttributes);
        CognitoUserSession session;
        try {
          final cognitoUser = new CognitoUser(username, userPool, storage: userPool.storage);
          final authDetails = new AuthenticationDetails(username: username, password: password);
          session = await cognitoUser.authenticateUser(authDetails);
        } on CognitoUserNewPasswordRequiredException catch (e) {
          // handle New Password challenge
        } on CognitoUserMfaRequiredException catch (e) {
          // handle SMS_MFA challenge
        } on CognitoUserSelectMfaTypeException catch (e) {
          // handle SELECT_MFA_TYPE challenge
        } on CognitoUserMfaSetupException catch (e) {
          // handle MFA_SETUP challenge
        } on CognitoUserTotpRequiredException catch (e) {
          // handle SOFTWARE_TOKEN_MFA challenge
        } on CognitoUserCustomChallengeException catch (e) {
          // handle CUSTOM_CHALLENGE challenge
        } on CognitoUserConfirmationNecessaryException catch (e) {
          // handle User Confirmation Necessary
        } catch (e) {
          print(e);
          return true;
        }
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  ///Authenticates the user with the general user pool.
  ///If successful, returns JWTToken
  Future<String> authenticate(String username, String password) async {
    bool ready = await init();
    await saveAsAdmin(username);
    setUserType();
    if(ready) { 
      final cognitoUser = new CognitoUser(username, userPool, storage: userPool.storage);
      final authDetails = new AuthenticationDetails(username: username, password: password);
      CognitoUserSession session;
      try {
        session = await cognitoUser.authenticateUser(authDetails);
      } on CognitoUserNewPasswordRequiredException catch (e) {
        // handle New Password challenge
      } on CognitoUserMfaRequiredException catch (e) {
        // handle SMS_MFA challenge
      } on CognitoUserSelectMfaTypeException catch (e) {
        // handle SELECT_MFA_TYPE challenge
      } on CognitoUserMfaSetupException catch (e) {
        // handle MFA_SETUP challenge
      } on CognitoUserTotpRequiredException catch (e) {
        // handle SOFTWARE_TOKEN_MFA challenge
      } on CognitoUserCustomChallengeException catch (e) {
        // handle CUSTOM_CHALLENGE challenge
      } on CognitoUserConfirmationNecessaryException catch (e) {
        // handle User Confirmation Necessary
      } catch (e) {
        return '';
      }
      //print(session.getAccessToken().getJwtToken());
      return session.getIdToken().getJwtToken();
    } else {
      return 'Unable to fetch user data';
    }
  }

  Future<bool> confirmEmail(String confirmationCode) async {
    bool ready = await init();
    setUserType();
    if(ready) {
      final cognitoUser = new CognitoUser(username, userPool, storage: userPool.storage);
      bool registrationConfirmed = false;
      try {
        registrationConfirmed = await cognitoUser.confirmRegistration(confirmationCode);
        return registrationConfirmed;
      } catch (e) {
        print(e);
        return registrationConfirmed;
      }
    } else {
      return false;
    }
  }

  Future<String> get userName async {
    await init();
    setUserType();
    final CognitoUser user = await userPool.getCurrentUser();
    return user.username;
  }

  Future<bool> checkActiveSession() async {
    await init();
    setUserType();
    final CognitoUser user = await userPool.getCurrentUser();
    if(user != null) {
      final session = await user.getSession();
      print(session.getIdToken().getJwtToken());
      return session.isValid();
    } else {
      return false;
    }
  }

  Future<CognitoUserSession> getActiveSession() async {
    setUserType();
    final CognitoUser user = await userPool.getCurrentUser();
    if(user != null) {
      final session = await user.getSession();
      return session;
    } else {
      return null;
    }
  }

  Future<String> sendPasswordReset() async {
    bool ready = await init();
    await saveAsAdmin(username);
    setUserType();
    if(ready) {
      final cognitoUser = new CognitoUser(username, userPool, storage: userPool.storage);
      dynamic data;
      try {
        data = await cognitoUser.forgotPassword();
        String destination = data['CodeDeliveryDetails']['Destination'];
        return 'An email has been sent to $destination';
      } catch (e) {
        return '';
      }
    } else {
      return '';
    }
  }

  Future<bool> confirmPasswordReset(String confirmationCode, String nextPassword) async {
    bool ready = await init();
    bool passwordReset = false;
    if(ready) {
      final cognitoUser = new CognitoUser(username, userPool, storage: userPool.storage);
      try {
        passwordReset = await cognitoUser.confirmPassword(confirmationCode, nextPassword);
        return passwordReset;
      } catch(e) {
        return passwordReset;
      }
    } else {
      return passwordReset;
    }
  }

  Future<String> getSessionToken() async {
    await init();
    await setUserType();
    userPool = new CognitoUserPool(userPoolID, appClientID, storage: customStore);
    final CognitoUser user = await userPool.getCurrentUser();
    if(user != null) {
      final session = await user.getSession();
      print(session.getIdToken().getJwtToken());
      return session.getIdToken().getJwtToken();
    } else {
      return '';
    }
  }
}

class CustomStorage extends CognitoStorage {
  SharedPreferences _prefs;
  CustomStorage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    try {
      item = json.decode(_prefs.getString(key));
    } catch (e) {
      return null;
    }
    return item;
  }

  @override
  Future setItem(String key, value) async {
    _prefs.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    if (item != null) {
      _prefs.remove(key);
      return item;
    }
    return null;
  }

  @override
  Future<void> clear() async {
    _prefs.clear();
  }
}
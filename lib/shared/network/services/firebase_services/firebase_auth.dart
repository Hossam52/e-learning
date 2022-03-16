import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FireAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static late FireAuth instance = FireAuth._();
  GoogleAuth googleAuth = GoogleAuth();
  CustomFacebookAuth facebookAuth = CustomFacebookAuth();

  FireAuth._();

  Future<SocialUser> googleLogin() async {
    final res = await googleAuth.login();
    final user = await _signInWithCredintial(res);
    return SocialUser(
        name: user.displayName!,
        email: user.email!,
        photoUrl: user.photoURL!,
        id: user.uid);
  }

  Future<SocialUser> facebookLogin() async {
    final credential = await facebookAuth.login();
    final user = await _signInWithCredintial(credential);
    return SocialUser(
        name: user.displayName!,
        email: user.email!,
        photoUrl: user.photoURL!,
        id: user.uid);
  }

  Future<void> googleLogout() async {
    await _auth.signOut();
    await googleAuth.logout();
  }

  Future<void> facebookLogout() async {
    await _auth.signOut();
    await facebookAuth.logout();
  }

  Future<User> _signInWithCredintial(AuthCredential credential) async {
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) throw 'User is equal to null';
    if (user.isAnonymous) throw 'Cannot be annonymous';
    return user;
  }
}

abstract class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  void login();
  void logout();
  void getUser();
}

class GoogleAuth extends Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late GoogleSignInAccount? googleSignInAccount;
  @override
  void getUser() {}

  @override
  Future<AuthCredential> login() async {
    await logout();
    googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) throw 'Google login failed';
    GoogleSignInAuthentication googleSignInAuth =
        await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuth.accessToken,
      idToken: googleSignInAuth.idToken,
    );
    return credential;
  }

  @override
  Future<void> logout() async {
    final res = await _googleSignIn.signOut();
    log(res.toString());
  }
}

class CustomFacebookAuth extends Auth {
  FacebookAuth _facebookLogin = FacebookAuth.instance;
  List<String> _facebookPermissions = ['email', 'public_profile'];
  @override
  void getUser() {}

  @override
  Future<AuthCredential> login() async {
    final user = await _facebookLogin.login(permissions: _facebookPermissions);
    final status = user.status;
    switch (status) {
      case LoginStatus.success:
        final accessToken = user.accessToken;
        final credential = FacebookAuthProvider.credential(accessToken!.token);
        return credential;
      case LoginStatus.cancelled:
        throw 'Facebook login canceled';
      case LoginStatus.failed:
        throw 'Error happened ${user.message}';
      case LoginStatus.operationInProgress:
      default:
        throw 'Un known';
    }
  }

  @override
  Future<void> logout() async {
    await _facebookLogin.logOut();
  }
}

class SocialUser {
  String name;
  String email;
  String photoUrl;
  String id;
  SocialUser({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.id,
  });

  @override
  String toString() {
    return 'SocialUser(name: $name, email: $email, photoUrl: $photoUrl, id: $id)';
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireAuth {
  static late FireAuth instance;
  FireAuth._();
  static init() {
    instance = FireAuth._();
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
  void login() async {
    googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuth =
        await googleSignInAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuth.accessToken,
      idToken: googleSignInAuth.idToken,
    );
  }

  @override
  void logout() {}
}

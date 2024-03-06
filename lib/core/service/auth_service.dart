import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //signin
  Future<UserCredential> signIn(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // add user to firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'email': email,
          'uid': userCredential.user!.uid,
        },
      );
      return userCredential;
    } catch (e) {
      throw (e);
    }
  }

  //signup
  Future<UserCredential> signUp(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // add user to firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'email': email,
          'uid': userCredential.user!.uid,
        },
      );
      return userCredential;
    } catch (e) {
      throw (e);
    }
  }

  //signout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //error
  Future<String> error() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: 'email', password: 'password');
      return ""; //no error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message.toString();
      }
    }
  }
}

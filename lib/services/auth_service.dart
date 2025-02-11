import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> sendOTP(String phoneNumber, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP Verification Failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pushNamed(
          context,
          '/verifyOTP',
          arguments: {
            'verificationId': verificationId,
            'phoneNumber': phoneNumber,
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> verifyOTP(String verificationId, String otp, BuildContext context) async {
    setLoading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      bool needsName = await isNameMissing(userCredential.user!.uid);
      return needsName;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP")));
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> isNameMissing(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
    var data = userDoc.data() as Map<String, dynamic>?;
    return data == null || !data.containsKey('name') || (data['name'] as String).trim().isEmpty;
  }


  Future<bool> isUserNew(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection("users").doc(uid).get();
    var data = userDoc.data() as Map<String, dynamic>?;
    return data == null || !data.containsKey('name') || (data['name'] as String).trim().isEmpty;
  }

  Future<bool> updateUserName(String name, BuildContext context) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'phone': user.phoneNumber,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}
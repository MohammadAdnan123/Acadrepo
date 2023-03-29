// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class Authmethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> loginUser({
    required String email,
    required String password
  })async {
    String res = "Error occured";

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      }
      else{
        res = "Fill details properly";
      }
    } catch(err){
      res = err.toString();
    }
    return res;
  }
  Future<void> signOut() async{
    await _auth.signOut();
  }
}
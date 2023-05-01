import 'package:firebase_auth/firebase_auth.dart';

class Authmethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        res = "First buy the subsciption then enjoy the app.";
      }
      else if(e.code == 'wrong-password'){
        res = "You should start eating almonds since you have forgotten the password.";
      }
    }
    return res;
  }
  Future<void> signOut() async{
    await _auth.signOut();
  }
}
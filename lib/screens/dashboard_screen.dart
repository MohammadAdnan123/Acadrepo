import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj1/resources/auth_method.dart';
import 'package:proj1/screens/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = '';
  String semester = '';
  @override
  void initState(){
    super.initState();
    getEmail();
  }
  void getEmail() async{
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    // print(snap.data());
    setState(() {
      name = (snap.data() as Map<String, dynamic>)['name'];
      semester = (snap.data() as Map<String, dynamic>)['semester'];
    });
  }
  void signOut() async{
    await Authmethod().signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LogincScreen(),));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Semester $semester'),
        actions: <Widget>[
          PopupMenuButton(
            icon:  const Icon(Icons.person),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Text('Hello $name'), // add name here
                ),
                PopupMenuItem(
                  value: 2,
                  child: InkWell(
                    onTap: signOut, //
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          color: Colors.blue),
                      child: const Text('Log out'),
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

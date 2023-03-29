import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:proj1/Dash_board/cards.dart';
import 'package:proj1/constants/constants.dart';
import 'package:proj1/providers/chats_provider.dart';
import 'package:proj1/providers/models_provider.dart';
import 'package:proj1/resources/auth_method.dart';
import 'package:proj1/screens/chat_screen.dart';
import 'package:proj1/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

final storage = FirebaseStorage.instance;
final subjects = FirebaseStorage.instance.ref().child("Repo/");

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = "", department = "", branch = "";
  String semester = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getEmail();
  }


  void getEmail() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    // print(snap.data());
    setState(() {
      name = (snap.data() as Map<String, dynamic>)['name'];
      semester = (snap.data() as Map<String, dynamic>)['semester'];
      email = (snap.data() as Map<String, dynamic>)['email'];
      department = (snap.data() as Map<String, dynamic>)['department'];
      branch = (snap.data() as Map<String, dynamic>)['branch'];
    });
  }

  void signOut() async {
    await Authmethod().signOut();
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LogincScreen(),
    ));
  }

  Future<ListResult> getSubjectNames(
      String department, String branch, String semester) async {
    final sub = FirebaseStorage.instance
        .ref()
        .child("Repo/$department/$branch/$semester");

    return await sub.listAll();
  }

  @override
  Widget build(BuildContext context) {
    Future<ListResult> subjectNames;
    subjectNames = getSubjectNames(department, branch, semester);
    
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text("Semester $semester"),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                  isScrollable: true,
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal),
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.red,
                  labelColor: Colors.red,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text("Dashboard"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text("Chat Bot"),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          actions: <Widget>[
            PopupMenuButton(
              icon: const Icon(Icons.person),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Text('Hello $name'), // add name here
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: InkWell(
                      onTap: signOut, //Signout function on tap
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
        backgroundColor: Colors.white12,
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: FutureBuilder(
                        future: subjectNames,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data!.prefixes.length);
                            final itemCount = snapshot.data != null
                                ? snapshot.data!.prefixes.length
                                : 0;
                            return ListView.builder(
                                itemCount: itemCount,
                                itemBuilder: (context, index) {
                                  if (itemCount > 0) {
                                    List<String> sub_name = [];
                                    snapshot.data!.prefixes.forEach(
                                      (element) {
                                        sub_name.add(
                                            path.basename(element.fullPath));
                                      },
                                    );
                                    return CardLayout(
                                        subjectName: sub_name[index], subPath: snapshot.data!.prefixes[index].fullPath,);
                                  }
                                  else{
                                    return const Text("No data added");
                                  }
                                });
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else {
                            return const SpinKitFoldingCube(
                              color: Colors.black,
                              size: 18,
                            );
                          }
                        }))
              ],
            ),
            // Center(child: Text("Chat Bot"),)
             MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => ModelsProvider(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => ChatProvider(),
                  ),
                ],
                child: MaterialApp(
                  title: 'Flutter ChatBOT',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      scaffoldBackgroundColor: scaffoldBackgroundColor,
                      appBarTheme: AppBarTheme(
                        color: cardColor,
                      )),
                  home: const ChatScreen(),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:JSAHub/screens/login_screen.dart';
import 'package:JSAHub/widgets/text_input.dart';



class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  // final TextEditingController _semesterEditingController = TextEditingController();
  String semValue = 'Semester 1';
  String depValue = 'B.Tech';
  String branchValue = "CSE";
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _nameEditingController.dispose();
  }

  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}
  Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/lib/user.txt');
}
  void takeDetails() async {
    setState(() {
      _isLoading = true;
    });
  // final file = await _localFile;
  final username = _nameEditingController.text;
  final useremail = _emailEditingController.text;
  final userpassword = _passwordEditingController.text;
  final userdep = depValue;
  final userbranch = branchValue;
  final usersem = semValue;
  // Write the file
  // print(file);
  // file.writeAsString('{"name": $username, "email": $useremail, "password": $userpassword, "department": $userdep, "branch": $userbranch, "semester": $usersem}');
  // setState(() {
  //     _isLoading = false;
  //   });
final storage = FirebaseStorage.instance.ref();
final Reference ref = storage.child("user.txt");
final String textToAppend = '{"name": $username, "email": $useremail, "password": $userpassword, "department": $userdep, "branch": $userbranch, "semester": $usersem}';


// Get the current contents of the file
final data = await ref.getData();

// Convert the byte array to a string
final contents = utf8.decode(data!.toList());


// Append the new string to the existing contents
final newContents = '$contents \n $textToAppend';

// Convert the string to a byte array
// final newData = utf8.encode(newContents);
final Uint8List newdata = Uint8List.fromList(utf8.encode(newContents));

// Set the metadata to update the file
final metadata = SettableMetadata(
  contentType: 'text/plain',
  customMetadata: {
    'appended': 'true',
    'timestamp': DateTime.now().toString(),
  },
);

// Update the file with the new contents and metadata
final TaskSnapshot task = await ref.putData(newdata, metadata);

setState(() {
      _isLoading = false;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LogincScreen(),
              ));
            },
          )),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
              ListView(children: [
                const SizedBox(
              height: 20,
            ),
            const Text("Step 1: Scan the QR code to pay for the subscription(only Rs500)."),
            const SizedBox(height: 20,),
            Image.asset("assets/images/upiimg.jpeg", height: 150,),
            const SizedBox(height: 20,),
            const Text("Step 2: Fill all the necessary details below."),
            const SizedBox(height: 20,),
            TextFielInput(
                textEditingController: _emailEditingController,
                hintText: 'College Email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            TextFielInput(
              textEditingController: _nameEditingController,
              hintText: 'Name',
              textInputType: TextInputType.text,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFielInput(
              textEditingController: _passwordEditingController,
              hintText: 'Password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                // Step 3.
                value: depValue,
                // Step 4.
                items: <String>[
                  'B.Tech',
                  'M.Tech',
                  'MSc',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    depValue = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                // Step 3.
                value: depValue=="B.Tech"?branchValue:"Chemistry",
                // Step 4.
                items: depValue=='B.Tech' ? <String>[
                  'CSE',
                  'Data Science',
                  'EEE',
                  'ME',
                  'CE',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList():<String>[
                  'Physics',
                  'Chemistry',
                  'Mathematics',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(), 
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    branchValue = newValue!;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                // Step 3.
                value: semValue,
                // Step 4.
                items: depValue=="B.Tech"? <String>[
                  'Semester 1',
                  'Semester 2',
                  'Semester 3',
                  'Semester 4',
                  'Semester 5',
                  'Semester 6',
                  'Semester 7',
                  'Semester 8'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList():<String>[
                  'Semester 1',
                  'Semester 2',
                  'Semester 3',
                  'Semester 4',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    semValue = newValue!;
                  });
                },
              ),
            ),

            //Space left for semester selection
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: takeDetails,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: Colors.red),
                child: _isLoading
                    ? (const SizedBox(
                        height: 14,
                        width: 14,
                        child: SpinKitChasingDots(
                          color: Colors.white,
                        ),
                      ))
                    : const Text('Submit'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
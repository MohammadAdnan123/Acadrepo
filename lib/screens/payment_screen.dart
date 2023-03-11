import 'package:flutter/material.dart';
import 'package:proj1/screens/login_screen.dart';
import 'package:proj1/widgets/text_input.dart';
import 'package:pay/pay.dart';

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
  String dropdownValue = 'Semester 1';
  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _nameEditingController.dispose();
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
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              flex: 1,
              child: Container(),
            ),
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
                value: dropdownValue,
                // Step 4.
                items: <String>[
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
                }).toList(),
                // Step 5.
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
            ),

            //Space left for semester selection
            const SizedBox(
              height: 20,
            ),
                        Flexible(
              flex: 1,
              child: Container(),
            ),
          ]),
        ),
      ),
    );
  }
}

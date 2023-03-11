import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj1/resources/auth_method.dart';
import 'package:proj1/screens/dashboard_screen.dart';
import 'package:proj1/screens/payment_screen.dart';
import 'package:proj1/util/utils.dart';
import 'package:proj1/widgets/text_input.dart';

class LogincScreen extends StatefulWidget {
  const LogincScreen({super.key});

  @override
  State<LogincScreen> createState() => _LogincScreenState();
}

class _LogincScreenState extends State<LogincScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  bool _isLoading = false;
  String dropdownValue = 'Semester 1';
  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethod().loginUser(email: _emailEditingController.text, password: _passwordEditingController.text);
    if(res=="success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardScreen(),));
    }
    else{
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }
  void payUser() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const PaymentScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SvgPicture.asset(
              'assets/random-icon.svg',
              height: 64,
            ),
            const SizedBox(
              height: 32,
            ),
            TextFielInput(
                textEditingController: _emailEditingController,
                hintText: 'College Email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            TextFielInput(
                textEditingController: _passwordEditingController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                isPass: true,),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: Colors.red),
                child: _isLoading ? (const SizedBox(height: 14, width: 14,child: CircularProgressIndicator(color: Colors.white,),)) : const Text('Log in'),
              ),
            ),

            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('Do not have the subscription?'),
                ),
                GestureDetector(
                  onTap: payUser,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Buy here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

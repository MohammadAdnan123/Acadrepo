import 'package:flutter/material.dart';
import 'package:JSAHub/Dash_board/dashboard_screen.dart';
import 'package:JSAHub/resources/auth_method.dart';
import 'package:JSAHub/screens/payment_screen.dart';
import 'package:JSAHub/util/utils.dart';
import 'package:rive/rive.dart';

import 'contact_screen.dart';

class LogincScreen extends StatefulWidget {
  const LogincScreen({super.key});

  @override
  State<LogincScreen> createState() => _LogincScreenState();
}

class _LogincScreenState extends State<LogincScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  bool _isLoading = false;
  String dropdownValue = 'Semester 1';
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authmethod().loginUser(
        email: "${_emailEditingController.text}@smail.iitpkd.ac.in",
        password: _passwordEditingController.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void payUser() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const PaymentScreen(),
    ));
  }
  void contact() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const ContactScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: ListView(children: [
            SizedBox(
              height: 270,
              width: 250,
              child: RiveAnimation.asset(
                "assets/images/login-teddy.riv",
                fit: BoxFit.fitHeight,
                stateMachines: const ["Login Machine"],
                onInit: (artboard) {
                  controller = StateMachineController.fromArtboard(
                    artboard,

                    /// from rive, you can see it in rive editor
                    "Login Machine",
                  );
                  if (controller == null) return;

                  artboard.addController(controller!);
                  isChecking = controller?.findInput("isChecking");
                  numLook = controller?.findInput("numLook");
                  isHandsUp = controller?.findInput("isHandsUp");
                  trigSuccess = controller?.findInput("trigSuccess");
                  trigFail = controller?.findInput("trigFail");
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              focusNode: emailFocusNode,
              controller: _emailEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                focusedBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                enabledBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                filled: true,
                hintText: "Roll no.",
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: (value) {
                numLook?.change(value.length.toDouble());
              },
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              focusNode: passwordFocusNode,
              controller: _passwordEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                focusedBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                enabledBorder: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context)),
                filled: true,
                hintText: "Password",
              ),
              obscureText: true,
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 15,
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
                child: _isLoading
                    ? (const SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ))
                    : const Text('Log in'),
              ),
            ),
            const SizedBox(
              height: 15,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text('For any query, '),
                ),
                GestureDetector(
                  onTap: contact,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Contact us',
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

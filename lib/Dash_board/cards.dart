import 'package:proj1/Dash_board/subject_screen.dart';
import 'package:flutter/material.dart';

class CardLayout extends StatefulWidget {
  const CardLayout({super.key, required this.subjectName, required this.subPath});
  final String subjectName;
  final String subPath;
  @override
  State<CardLayout> createState() => _CardLayoutState();
}

class _CardLayoutState extends State<CardLayout> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubjectScreen(
                      subjectName: widget.subjectName,
                      subPath: widget.subPath,
                    )));
      },
      child: Card(
        color: Colors.redAccent,
        child: Column(
          children: [
            ListTile(
              textColor: Colors.white,
              title: Text(widget.subjectName),
            ),
            // Image.asset('assets/images/card_image.jpg'),
            const Padding(
              padding: EdgeInsets.all(30.0),
            ),
          ],
        ),
      ),
    );
  }
}
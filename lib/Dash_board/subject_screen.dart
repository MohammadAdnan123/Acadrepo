import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:JSAHub/Dash_board/pdf_viewer.dart';
import 'package:path/path.dart' as path;


List<String> totalTabs = ["Notes", "Question Papers", "Books"];

void navigateToPage(BuildContext context, String pdfPath) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => pdfViewer(
              pdfpath: pdfPath,
            )),
  );
  return;
}

class SubjectScreen extends StatefulWidget {
  const SubjectScreen(
      {super.key, required this.subjectName, required this.subPath});
  final String subjectName;
  final String subPath;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

Future<ListResult> getPdfs(String path, String tab) async {
  final sub = FirebaseStorage.instance.ref().child("$path/$tab");
  return await sub.listAll();
}

List<String> pdfs(Future<ListResult> n) {
  List<String> pdfs = [];
  return pdfs;
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  Widget build(BuildContext context) {
    Future<ListResult> Notes = getPdfs(widget.subPath, "Notes");
    Future<ListResult> Papers = getPdfs(widget.subPath, "Papers");
    Future<ListResult> Books = getPdfs(widget.subPath, "Books");
    return Scaffold(
      body: DefaultTabController(
          length: totalTabs.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.redAccent,
              title: Text(widget.subjectName),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Align(
                  alignment: Alignment.center,
                  child: TabBar(
                    isScrollable: true,
                    unselectedLabelStyle:
                        const TextStyle(fontWeight: FontWeight.normal),
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    labelStyle: const TextStyle(fontWeight: FontWeight.normal),
                    tabs: totalTabs.map((String item) {
                      return Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Text(item),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                //column for Notes
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: FutureBuilder(
                            future: Notes,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final itemCount = snapshot.data != null
                                    ? snapshot.data!.items.length
                                    : 0;
                                return GridView.builder(
                                    itemCount: itemCount,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Change this value to set the number of columns
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (itemCount > 0) {
                                        List<String> pdfs = [];
                                        snapshot.data!.items.forEach(
                                          (element) {
                                            pdfs.add((element.fullPath));
                                          },
                                        );
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => pdfViewer(
                                                  pdfpath: pdfs[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0.0,
                                                      3.0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            width: 150.0,
                                            height: 150.0,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.all(11.0),
                                            child: Text(
                                                path.basenameWithoutExtension(
                                                    pdfs[index])),
                                          ),
                                        );
                                      } else {
                                        return const Text("No data added");
                                      }
                                    });
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                
                                return Scaffold(
                              body: Center(
                                child: Image.asset("assets/images/pendulum.gif")
                                )
                            );
                              }
                            }))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: FutureBuilder(
                            future: Papers,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final itemCount = snapshot.data != null
                                    ? snapshot.data!.items.length
                                    : 0;
                                return GridView.builder(
                                    itemCount: itemCount,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Change this value to set the number of columns
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (itemCount > 0) {
                                        List<String> pdfs = [];
                                        snapshot.data!.items.forEach(
                                          (element) {
                                            // print(element.fullPath);
                                            pdfs.add((element.fullPath));
                                          },
                                        );
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => pdfViewer(
                                                  pdfpath: pdfs[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0.0,
                                                      3.0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            width: 150.0,
                                            height: 150.0,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.all(11.0),
                                            child: Text(
                                                path.basenameWithoutExtension(
                                                    pdfs[index])),
                                          ),
                                        );
                                      } else {
                                        return const Text("No data added");
                                      }
                                    });
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                
                                return Scaffold(
                              body: Center(
                                child: Image.asset("assets/images/pendulum.gif")
                                )
                            );
                              }
                            }))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: FutureBuilder(
                            future: Books,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final itemCount = snapshot.data != null
                                    ? snapshot.data!.items.length
                                    : 0;
                                return GridView.builder(
                                    itemCount: itemCount,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Change this value to set the number of columns
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                    ),
                                    itemBuilder:(context, index) {
                                      if (itemCount > 0) {
                                        List<String> pdfs = [];
                                        snapshot.data!.items.forEach(
                                          (element) {
                                            // print(element.fullPath);
                                            pdfs.add((element.fullPath));
                                          },
                                        );
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => pdfViewer(
                                                  pdfpath: pdfs[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.7),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0.0,
                                                      3.0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            width: 150.0,
                                            height: 150.0,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.all(11.0),
                                            child: Text(
                                                path.basenameWithoutExtension(
                                                    pdfs[index])),
                                          ),
                                        );
                                      } else {
                                        return const Text("No data added");
                                      }
                                    });
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                
                               return Scaffold(
                              body: Center(
                                child: Image.asset("assets/images/pendulum.gif")
                                )
                            );
                              }
                            }))
                  ],
                ),
              
              ],
            ),
          )),
    );
  }
}
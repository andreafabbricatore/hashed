import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hashed/views/chatroom.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color buttoncolorone = Colors.white;
  Color buttoncolortwo = Colors.white;
  void buttonAnimation(Color colorone, Color colortwo) {
    setState(() {
      buttoncolorone = colorone;
      buttoncolortwo = colortwo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenheight / 5,
            ),
            Center(
              child: Text(
                "HASHED",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: screenheight / 7,
            ),
            SizedBox(
                height: 200,
                width: screenwidth,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTapDown: (_) {
                          buttonAnimation(
                              Color.fromARGB(255, 238, 238, 238), Colors.white);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ChatRoom(curruser: 'user1'),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        onTapUp: (_) {
                          buttonAnimation(Colors.white, Colors.white);
                        },
                        child: SizedBox(
                            height: 70,
                            width: screenwidth / 1.4,
                            child: Container(
                              child: Center(
                                child: Text(
                                  "New Chat",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: buttoncolorone,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            )),
                      ),
                      GestureDetector(
                        onTapDown: (_) {
                          buttonAnimation(
                              Colors.white, Color.fromARGB(255, 238, 238, 238));
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ChatRoom(
                                curruser: 'user2',
                              ),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        onTapUp: (_) {
                          buttonAnimation(Colors.white, Colors.white);
                        },
                        child: SizedBox(
                            height: 70,
                            width: screenwidth / 1.4,
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Join Chat",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: buttoncolortwo,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                            )),
                      ),
                    ],
                  ),
                ))
          ],
        )));
  }
}

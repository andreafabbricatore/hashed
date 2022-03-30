import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hashed/services/db.dart';
import 'package:hashed/views/dashboard.dart';
import 'dart:async';

class ChatRoom extends StatefulWidget {
  final curruser;
  final chatid;
  ChatRoom({Key? key, required this.curruser, required this.chatid})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _textmessage = TextEditingController();

  void returndashboard() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => Dashboard(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  db_conn db = db_conn();
  late Stream<QuerySnapshot> chatmessages;
  void test() {
    setState(() {});
  }

  late String appbartitle;
  @override
  void initState() {
    chatmessages = db_conn().retrievemessages(widget.chatid);
    appbartitle = widget.chatid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: InkWell(
              child: Text(
                appbartitle,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.chatid));
                setState(() {
                  appbartitle = "Copied!";
                });
                Future.delayed(Duration(milliseconds: 500), () {
                  setState(() {
                    appbartitle = widget.chatid;
                  });
                });
              }),
          shape: Border(bottom: BorderSide(color: Colors.white, width: 0.5)),
          backgroundColor: Colors.black,
          leading: InkWell(
              onTap: () {
                returndashboard();
              },
              child: Icon(CupertinoIcons.back)),
        ),
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: chatmessages,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print("error");
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("loading");
                  return Text("Loading");
                }
                return ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    if (widget.curruser == data['sender']) {
                      return Align(
                          alignment: Alignment.centerRight,
                          child: chatbubble(data['sender'], data['content']));
                    } else {
                      return Align(
                          alignment: Alignment.centerLeft,
                          child: chatbubble(data['sender'], data['content']));
                    }
                  }).toList(),
                );
              })),
      bottomNavigationBar: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: MediaQuery.of(context).viewInsets,
          color: Colors.black,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.symmetric(vertical: 2),
              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: TextField(
                controller: _textmessage,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                    border: InputBorder.none,
                    hintText: 'Type a message',
                    suffixIcon: IconButton(
                      icon: Icon(
                        CupertinoIcons.arrow_right_square_fill,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        print(_textmessage.text);
                        db.sendmessage(
                            _textmessage.text, widget.curruser, widget.chatid);
                        _textmessage.clear();
                      },
                    )),
              ))),
    );
  }
}

Widget chatbubble(sender, content) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      constraints: BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          content,
          style: TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.left,
        ),
      ),
    ),
  );
}

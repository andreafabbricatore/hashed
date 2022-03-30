import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hashed/services/db.dart';
import 'package:hashed/views/dashboard.dart';

class ChatRoom extends StatefulWidget {
  final curruser;
  ChatRoom({Key? key, required this.curruser}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
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
    db.sendmessage('last', 'user2', 'abcdef');
    setState(() {});
  }

  @override
  void initState() {
    chatmessages = db_conn().retrievemessages('abcdef');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: InkWell(
            onTap: () {
              test();
            },
            child: Icon(CupertinoIcons.back)),
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
    );
  }
}

Widget chatbubble(sender, content) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          content,
          style: TextStyle(color: Colors.black, fontSize: 15),
          textAlign: TextAlign.left,
        ),
      ),
    ),
  );
}

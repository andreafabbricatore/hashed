import 'package:cloud_firestore/cloud_firestore.dart';

class db_conn {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  Future createchat(String id) {
    return chats
        .doc(id)
        .set({'user1': true, 'user2': false})
        .then((value) => print("chat created"))
        .catchError((error) => print("failed"));
  }

  Future joinchat(String id) {
    return chats
        .doc(id)
        .update({'user2': true})
        .then((value) => print('user2 joined'))
        .catchError((error) => print('failed'));
  }

  Future sendmessage(String content, String sender, String id) {
    return chats
        .doc(id)
        .collection('messages')
        .add(
            {'content': content, 'sender': sender, 'timestamp': DateTime.now()})
        .then((value) => print("message sent"))
        .onError((error, stackTrace) => print("failed"));
  }

  Stream<QuerySnapshot> retrievemessages(id) {
    return chats
        .doc(id)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

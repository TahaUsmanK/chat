import 'package:chat/core/service/auth_service.dart';
import 'package:chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
//firestore instance
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
//get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firebaseFirestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

//send messages
  Future<void> sendMessages(String message, recieverID) async {
    //get current user info
    final String currentUserID = _authService.getCurrentUser()!.uid;
    final String currentUserEmail = _authService.getCurrentUser()!.email!;
    final Timestamp timestamp = Timestamp.now();
    //create message
    Message newMessage = Message(
      message: message,
      senderID: currentUserID,
      recieverID: recieverID,
      senderEmail: currentUserEmail,
      timestamp: timestamp,
    );
    //constuct chat room ID for two users
    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    final String chatRoomID = ids.join('_');
    //add message to firestore
    await _firebaseFirestore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

//receive messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    final String chatRoomID = ids.join('_');
    return _firebaseFirestore
        .collection('chats')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

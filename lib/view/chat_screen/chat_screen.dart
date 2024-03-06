import 'package:chat/core/service/auth_service.dart';
import 'package:chat/core/service/chat_service.dart';
import 'package:chat/core/widgets/chat_bubble.dart';
import 'package:chat/core/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  ChatScreen(
      {super.key, required this.recieverEmail, required this.recieverID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(
      () {
        if (!focusNode.hasFocus) {
          Future.delayed(Duration(milliseconds: 500), () => scrollDown());
        }
        ;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    messageController.dispose();
  }

//Scroll controller
  ScrollController scrollController = ScrollController();

  void scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //send messages
  void sendMessages() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessages(
          messageController.text, widget.recieverID);
      messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.recieverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(children: [
        //message list
        Expanded(
          child: _buildMessageList(),
        ),
        //message input
        _buildUserInput(),
      ]),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(senderID, widget.recieverID),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          //loading
          if (ConnectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //return list view
          return ListView(
            controller: scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    //message allignment
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data['message'], isCurrentUser: isCurrentUser)
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: MyTextField(
            controller: messageController,
            hintText: 'Enter your message',
            labelText: 'Message',
            obscureText: false,
            focusNode: focusNode,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 25),
          decoration:
              BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          child: IconButton(
            onPressed: sendMessages,
            icon: Icon(
              Icons.arrow_upward_rounded,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class IndividualChat extends StatefulWidget {
  static const id = "IndividualChat";
  // final String name;
  // const IndividualChat({required this.name});

  @override
  _IndividualChatState createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  bool emojiShowing = false;
  TextEditingController _messageController = new TextEditingController();

  messageBubble(String id, String message) {
    if (id == FirebaseAuth.instance.currentUser!.uid) {
      return BubbleNormal(
        text: message,
        isSender: true,
        color: Color(0xFFDCF7C4),
        tail: true,
        seen: true,
        sent: true,
        delivered: true,
        textStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      );
    } else {
      return BubbleNormal(
        text: message,
        isSender: false,
        color: Color(0xFFFFFFFF),
        tail: true,
        seen: true,
        sent: true,
        delivered: true,
        textStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      );
    }
  }

  _onEmojiSelected(Emoji emoji) {
    _messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
  }

  _onBackspacePressed() {
    _messageController
      ..text = _messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                child: CircleAvatar(
                  radius: 30,
                  child: Image.asset("images/default_dp.png"),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Positioned(
                child: Text("name"),
              ),
            ],
          ),
        ),
        actions: [],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ListView.builder(itemBuilder: (BuildContext context, int index) {
            //   return messageBubble(, )
            // })
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 8.0),
                          IconButton(
                            icon: Icon(Icons.insert_emoticon),
                            iconSize: 30.0,
                            color: Theme.of(context).hintColor,
                            onPressed: () {
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                            },
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type a message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.attach_file,
                              size: 30.0, color: Theme.of(context).hintColor),
                          SizedBox(width: 8.0),
                          Icon(Icons.camera_alt,
                              size: 30.0, color: Theme.of(context).hintColor),
                          SizedBox(width: 8.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                    onEmojiSelected: (Category category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: const Config(
                        columns: 7,
                        emojiSizeMax: 32.0,
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        initCategory: Category.RECENT,
                        bgColor: Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        noRecentsText: 'No Recents',
                        noRecentsStyle:
                            TextStyle(fontSize: 20, color: Colors.black26),
                        categoryIcons: CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

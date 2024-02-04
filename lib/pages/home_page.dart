import 'dart:convert';
import 'package:chatgpt/components/chat_widget.dart';
import 'package:chatgpt/components/drop_down.dart';
import 'package:chatgpt/components/messanger.dart';
import 'package:chatgpt/constants/constant.dart';
import 'package:chatgpt/constants/openai.dart';
import 'package:chatgpt/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  bool isTyping = false;
  late FocusNode focusNode;
  List<ChatModels> chatList1 = [];
  // String role = '';
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    textController;
    scrollController = ScrollController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<List<ChatModels>> makeOpenAIRequest({String? inputText}) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $OPEN_AI_API_KEY'
      },
      body: jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": inputText,
            }
          ],
          "temperature": 0.7
        },
      ),
    );
    final responseData = jsonDecode(response.body);
    // role = responseData['choices'][0]['message']['role'];
    // print(role);
    List<ChatModels> chatList = [];

    if (response.statusCode == 200) {
      if (responseData['choices'].length > 0) {
        chatList = List.generate(
          responseData['choices'].length,
          (index) => ChatModels(
            msg: responseData['choices'][index]['message']['content'],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } else {
      debugPrint('Error accessing OpenAI API: ${response.statusCode}');

      return chatList;
    }
  }

  Future<void> myBottomSheet() async {
    await showModalBottomSheet(
      backgroundColor: scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Chosen Model",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Flexible(
                flex: 2,
                child: MyDropDownWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async => await myBottomSheet(),
            icon: const Icon(Icons.more_vert),
          ),
        ],
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          "ChatGPT",
          style: TextStyle(
            fontSize: 25,
            color : Colors.white,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/openai.png",
                ),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Flexible(
              child: FutureBuilder(
                future: makeOpenAIRequest(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey.shade500,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      // List scroll controller
                      controller: scrollController,
                      itemCount: chatList1.length,
                      itemBuilder: (context, index) {
                        return ChatWidget(
                          chatIndex: chatList1[index].chatIndex,
                          msg: chatList1[index].msg.toString(),
                        );
                      },
                    );
                  } else if (chatList1.isEmpty) {
                    return const Center(
                      child: Text(
                        "Error Occured",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                      ),
                    );
                  }
                }),
              ),
            ),
            if (isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 25,
              ),
            ],
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(32),
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            focusNode: focusNode,
                            controller: textController,
                            // onSubmitted: (value) async {
                            //   await sendMessage();
                            // },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Message",
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async => await sendMessage(),
                        icon: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  void scrollListToEnd() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessage() async {
    if (isTyping) {
      MyScaffoldMessanger.messanger(
          context, "You can only send one message at a time");
      return;
    }
    if (textController.text.isEmpty) {
      MyScaffoldMessanger.messanger(context, "Please enter an message");
      return;
    }

    try {
      String message = textController.text;
      // Using another String because we are clearing the textController and then using it again in the function
      setState(() {
        isTyping = true;
        chatList1.add(
          ChatModels(
            msg: message,
            chatIndex: 0,
          ),
        );
        textController.clear();
        focusNode.unfocus();
      });
      chatList1.addAll(
        await makeOpenAIRequest(
          inputText: message,
        ),
      );
      // setState(() {});
    } catch (e) {
      if (context.mounted) {
        MyScaffoldMessanger.messanger(context, e.toString());
      }

      debugPrint(e.toString());
    } finally {
      setState(() {
        scrollListToEnd();
        isTyping = false;
      });
    }
  }
}

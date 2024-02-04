import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt/constants/constant.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key, required this.msg, required this.chatIndex})
      : super(key: key);

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0 ? "assets/user_image.png" : "assets/chat_logo.png",
                  height: 60,
                  width: 30,
                ),
                const SizedBox(
                  width: 4,
                  height: 10,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "\nYou",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                msg,
                                style: const TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "\nCHATGPT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  // fontWeight: FontWeight.w700,
                                ),
                                child: AnimatedTextKit(
                                  displayFullTextOnTap: true,
                                  totalRepeatCount: 1,
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      msg,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

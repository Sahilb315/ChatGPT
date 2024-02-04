class ChatModels {
  final String msg;
  final int chatIndex;

  ChatModels({required this.msg, required this.chatIndex});

  factory ChatModels.fromJson(Map<String, dynamic> json) {
    return ChatModels(
      msg: json['msg'],
      chatIndex: json['chatIndex'],
    );
  }
}

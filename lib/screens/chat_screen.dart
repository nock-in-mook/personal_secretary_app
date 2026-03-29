import 'package:flutter/material.dart';
import 'home_screen.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class ChatScreen extends StatefulWidget {
  final Secretary secretary;

  const ChatScreen({super.key, required this.secretary});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 仮の会話データ
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: 'おはよう！今日の予定を確認するよ',
      isUser: true,
      time: '09:00',
    ),
    const ChatMessage(
      text: 'べ、別にあんたに言われなくても確認するつもりだったし…\n\n📅 今日の予定:\n・10:00 ミーティング\n・14:00 歯医者\n・18:00 買い物',
      isUser: false,
      time: '09:00',
    ),
    const ChatMessage(
      text: '歯医者キャンセルして',
      isUser: true,
      time: '09:05',
    ),
    const ChatMessage(
      text: '14:00の歯医者をキャンセルするの？\nほんとにいいの？虫歯放置したら痛くなるわよ…\n\nキャンセルする / やっぱり行く',
      isUser: false,
      time: '09:05',
    ),
    const ChatMessage(
      text: 'やっぱり行くわ',
      isUser: true,
      time: '09:06',
    ),
    const ChatMessage(
      text: 'ふん、最初からそう言いなさいよ。\n予定はそのままにしておくわ。',
      isUser: false,
      time: '09:06',
    ),
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        time: TimeOfDay.now().format(context),
      ));
    });
    _controller.clear();

    // スクロールを最下部に
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });

    // 仮の自動返信（実際はAPI呼び出し）
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: '…ちょっと考え中。',
          isUser: false,
          time: TimeOfDay.now().format(context),
        ));
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: widget.secretary.accentColor,
              child: Icon(widget.secretary.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.secretary.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.secretary.personality,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // メッセージ一覧
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          // 入力エリア
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // キャラアイコン（相手のみ）
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: widget.secretary.accentColor,
                child: Icon(widget.secretary.icon, color: Colors.white, size: 16),
              ),
            ),

          // 時間（ユーザー側は左に）
          if (isUser)
            Padding(
              padding: const EdgeInsets.only(right: 4, bottom: 2),
              child: Text(
                message.time,
                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              ),
            ),

          // 吹き出し
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFE94560)
                    : const Color(0xFF1E2A4A),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
              ),
            ),
          ),

          // 時間（相手側は右に）
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 2),
              child: Text(
                message.time,
                style: TextStyle(fontSize: 10, color: Colors.grey[700]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        8, 8, 8,
        8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        border: Border(top: BorderSide(color: Color(0xFF2A2A4A))),
      ),
      child: Row(
        children: [
          // 添付ボタン
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.grey[500]),
            onPressed: () {},
          ),
          // テキスト入力
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'メッセージを入力…',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF0D0D1A),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 4),
          // 送信ボタン
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE94560),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

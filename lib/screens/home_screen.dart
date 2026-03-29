import 'package:flutter/material.dart';
import 'chat_screen.dart';

// 仮のキャラデータ
class Secretary {
  final String name;
  final String personality;
  final String lastMessage;
  final String time;
  final int unread;
  final Color accentColor;
  final IconData icon;

  const Secretary({
    required this.name,
    required this.personality,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    required this.accentColor,
    required this.icon,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 現役秘書
  static const List<Secretary> activeSecretaries = [
    Secretary(
      name: 'ユイ',
      personality: 'ツンデレ秘書',
      lastMessage: 'べ、別にあんたの予定なんか気にしてないし…',
      time: '18:30',
      unread: 2,
      accentColor: Color(0xFFE94560),
      icon: Icons.face_2,
    ),
    Secretary(
      name: 'おばちゃん',
      personality: '関西のおばちゃん',
      lastMessage: 'キョウちゃん、ご飯ちゃんと食べてる？',
      time: '15:22',
      unread: 0,
      accentColor: Color(0xFFFF9800),
      icon: Icons.face_3,
    ),
    Secretary(
      name: 'セバスチャン',
      personality: '完璧執事',
      lastMessage: '明日のスケジュールをお伝えいたします',
      time: '12:00',
      unread: 1,
      accentColor: Color(0xFF2196F3),
      icon: Icons.face_6,
    ),
  ];

  // 元秘書
  static const List<Secretary> formerSecretaries = [
    Secretary(
      name: 'サージ',
      personality: '鬼軍曹',
      lastMessage: '貴様…元気でやっているか？',
      time: '3日前',
      unread: 1,
      accentColor: Color(0xFF4CAF50),
      icon: Icons.face_5,
    ),
    Secretary(
      name: 'ミケ',
      personality: '猫',
      lastMessage: 'にゃ…（窓の外を見ている）',
      time: '1週間前',
      unread: 0,
      accentColor: Color(0xFF9C27B0),
      icon: Icons.pets,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Secretary',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // 現役秘書セクション
          _buildSectionHeader('秘書'),
          ...activeSecretaries.map((s) => _buildSecretaryTile(context, s)),

          const SizedBox(height: 8),

          // 元秘書セクション
          _buildSectionHeader('元秘書'),
          ...formerSecretaries.map(
            (s) => _buildSecretaryTile(context, s, isFormer: true),
          ),

          const SizedBox(height: 80),
        ],
      ),
      // 下部ナビゲーション
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF16213E),
        selectedItemColor: const Color(0xFFE94560),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'チャット'),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: 'メモ'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'リマインド',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSecretaryTile(
    BuildContext context,
    Secretary secretary, {
    bool isFormer = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: secretary.accentColor.withValues(alpha: isFormer ? 0.3 : 0.8),
        child: Icon(secretary.icon, color: Colors.white, size: 28),
      ),
      title: Row(
        children: [
          Text(
            secretary.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isFormer ? Colors.grey : Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            secretary.personality,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      subtitle: Text(
        secretary.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey[500], fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            secretary.time,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 4),
          if (secretary.unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE94560),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${secretary.unread}',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(secretary: secretary),
          ),
        );
      },
    );
  }
}

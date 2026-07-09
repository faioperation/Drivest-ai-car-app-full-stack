import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:drivest_office/home/pages/saved_page.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../main_bottom_nav_screen.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});
  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  static const primary = Color(0xff015093);
  static const pageBg  = Color(0xffF3F5F7);

  final TextEditingController _input = TextEditingController();

  // === API config ===
  // final String _baseUrl = 'https://web-scrapping.drivestai.com/ai-suggest';

  // === Conversation state ===
  final _messages = <_Msg>[
    _Msg('Hi! Ask me anything about finding a car.', false),
  ];

  // int _stage = 0;            // API-এর stage এখানে রাখি
  bool _isSending = false;   // typing indicator

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<http.Response> _postWithRedirects(
      Uri url, {
        required Map<String, String> headers,
        required String body,
        int maxRedirects = 6,
        Duration timeout = const Duration(seconds: 20),
      }) async {
    var current = url;
    for (var i = 0; i <= maxRedirects; i++) {
      final res = await http.post(current, headers: headers, body: body).timeout(timeout);

      // সফল হলে রিটার্ন
      if (res.statusCode == 200) return res;

      // Redirect হলে Location পড়ে নতুন URL বানাও
      final isRedirect = {301, 302, 307, 308}.contains(res.statusCode);
      final loc = res.headers['location'];
      if (isRedirect && loc != null && loc.isNotEmpty) {
        // Relative/absolute— দুটোই সাপোর্ট
        current = current.resolve(loc);
        continue;
      }

      // অন্য যেকোনো কেসে এই রেসপন্সই রিটার্ন
      return res;
    }
    throw Exception('Too many redirects');
  }



  Future<void> _sendMessage(String userText) async {
    setState(() {
      _messages.add(_Msg(userText, true));
      _isSending = true;
    });

    try {
      final uri = Uri.parse(Urls.aiSuggestUrl);

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final body = jsonEncode({
        'prompt': userText,
      });

      final res = await _postWithRedirects(uri, headers: headers, body: body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final reply = (data['suggestion'] ?? 'Sorry, I could not understand.').toString();

        setState(() {
          _messages.add(_Msg(reply, false));
        });
      } else {
        setState(() {
          _messages.add(_Msg('Server error (${res.statusCode}). Please try again.', false));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(_Msg('Network error: $e', false));
      });
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    const sheetH = 80.0;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('AI Suggestion', style: TextStyle(color: Colors.black)),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainBottomNavScreen()),
                  (route) => false,
            ),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  color: Color(0xffCCDCE9), shape: BoxShape.circle),
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: SavedPage.primary),
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.black12),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, sheetH),
        itemCount: _messages.length + (_isSending ? 1 : 0),
        itemBuilder: (context, i) {
          if (_isSending && i == _messages.length) {
            return const _TypingBubble();
          }
          return _Bubble(msg: _messages[i]);
        },
      ),

      bottomSheet: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0x14000000))),
          ),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xffCCDCE9)),
                  ),
                  child: TextField(
                    controller: _input,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (t) {
                      if (t.trim().isEmpty || _isSending) return;
                      _input.clear();
                      _sendMessage(t.trim());
                    },
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  if (_input.text.trim().isEmpty || _isSending) return;
                  final text = _input.text.trim();
                  _input.clear();
                  _sendMessage(text);
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xffCCDCE9)),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                  child: const Icon(Icons.send_rounded, color: primary, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool isMe;
  const _Msg(this.text, this.isMe);
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xff015093);
    const inBg    = Color(0xffE9EDF2);

    final align = msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = msg.isMe ? primary : inBg;
    final textColor = msg.isMe ? Colors.white : Color(0xFF333333);
    final radius = BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: msg.isMe ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight: msg.isMe ? const Radius.circular(4) : const Radius.circular(16),
    );

    return Column(
      crossAxisAlignment: align,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .72),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
            child: Text(msg.text, style: TextStyle(color: textColor, fontSize: 13.5, height: 1.35)),
          ),
        ),
      ],
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble({super.key});
  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Text('typing…', style: TextStyle(fontSize: 12, color: Colors.black54)),
      ),
    );
  }

}

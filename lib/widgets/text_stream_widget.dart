import 'package:flutter/material.dart';
import 'dart:async';

class TextStreamWidget extends StatefulWidget {
  final String text;

  const TextStreamWidget({
    required this.text,
    super.key,
  });

  @override
  State<TextStreamWidget> createState() => _TextStreamWidgetState();
}

class _TextStreamWidgetState extends State<TextStreamWidget> {
  StreamController<String>? _streamController;
  String _typedText = '';

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<String>();
    _startTyping();
  }

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }

  void _startTyping() async {
    for (var i = 0; i < widget.text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      _streamController?.add(widget.text.substring(0, i + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Build TextStreamWidget');
    return StreamBuilder<String>(
      stream: _streamController?.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          debugPrint(
              'TextStreamWidget has error: ${snapshot.error.toString()}');
          return const Text('');
        }
        _typedText = snapshot.data!;
        debugPrint('TextStreamWidget without');
        return Text(_typedText,
            style: const TextStyle(fontSize: 16, color: Colors.black));
      },
    );
  }
}

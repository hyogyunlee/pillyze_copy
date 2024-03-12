import 'package:flutter/material.dart';
import 'package:async/async.dart';

class test extends StatefulWidget {
  const test({super.key});
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> with SingleTickerProviderStateMixin {
  final AsyncMemoizer<String> _memoizer = AsyncMemoizer();
  final Duration _debounceDuration = Duration(seconds: 2);
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        _memoizer.runOnce(() async {
          await Future.delayed(_debounceDuration);
          setState(() {
            _searchText = value;
          });
          print('hi');
          return _searchText;
        });
      },
      decoration: InputDecoration(
        hintText: '검색어를 입력하세요',
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PreviewVideoScreen extends StatefulWidget {
  const PreviewVideoScreen({Key? key}) : super(key: key);

  @override
  State<PreviewVideoScreen> createState() => _PreviewVideoScreenState();
}

class _PreviewVideoScreenState extends State<PreviewVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem trước video'),
        centerTitle: true,
      ),
    );
  }
}

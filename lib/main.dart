import 'package:docExpiry/ui/doclist.dart';
import 'package:flutter/material.dart';

void main() => runApp(DocExpiryApp());

class DocExpiryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'DocExpiry',
      theme: new ThemeData(primarySwatch: Colors.cyan),
      home: DocList(),
    );
  }
}

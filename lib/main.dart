import 'package:flutter/material.dart';

void main() => runApp(DocExpiryApp());

class DocExpiryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DocExpiry',
      theme: new ThemeData(primarySwatch: Colors.cyan),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'DOC EXPIRY',
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          height: 100,
          child: Material(
            elevation: 6.0,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 5,
                bottom: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Test1',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  Text('0 days left', style: TextStyle(fontSize: 20.0)),
                  Text('Exp 16 May 2020', style: TextStyle(fontSize: 15.0)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

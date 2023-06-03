import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Console extends StatefulWidget {
  String output;
  Console({Key? key, required this.output}) : super(key: key);

  @override
  State<Console> createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.output;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C2834),
        title: const Text("Console",
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Container(
          width: 390.0,
          height: 790,
          color: const Color(0xff0F161F),
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    widget.output,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  )))),
    );
  }
}

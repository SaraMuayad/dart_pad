import 'dart:convert';

import 'package:code_text_field/code_text_field.dart';
import 'package:dart_pad/screen/console.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_highlighter/themes/an-old-hope.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighter/themes/dark.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:http/http.dart';

import '../service/compiler_process.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String result = "";
  final APICompiler _apiCompiler = new APICompiler();

  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    var source = "void main() {\n    print(\"Hello, world!\");\n}";

    _codeController = CodeController(
      text: source,
      language: dart,
      patternMap: {
        r'".*' '"': const TextStyle(color: Colors.red),
        r';': const TextStyle(color: Color(0xff03d2f9)),
        r'[0-9]': const TextStyle(color: Color.fromARGB(255, 210, 230, 82)),
        r'[a-zA-Z]': const TextStyle(color: Color.fromARGB(255, 248, 249, 251)),
        r'[//] [a-zA-Z]': const TextStyle(color: Color(0xff909CC3)),
        r'[/**/]': const TextStyle(color: Color(0xff909CC3)),
      },
      stringMap: {
        "void": const TextStyle(color: Colors.white),
        "main": const TextStyle(color: Color(0xff03d2f9)),
        "print": const TextStyle(color: Color(0xff03d2f9)),
        "for": const TextStyle(color: Color(0xff34b356)),
        "while": const TextStyle(color: Color(0xff34b356)),
        "do": const TextStyle(color: Color(0xff34b356)),
        "in": const TextStyle(color: Color(0xff34b356)),
        "if": const TextStyle(color: Color(0xff34b356)),
        "as": const TextStyle(color: Color(0xff34b356)),
        "else": const TextStyle(color: Color(0xff34b356)),
        "switch": const TextStyle(color: Color(0xff34b356)),
        "break": const TextStyle(color: Color(0xff34b356)),
        "continue": const TextStyle(color: Color(0xff34b356)),
        "try": const TextStyle(color: Color(0xff34b356)),
        "catch": const TextStyle(color: Color(0xff34b356)),
        "remove": const TextStyle(color: Color(0xff34b356)),
        "add": const TextStyle(color: Color(0xff34b356)),
        "first": const TextStyle(color: Color(0xff34b356)),
        "last": const TextStyle(color: Color(0xff34b356)),
        "isEmpty": const TextStyle(color: Color(0xff34b356)),
        "length": const TextStyle(color: Color(0xff34b356)),
        "isNotEmpty": const TextStyle(color: Color(0xff34b356)),
        "forEach": const TextStyle(color: Color(0xff34b356)),
        "Set": const TextStyle(color: Color(0xff34b356)),
        "elementAt": const TextStyle(color: Color(0xff34b356)),
        "addAll": const TextStyle(color: Color(0xff34b356)),
        "contains": const TextStyle(color: Color(0xff34b356)),
        "union": const TextStyle(color: Color(0xff34b356)),
        "intersection": const TextStyle(color: Color(0xff34b356)),
        "Map": const TextStyle(color: Color(0xff34b356)),
        "containsKey": const TextStyle(color: Color(0xff34b356)),
        "containsValue": const TextStyle(color: Color(0xff34b356)),
        "Iterable": const TextStyle(color: Color(0xff34b356)),
        "this": const TextStyle(color: Color(0xff34b356)),
        "where": const TextStyle(color: Color(0xff34b356)),
        "split": const TextStyle(color: Color(0xff34b356)),
        "Future": const TextStyle(color: Color(0xff34b356)),
        "Duration": const TextStyle(color: Color(0xff34b356)),
        "delayed": const TextStyle(color: Color(0xff34b356)),
        "async": const TextStyle(color: Color(0xff34b356)),
        "await": const TextStyle(color: Color(0xff34b356)),
        "then": const TextStyle(color: Color(0xff34b356)),
        "throw": const TextStyle(color: Color(0xff34b356)),
        "File": const TextStyle(color: Color(0xff34b356)),
        "entries": const TextStyle(color: Color(0xff34b356)),
        "List": const TextStyle(color: Color(0xff34b356)),
        "readAsString": const TextStyle(color: Color(0xff34b356)),
        "toList": const TextStyle(color: Color(0xff34b356)),
        "e": const TextStyle(color: Color(0xff34b356)),
        "import": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "map": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "int": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "float": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "double": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "var": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "bool": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "final": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "const": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "String": const TextStyle(color: Color.fromARGB(255, 208, 121, 193)),
        "true": const TextStyle(color: Color(0xffff916d)),
        "false": const TextStyle(color: Color(0xffff916d)),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1C2834),
          leading: PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                      value: 0,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Editor()),
                          ).then((value) => setState(() {}));
                        },
                        child: const Text(
                          "New Pad",
                          style: TextStyle(color: Color(0xff1C2834)),
                        ),
                      )),
                  PopupMenuItem<int>(
                    value: 1,
                    child: TextButton(
                      onPressed: () {
                        _codeController.clear();
                      },
                      child: const Text(
                        "Rest",
                        style: TextStyle(color: Color(0xff1C2834)),
                      ),
                    ),
                  ),
                ];
              }),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(
                width: 25,
                height: 25,
                image: AssetImage('assets/images/dart-192.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "DartPad",
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 23),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      result = _codeController.text.toString();
                      _apiCompiler.getCompiler(result);

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Console(output: _apiCompiler.output)));
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            Row(children: [
              SizedBox(
                  width: 390.0,
                  height: 741.0,
                  child: CodeField(
                    background: const Color(0xff0F161F),
                    controller: _codeController,
                    textStyle:
                        const TextStyle(fontFamily: 'SourceCode', fontSize: 20),
                    minLines: 14,
                  )),
            ]),
          ],
        ));
  }
}

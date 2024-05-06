import 'dart:convert';

import 'package:counter/secure/db.dart';
import 'package:counter/ui/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class SelfCounterWidget extends StatefulWidget {
  const SelfCounterWidget({Key? key}) : super(key: key);

  @override
  State<SelfCounterWidget> createState() => _SelfCounterWidgetState();
}

class _SelfCounterWidgetState extends State<SelfCounterWidget> {
  final dbSecure = DbSecure();
  String suggestData = "";
  // Future<void> suggest() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://${dbSecure.DB_HOST}/kiosk/item/ai/suggest'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //     );
  //     print('headers : ${response.headers.toString()}');

  //     print(utf8.encode(response.body).toString());

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         suggestData = response.body;
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: Row(
        children: [
          Drawer(
            backgroundColor: Colors.white10,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 60,
                  child: buildCustomButton(
                    text: '인기상품',
                    icon: Icons.menu_book,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 60,
                  child: buildCustomButton(
                    text: '상품추천',
                    icon: Icons.settings_suggest,
                    onPressed: () {
                      // suggest();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

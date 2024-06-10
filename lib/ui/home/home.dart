// ignore_for_file: must_be_immutable

import 'package:counter/provider/bottom_navigation_provider.dart';
import 'package:counter/ui/components/bottom_navigation_widget.dart';
import 'package:counter/ui/components/navigation_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  late BottomNavigationProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BottomNavigationProvider>(context);
    return Scaffold(
      body: navigationBody(provider),
      bottomNavigationBar: bottomNavigationBarWidget(provider),
    );
  }
}

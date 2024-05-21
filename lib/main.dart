import 'package:counter/provider/bottom_navigation_provider.dart';
import 'package:counter/provider/count_provider.dart';
import 'package:counter/ui/_constant/util/app_router.dart';
import 'package:counter/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BSM SelfCounter',
      debugShowCheckedModeBanner: false,
      getPages: AppRouter,
      initialRoute: '/',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => CountProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => BottomNavigationProvider(),
          ),
        ],
        child: Home(),
      ),
    );
  }
}

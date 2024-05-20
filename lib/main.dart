import 'package:counter/provider/bottom_navigation_provider.dart';
import 'package:counter/provider/count_provider.dart';
import 'package:counter/ui/_constant/util/app_router.dart';
import 'package:counter/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:counter/lib/secure/db_secure.dart'; // DbSecure 클래스 임포트

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // DbSecure 초기화
  final dbSecure = await DbSecure.load();
  print('DB_HOST: ${dbSecure.DB_HOST}');

  runApp(MyApp(dbSecure: dbSecure));
}

class MyApp extends StatelessWidget {
  final DbSecure dbSecure;

  const MyApp({Key? key, required this.dbSecure}) : super(key: key);

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
          Provider<DbSecure>.value(
            value: dbSecure,
          ),
        ],
        child: Home(),
      ),
    );
  }
}

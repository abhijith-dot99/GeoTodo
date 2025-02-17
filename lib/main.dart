import 'package:flutter/material.dart';
import 'package:geotodo/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/user_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // for api loading from env folder
  runApp(
    // Using MultiProvider to user and todo for the app.
    MultiProvider(
      providers: [
       // Provides UserProvider to the app, managing user-related data
        ChangeNotifierProvider(create: (context) => UserProvider()),
        // Provides TodoProvider to the app, managing to-do list-related data
        ChangeNotifierProvider(create: (context) => TodoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomeScreen(), // Home screen of the app
    );
  }
}

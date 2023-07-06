import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intagram/providers/user_provider.dart';
import 'package:intagram/responsive/mobilesscreenlayout.dart';
import 'package:intagram/responsive/responsive_layout_screen.dart';
import 'package:intagram/responsive/websreenlayout.dart';
import 'package:intagram/screens/login_screen.dart';
import 'package:intagram/ultils/colors.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'intagram',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Responsivelayout(
                    WebScreenLayout: WebScreenLayout(),
                    MobileScreenLayout: MobileScreenLayout());
              }
            } else {
              if (snapshot.hasError) {
                return const LoginScreen();
              }
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

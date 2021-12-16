import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nava/appTest/record_audio.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/constants/MyColors.dart';
import 'helpers/providers/FcmTokenProvider.dart';
import 'helpers/providers/UserProvider.dart';
import 'helpers/providers/visitor_provider.dart';
import 'layouts/auth/splash/Splash.dart';


import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EasyLocalization(
    child: MyApp(),
    supportedLocales: [Locale('ar', 'EG'), Locale('en', 'US')],
    path: 'assets/langs',
    fallbackLocale: Locale('ar', 'EG'),
    startLocale: Locale('ar', 'EG'),
  ));}






class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await fcm();
    });
    super.initState();
  }

  Future fcm() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('____User granted permission____');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('____User granted provisional permission____');
    } else {
      print('____User declined or has not accepted permission____');
    }

    FcmTokenProvider fcnTokenProvider =
    Provider.of<FcmTokenProvider>(navigatorKey.currentContext,listen: false);
    String token = await FirebaseMessaging.instance.getToken();
    print("--------------------===>>>   $token");
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("fcm_token", token);
    fcnTokenProvider.fcmToken=token;
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
          print(message.notification.body);
          print(message.notification.body);
          print(message.notification.body);
          RemoteNotification notification = message.notification;
          AndroidNotification android = message.notification?.android;
          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription:channel.description,
                    icon: "launch_background",
                    // other properties...
                  ),
                  iOS: IOSNotificationDetails(
                    subtitle: "mohamed",
                  )
                )
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FcmTokenProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => VisitorProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Nava',
        theme: ThemeData(
          primaryColor: MyColors.primary,
          fontFamily: GoogleFonts.almarai().fontFamily,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home:
        Splash(navigatorKey: navigatorKey,),
        // SimpleRecorder(),

        builder: EasyLoading.init(),
      ),
    );
  }
}

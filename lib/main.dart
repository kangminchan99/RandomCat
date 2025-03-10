import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:randomcat/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _trackingTransparencyRequest();
  });
  MobileAds.instance.initialize();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

Future<String?> _trackingTransparencyRequest() async {
  await Future.delayed(const Duration(milliseconds: 1000));

  final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.authorized) {
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    return uuid;
  } else if (status == TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    return uuid;
  }

  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Cat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

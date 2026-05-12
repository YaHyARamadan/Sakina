import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_router.dart';
import 'features/quran_screen/logic/quran_provider.dart';
import 'features/prayer_times_screen/logic/prayer_provider.dart';
import 'features/azkar_screen/logic/azkar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuranProvider()),
        ChangeNotifierProvider(create: (_) => PrayerProvider()),
        ChangeNotifierProvider(create: (_) => AzkarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72, 800.72),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'نور',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.tajawalTextTheme(),
        ),
        home: AppRouter(),
      ),
    );
  }
}

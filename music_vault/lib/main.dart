import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vault/firebase_options.dart';
import 'package:music_vault/pages/splash_screen.dart';
import 'package:music_vault/utils/pitch_cubit.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:record/record.dart';
import 'styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AudioRecorder>(
          create: (context) => AudioRecorder(),
        ),
        RepositoryProvider<PitchDetector>(
          create: (context) => PitchDetector(),
        ),
        RepositoryProvider<PitchHandler>(
          create: (context) => PitchHandler(InstrumentType.guitar),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<PitchCubit>(
              create: (context) => PitchCubit(
                context.read<AudioRecorder>(),
                context.read<PitchDetector>(),
                context.read<PitchHandler>(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Music Vault',
            theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: CustomColors.primaryColor),
              useMaterial3: true,
            ),
            home: const SplashScreen(), // Show splash screen on startup
          )),
    );
  }
}

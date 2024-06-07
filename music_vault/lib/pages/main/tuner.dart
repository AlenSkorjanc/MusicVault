import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/pitch_cubit.dart';

class Tuner extends StatelessWidget {
  const Tuner({super.key});

  @override
  Widget build(BuildContext context) {
    final pitchCubitState = context.watch<PitchCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tuner',
          style: TextStyles.heading2,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              pitchCubitState.note,
              style: TextStyles.heading1,
            ),
            Text(
              pitchCubitState.status,
              style: TextStyles.paragraph1,
            ),
          ],
        ),
      ),
    );
  }
}

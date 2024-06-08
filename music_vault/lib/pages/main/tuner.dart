import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_vault/components/dropdown.dart';
import 'package:music_vault/styles/colors.dart';
import 'package:music_vault/styles/dimes.dart';
import 'package:music_vault/styles/fonts.dart';
import 'package:music_vault/utils/pitch_cubit.dart';

class Tuner extends StatefulWidget {
  const Tuner({super.key});

  @override
  State<Tuner> createState() => _TunerState();
}

class _TunerState extends State<Tuner> {
  String selectedInstrument = 'guitar';

  @override
  Widget build(BuildContext context) {
    final pitchCubitState = context.watch<PitchCubit>().state;

    // Calculate the offset in terms of diffCents
    double offset = pitchCubitState.diffCents.clamp(-40.0, 40.0);
    double percentage = (offset * -1 + 40) / 80;

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
              pitchCubitState.note.isNotEmpty ? pitchCubitState.note : 'N/A',
              style: TextStyles.heading1,
            ),
            const SizedBox(height: Dimens.spacingS),
            const SizedBox(
              width: 208,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('-40', style: TextStyles.paragraph2),
                  Spacer(),
                  Text('0', style: TextStyles.paragraph2),
                  Spacer(),
                  Text('40', style: TextStyles.paragraph2),
                ],
              ),
            ),
            Container(
              width: 192,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.secondaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 4,
                        height: 20,
                        color: pitchCubitState.statusColor,
                        margin: EdgeInsets.only(left: 192 * percentage - 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimens.spacingS),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingXXL),
              child: Text(
                'Play a note on your instrument and watch the bar to see if you are in tune.',
                textAlign: TextAlign.center,
                style: TextStyles.paragraph2,
              ),
            ),
            const SizedBox(height: Dimens.spacingL * 2),
            SizedBox(
              width: 192,
              child: Dropdown(
                labelText: 'Select Instrument',
                value: selectedInstrument,
                items: const ['guitar', 'ukulele'],
                onChanged: (String? newValue) {
                  setState(() {
                    selectedInstrument = newValue!;
                  });
                },
                hasError: false,
              ),
            ),
            const SizedBox(height: Dimens.spacingS),
            Image.asset(
              selectedInstrument == 'guitar'
                  ? 'assets/images/guitar_tuning.png'
                  : 'assets/images/ukulele_tuning.png',
              height: 192,
            ),
          ],
        ),
      ),
    );
  }
}

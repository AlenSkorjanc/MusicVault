import 'dart:typed_data';

import 'package:buffered_list_stream/buffered_list_stream.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:pitchupdart/tuning_status.dart';
import 'package:record/record.dart';

class TunningState {
  final String note;
  final Color statusColor;
  final double diffCents;

  TunningState({
    required this.note,
    required this.statusColor,
    required this.diffCents,
  });
}

class PitchCubit extends Cubit<TunningState> {
  final AudioRecorder _audioRecorder;
  final PitchDetector _pitchDetectorDart;
  final PitchHandler _pitchupDart;

  PitchCubit(this._audioRecorder, this._pitchDetectorDart, this._pitchupDart)
      : super(TunningState(
          note: '',
          statusColor: Colors.green,
          diffCents: -1.0,
        )) {
    _init();
  }

  _init() async {
    final recordStream = await _audioRecorder.startStream(const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      numChannels: 1,
      bitRate: 128000,
      sampleRate: PitchDetector.DEFAULT_SAMPLE_RATE,
    ));

    var audioSampleBufferedStream = bufferedListStream(
      recordStream.map((event) {
        return event.toList();
      }),
      //The library converts a PCM16 to 8bits internally. So we need twice as many bytes
      PitchDetector.DEFAULT_BUFFER_SIZE * 2,
    );

    await for (var audioSample in audioSampleBufferedStream) {
      final intBuffer = Uint8List.fromList(audioSample);

      _pitchDetectorDart.getPitchFromIntBuffer(intBuffer).then(
        (detectedPitch) {
          if (detectedPitch.pitched) {
            _pitchupDart.handlePitch(detectedPitch.pitch).then(
                  (pitchResult) => {
                    emit(
                      TunningState(
                        note: pitchResult.note,
                        statusColor: pitchResult.tuningStatus.getColor(),
                        diffCents: pitchResult.diffCents,
                      ),
                    ),
                    
                  },
                );
          }
        },
      );
    }
  }
}

extension Description on TuningStatus {
  Color getColor() => switch (this) {
        TuningStatus.tuned => Colors.green,
        TuningStatus.toolow => Colors.orange,
        TuningStatus.toohigh => Colors.orange,
        TuningStatus.waytoolow => Colors.red,
        TuningStatus.waytoohigh => Colors.red,
        TuningStatus.undefined => Colors.red,
      };
}

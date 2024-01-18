import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:our_mediapipe_app/services/face_detection/face_detection_service.dart';
import 'package:our_mediapipe_app/services/service_locator.dart';

import '../utils/isolate_utils.dart';
import 'ai_model.dart';

class ModelInferenceService {
  late AiModel model;
  late Function handler;
  Map<String, dynamic>? inferenceResults;

  Future<Map<String, dynamic>?> inference({
    required IsolateUtils isolateUtils,
    required CameraImage cameraImage,
  }) async {
    final responsePort = ReceivePort();

    isolateUtils.sendMessage(
      handler: handler,
      params: {
        'cameraImage': cameraImage,
        'detectorAddress': model.getAddress,
      },
      sendPort: isolateUtils.sendPort,
      responsePort: responsePort,
    );

    inferenceResults = await responsePort.first;
    responsePort.close();
    return null;
  }

  void setModelConfig() {
    model = locator<FaceDetection>();
    handler = runFaceDetector;
  }
}

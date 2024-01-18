import 'package:get_it/get_it.dart';

import 'face_detection/face_detection_service.dart';
import 'model_inference_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<FaceDetection>(FaceDetection());

  locator.registerLazySingleton<ModelInferenceService>(() => ModelInferenceService());
}

import 'package:camera/camera.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:our_mediapipe_app/services/model_inference_service.dart';
import 'package:our_mediapipe_app/services/service_locator.dart';
import 'package:our_mediapipe_app/ui/pages/camera_model.dart';
import 'package:our_mediapipe_app/ui/pages/camera_page.dart';
import 'package:our_mediapipe_app/utils/isolate_utils.dart';

/// di for [CameraWM]
CameraWM createCameraWM(BuildContext context) {
  var isolateUtils = IsolateUtils();
  var modelInferenceService = locator<ModelInferenceService>();

  var cameraModel =
      CameraModel(isolateUtils: isolateUtils, modelInferenceService: modelInferenceService, context: context);
  return CameraWM(cameraModel);
}

/// [WidgetModel] экрана камеры.

class CameraWM extends WidgetModel<CameraPage, CameraModel> implements ICameraWM {
  CameraWM(super.model);

  @override
  CameraController get cameraController => model.cameraController;

  @override
  ValueListenable<bool> get isCameraInited => model.isCameraInited;

  @override
  void imageStreamToggle() {
    model.imageStreamToggle();
  }

  @override
  ValueListenable<Map<String, dynamic>?> get inferenceResults => model.inferenceResults;

  @override
  ValueListenable<bool> get predicting => model.predicting;

  @override
  bool get draw => model.draw;
}

abstract interface class ICameraWM implements IWidgetModel {
  /// Контроллер для виджета камеры
  CameraController get cameraController;

  /// Метка состояния инциации контроллера камеры
  ValueListenable<bool> get isCameraInited;

  /// Метка прорисовки детекции
  ValueListenable<bool> get predicting;

  /// Метка вкл/выкл детекции
  bool get draw;

  /// Модель службы вывода
  ValueListenable<Map<String, dynamic>?> get inferenceResults;

  /// Колбэк старт/стоп сканирования видеопотока
  void imageStreamToggle();
}

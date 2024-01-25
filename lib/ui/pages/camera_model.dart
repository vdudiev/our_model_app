import 'package:camera/camera.dart';
import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:our_mediapipe_app/services/model_inference_service.dart';
import 'package:our_mediapipe_app/utils/image_utils.dart';
import 'package:our_mediapipe_app/utils/isolate_utils.dart';
import 'package:flutter/services.dart';

class CameraModel extends ElementaryModel {
  final BuildContext context;
  late final CameraController _cameraController;
  late final List<CameraDescription> _cameras;

  bool _draw = false;

  final _platform = const MethodChannel('samples.flutter.dev/mediapipe');

  bool _isRun = false;

  final _isCameraInited = ValueNotifier<bool>(false);
  late final ModelInferenceService _modelInferenceService;
  late final IsolateUtils _isolateUtils;
  final _predicting = ValueNotifier<bool>(false);

  ValueListenable<bool> get predicting => _predicting;
  bool get draw => _draw;

  ValueListenable<bool> get isCameraInited => _isCameraInited;
  CameraController get cameraController => _cameraController;
  ValueListenable<Map<String, dynamic>?> get inferenceResults =>
      ValueNotifier<Map<String, dynamic>?>(_modelInferenceService.inferenceResults);

  CameraModel({
    required ModelInferenceService modelInferenceService,
    required IsolateUtils isolateUtils,
    required this.context,
  })  : _isolateUtils = isolateUtils,
        _modelInferenceService = modelInferenceService;
  @override
  void init() {
    _initCameraData();
    super.init();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
    _modelInferenceService.inferenceResults = null;
  }

  void imageStreamToggle() {
    _draw = !_draw;

    _isRun = !_isRun;
    if (_isRun) {
      _cameraController.startImageStream(
        (CameraImage cameraImage) async => await _inference(cameraImage: cameraImage),
      );
    } else {
      _cameraController.stopImageStream();
    }
  }

  void _initCameraData() async {
    await _isolateUtils.initIsolate();
    _modelInferenceService.setModelConfig();
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras.first, ResolutionPreset.medium, enableAudio: false);
    await _cameraController.initialize();

    _isCameraInited.value = true;
  }

  Future<void> _inference({required CameraImage cameraImage}) async {
    if (!context.mounted) return;

    if (_modelInferenceService.model.interpreter != null) {
      if (_predicting.value || !_draw) {
        return;
      }

      _predicting.value = true;

      if (_draw) {
        // await _modelInferenceService.inference(
        //   isolateUtils: _isolateUtils,
        //   cameraImage: cameraImage,
        // );

        await processFrame(cameraImage);
      }

      _predicting.value = false;
    }
  }

  Future<void> processFrame(CameraImage image) async {
    try {
      final frame = ImageUtils.convertCameraImage(image)!;

      final String result =
          await _platform.invokeMethod('processMediaPipeGraph', {"frame": frame.getBytes()});
      print('Processed data: $result');
    } on PlatformException catch (e) {
      print("Failed to process frame: '${e.message}'.");
    }
  }
}

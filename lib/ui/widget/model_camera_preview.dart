import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../services/model_inference_service.dart';
import '../../../services/service_locator.dart';
import 'face_detection_painter.dart';

class ModelCameraPreview extends StatelessWidget {
  final bool draw;

  ModelCameraPreview({
    required this.cameraController,
    Key? key,
    required this.draw,
  }) : super(key: key);

  final CameraController? cameraController;

  late final double _ratio;
  final Map<String, dynamic>? inferenceResults = locator<ModelInferenceService>().inferenceResults;

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    _ratio = screenSize.width / cameraController!.value.previewSize!.height;

    return Stack(
      children: [
        CameraPreview(cameraController!),
        Visibility(
          visible: draw,
          child: IndexedStack(
            children: [
              _drawBoundingBox,
            ],
          ),
        ),
      ],
    );
  }

  Widget get _drawBoundingBox {
    final bbox = inferenceResults?['bbox'];
    return _ModelPainter(
      customPainter: FaceDetectionPainter(
        bbox: bbox ?? Rect.zero,
        ratio: _ratio,
      ),
    );
  }
}

class _ModelPainter extends StatelessWidget {
  _ModelPainter({
    required this.customPainter,
    Key? key,
  }) : super(key: key);

  final CustomPainter customPainter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: customPainter,
    );
  }
}

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:our_mediapipe_app/ui/pages/camera_wm.dart';
import 'package:our_mediapipe_app/ui/widget/model_camera_preview.dart';

class CameraPage extends ElementaryWidget<ICameraWM> {
  CameraPage({super.key}) : super((_) => createCameraWM(_));

  @override
  Widget build(ICameraWM wm) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Камера',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        builder: (context, isControllerInit, child) {
          if (isControllerInit) {
            return ValueListenableBuilder<bool>(
              builder: (context, value, child) {
                return ModelCameraPreview(
                  cameraController: wm.cameraController,
                  draw: wm.draw,
                );
              },
              valueListenable: wm.predicting,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        valueListenable: wm.isCameraInited,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => wm.imageStreamToggle(),
            color: Colors.white,
            iconSize: 30,
            icon: const Icon(
              Icons.filter_center_focus,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

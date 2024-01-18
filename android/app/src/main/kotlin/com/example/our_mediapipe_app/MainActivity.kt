package com.example.our_mediapipe_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import com.google.mediapipe.components.FrameProcessor
import com.google.mediapipe.framework.AndroidAssetUtil
import com.google.mediapipe.framework.PacketGetter





class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/mediapipe"

    // Initialize MediaPipe components.
    private lateinit var frameProcessor: FrameProcessor

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "processMediaPipeGraph") {
                val frame = call.argument<ByteArray>("frame")
                val processedData = processMediaPipeGraph(frame)

                if (processedData != null) {
                    result.success(processedData)
                } else {
                    result.error("UNAVAILABLE", "MediaPipe data not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Dummy function for processing MediaPipe graph.
    // Replace this with your actual implementation.
    private fun processMediaPipeGraph(frame: ByteArray?): String? {
        // TODO: Initialize the FrameProcessor with the correct graph and assets.
        // TODO: Use the onNewFrame method to process the frame.
        // TODO: Return the processed data.
        return "Processed data from frame"
    }

    init {
        // Load all native libraries needed by the app.
        System.loadLibrary("mediapipe_jni")
        try {
            System.loadLibrary("opencv_java3")
        } catch (e: UnsatisfiedLinkError) {
            // Some example apps (e.g. template matching) require OpenCV 4.
            System.loadLibrary("opencv_java4")
        }
    }
}



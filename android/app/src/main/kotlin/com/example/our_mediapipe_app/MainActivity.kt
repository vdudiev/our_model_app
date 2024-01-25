package com.example.our_mediapipe_app

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.graphics.RectF
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import com.google.mediapipe.components.FrameProcessor
import com.google.mediapipe.formats.proto.DetectionProto
import com.google.mediapipe.framework.AndroidAssetUtil
import com.google.mediapipe.framework.PacketGetter
import com.google.mediapipe.glutil.EglManager


class MainActivity: FlutterActivity() {

    // Creates and manages an {@link EGLContext}.
    private var eglManager = EglManager(null)
    private val CHANNEL = "samples.flutter.dev/mediapipe"

    // Initialize MediaPipe components.
    private  var frameProcessor: FrameProcessor? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "processMediaPipeGraph") {
                val frame = call.argument<ByteArray>("frame")
                if (frame != null){
                val processedData = processMediaPipeGraph(frame)
                    if (processedData != null) {
                        result.success(processedData)
                    } else {
                        result.error("UNAVAILABLE", "MediaPipe data not available.", null)
                    }
            }


            } else {
                result.notImplemented()
            }
        }
    }

    // Dummy function for processing MediaPipe graph.
    // Replace this with your actual implementation.
    private fun processMediaPipeGraph(frame: ByteArray): String? {
        AndroidAssetUtil.initializeNativeAssetManager(this)
        Log.d("APPLE", "AFTER")
            frameProcessor =
                FrameProcessor(
                    this,
                    eglManager.nativeContext,
                    BINARY_GRAPH_NAME,
                    INPUT_VIDEO_STREAM_NAME,
                    OUTPUT_VIDEO_STREAM_NAME
                ).apply {
                    setVideoInputStreamCpu(INPUT_VIDEO_STREAM_NAME)
                    Log.d("SCAN_EPOCH", "START")               
               addPacketCallback("all_detections") { packet ->
                   val detections = PacketGetter.getProtoVector(
                       packet,
                       DetectionProto.Detection.getDefaultInstance()
                   )

                   if (detections.isNotEmpty()) {
                       val detection = detections.first()

//                    runOnUiThread {
//                        binding.bboxesPreview.drawDetectionResults(detections, RectF(0.toFloat(), 0.toFloat(), binding.bboxesPreview.measuredWidth.toFloat(), binding.bboxesPreview.measuredHeight.toFloat())   )
//                        Log.d("SCAN_EPOCH_detection", detection.toString())
//                        Log.d("SCAN_EPOCH", detection.locationData.relativeBoundingBox.width.toString())
//
//                        // TODO process detections
//                    }
                   }
                    Log.d("SCAN_EPOCH", "end")
               }
           }
        Log.d("input_FRAME", frame.toString())

//        val verticallyFlippedBitmap = createFlippedBitmap(BitmapFactory.decodeByteArray(frame, 0, frame.size))
         frameProcessor?.onNewFrame(BitmapFactory.decodeByteArray(frame, 0, frame.), 123)
        return "Processed data from frame"
    }

    private fun createFlippedBitmap(source: Bitmap?): Bitmap? {
        if (source == null) return null

        val matrix = Matrix()
        matrix.postScale(
            1f,
            -1f,
            source.width / 2f,
            source.height / 2f
        )
        return Bitmap.createBitmap(source, 0, 0, source.width, source.height, matrix, true)
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
    companion object {
        private const   val BINARY_GRAPH_NAME =
            "detection_yolov8n_int8_320_tflite.binarypb"
        private const val INPUT_VIDEO_STREAM_NAME = "input_video"
        private val OUTPUT_VIDEO_STREAM_NAME: String? = null
    }
}



import 'package:flutter/services.dart';

class SnapShare {
  static const _ch = MethodChannel('snapkit');

  static Future<bool> sharePhoto(String imagePath, {String? caption}) async {
    final ok = await _ch.invokeMethod('sharePhoto', {
      'path': imagePath,
      'caption': caption,
    });
    return ok == true;
  }

  static Future<bool> shareVideo(String videoPath, {String? caption}) async {
    final ok = await _ch.invokeMethod('shareVideo', {
      'path': videoPath,
      'caption': caption,
    });
    return ok == true;
  }
}

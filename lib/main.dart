import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'snap_share.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Home()));

class Home extends StatefulWidget {
  const Home({super.key});
  @override State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _picker = ImagePicker();
  XFile? _pickedImage;
  XFile? _pickedVideo;
  final _captionCtrl = TextEditingController();

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 95);
    if (x != null) setState(() => _pickedImage = x);
  }

  Future<void> _pickVideo() async {
    final x = await _picker.pickVideo(source: ImageSource.gallery);
    if (x != null) setState(() => _pickedVideo = x);
  }

  Future<void> _shareImage() async {
    if (_pickedImage == null) return;
    final ok = await SnapShare.sharePhoto(_pickedImage!.path, caption: _captionCtrl.text.trim());
    if (mounted) _toast(ok ? 'فتح سناب للمشاركة (صورة)' : 'تعذّر الإرسال');
  }

  Future<void> _shareVideo() async {
    if (_pickedVideo == null) return;
    final ok = await SnapShare.shareVideo(_pickedVideo!.path, caption: _captionCtrl.text.trim());
    if (mounted) _toast(ok ? 'فتح سناب للمشاركة (فيديو)' : 'تعذّر الإرسال');
  }

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnapShare Pro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _captionCtrl,
            decoration: const InputDecoration(labelText: 'تعليق (اختياري)'),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text('اختيار صورة'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.video_library_outlined),
                label: const Text('اختيار فيديو'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          if (_pickedImage != null) ...[
            const Text('معاينة الصورة:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(_pickedImage!.path), height: 220, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _shareImage, child: const Text('مشاركة الصورة إلى Snapchat')),
            const SizedBox(height: 24),
          ],
          if (_pickedVideo != null) ...[
            const Text('فيديو مُختار:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_pickedVideo!.name, maxLines: 2),
            const SizedBox(height: 8),
            FilledButton(onPressed: _shareVideo, child: const Text('مشاركة الفيديو إلى Snapchat')),
          ],
        ],
      ),
    );
  }
}

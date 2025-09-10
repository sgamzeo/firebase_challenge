import 'dart:io';
import 'package:firebase_challenge/feature/auth/domain/entities/user_entity.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/post_cubit.dart';

class UploadPostPage extends StatelessWidget {
  final UserEntity user;

  const UploadPostPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: _UploadPostForm(user: user),
    );
  }
}

class _UploadPostForm extends StatefulWidget {
  final UserEntity user;
  const _UploadPostForm({required this.user});

  @override
  State<_UploadPostForm> createState() => _UploadPostFormState();
}

class _UploadPostFormState extends State<_UploadPostForm> {
  final TextEditingController _captionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isPosting = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _createPost() async {
    if (_selectedImage == null || _captionController.text.trim().isEmpty)
      return;

    setState(() => _isPosting = true);

    try {
      await context.read<PostCubit>().createPostWithImage(
        imageFile: _selectedImage!,
        caption: _captionController.text.trim(),
        user: widget.user, // artık user gönderiyoruz
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creating post: $e')));
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _selectedImage != null
              ? Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add_photo_alternate, size: 40),
                    onPressed: _pickImage,
                  ),
                ),
          const SizedBox(height: 16),
          TextField(
            controller: _captionController,
            decoration: const InputDecoration(
              hintText: 'Write a caption...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          if (_isPosting) const CircularProgressIndicator(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isPosting ? null : _createPost,
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}

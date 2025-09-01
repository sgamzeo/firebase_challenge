import 'dart:io';
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/post_cubit.dart';

class UploadPostPage extends StatelessWidget {
  const UploadPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    if (kDebugMode) {
      print('UploadPostPage initial Auth state: ${authCubit.state}');
    }

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is! AuthAuthenticated) {
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (kDebugMode) {
            print('BlocBuilder build called with state: $state');
          }

          if (state is AuthAuthenticated) {
            return Scaffold(
              appBar: AppBar(title: const Text('Create Post')),
              body: _UploadPostForm(userId: state.user.id!),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class _UploadPostForm extends StatefulWidget {
  final String userId;
  const _UploadPostForm({required this.userId});

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
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
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
        userId: widget.userId,
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

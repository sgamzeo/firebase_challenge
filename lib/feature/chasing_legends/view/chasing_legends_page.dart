import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../cubit/mascot_cubit.dart';
import 'package:firebase_challenge/core/dependency_injection.dart/dependecy_injection_container.dart'
    as di;
import 'package:firebase_challenge/feature/auth/cubit/auth_cubit.dart';

class ChasingLegendsPage extends StatelessWidget {
  const ChasingLegendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    Future<void> pickImage(MascotCubit cubit) async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        cubit.selectImage(File(pickedFile.path));
      }
    }

    return BlocProvider(
      create: (_) => di.getIt<MascotCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, authState) {
          // Auth state değişikliklerini dinle
        },
        builder: (context, authState) {
          final cubit = context.read<MascotCubit>();
          final authCubit = context.read<AuthCubit>();

          // Kullanıcı ID'sini al
          String? userId;
          if (authState is AuthAuthenticated) {
            userId = authState.user.id;
          }

          return BlocBuilder<MascotCubit, MascotState>(
            builder: (context, state) {
              File? selectedImage;
              String? downloadUrl;

              if (state is MascotSelected) selectedImage = state.image;
              if (state is MascotUploaded) downloadUrl = state.downloadUrl;

              return Scaffold(
                appBar: AppBar(title: const Text('Choose Mascot')),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () => pickImage(cubit),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                            image: selectedImage != null
                                ? DecorationImage(
                                    image: FileImage(selectedImage),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: selectedImage == null
                              ? const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    size: 50,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (selectedImage != null && state is! MascotUploading)
                        ElevatedButton(
                          onPressed: userId == null
                              ? null
                              : () => cubit.uploadMascot(
                                  userId: userId!,
                                  image: selectedImage!,
                                  folderName: 'mascots',
                                ),
                          child: const Text('Upload Mascot'),
                        ),
                      if (state is MascotUploading)
                        const Center(child: CircularProgressIndicator()),
                      if (downloadUrl != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Upload Successful!',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Download URL:'),
                        SelectableText(downloadUrl),
                      ],
                      if (userId == null)
                        Text(
                          'Please sign in to upload mascots',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

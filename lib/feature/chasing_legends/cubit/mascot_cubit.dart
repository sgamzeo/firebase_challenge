import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/upload_entity_use_case.dart';
import 'package:firebase_challenge/feature/banana_tree_community/domain/usecases/create_entity_use_case.dart';
import 'package:firebase_challenge/feature/chasing_legends/mascot_entity.dart';

part 'mascot_state.dart';

class MascotCubit extends Cubit<MascotState> {
  final UploadEntityUseCase uploadEntityUseCase;
  final CreateEntityUseCase<Mascot> createEntityUseCase;
  final Uuid _uuid = Uuid();

  MascotCubit({
    required this.uploadEntityUseCase,
    required this.createEntityUseCase,
  }) : super(MascotInitial());

  void selectImage(File image) {
    emit(MascotSelected(image));
  }

  Future<void> uploadMascot({
    required String userId,
    required File image,
    required String folderName,
  }) async {
    emit(MascotUploading());
    try {
      print('Uploading image to storage...');
      // Storage'a yükle
      final downloadUrl = await uploadEntityUseCase(
        image,
        userId,
        folderName: folderName,
      );

      print('Image uploaded to storage: $downloadUrl');

      // Entity oluştur
      final mascotId = _uuid.v4();
      final mascot = Mascot(
        id: mascotId,
        userId: userId,
        imageUrl: downloadUrl,
        downloadUrl: downloadUrl,
        createdAt: DateTime.now(),
      );

      print('Creating mascot in Firestore: ${mascot.toMap()}');

      // Firestore'a kaydet
      await createEntityUseCase(mascot);

      print('Mascot created successfully in Firestore');

      emit(MascotUploaded(downloadUrl));
    } catch (e) {
      print('Error uploading mascot: $e');
      emit(MascotError('Error uploading mascot: $e'));
    }
  }
}

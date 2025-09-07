part of 'mascot_cubit.dart';

abstract class MascotState {}

class MascotInitial extends MascotState {}

class MascotSelected extends MascotState {
  final File image;
  MascotSelected(this.image);
}

class MascotUploading extends MascotState {}

class MascotUploaded extends MascotState {
  final String downloadUrl;
  MascotUploaded(this.downloadUrl);
}

class MascotError extends MascotState {
  final String message;
  MascotError(this.message);
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:very_good_coffee/data_models/photo_model.dart';
import 'package:very_good_coffee/photo_repository/photo_repository.dart';

part 'featured_image_state.dart';

class FeaturedImageCubit extends Cubit<FeaturedImageState> {
  FeaturedImageCubit(this._photoRepository) : super(FeaturedImageInitial());

  final PhotoRepository _photoRepository;
  PhotoModel? featuredPhoto;
  bool isFavorite = false;

  Future<void> loadNewImage() async {
    emit(FeaturedImageLoading());

    try {
      final newPhoto = await _photoRepository.fetchAndCacheSinglePhotoFromNetwork('featuredImage');
      featuredPhoto = newPhoto ?? featuredPhoto;

      if (featuredPhoto != null) {
        emit(FeaturedImageLoaded(featuredPhoto!));
      } else {
        emit(NetworkError());
      }
    } catch (_) {
      emit(NetworkError());
    }
  }
}

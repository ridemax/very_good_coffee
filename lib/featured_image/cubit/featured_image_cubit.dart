import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:very_good_coffee/data_models/photo_model.dart';
import 'package:very_good_coffee/favorite_images/cubit/favorite_images_cubit.dart';
import 'package:very_good_coffee/photo_repository/photo_repository.dart';

part 'featured_image_state.dart';

class FeaturedImageCubit extends Cubit<FeaturedImageState> {
  FeaturedImageCubit(this.photoRepository, this._favoriteImagesCubit) : super(FeaturedImageInitial());

  final PhotoRepository photoRepository;
  final FavoriteImagesCubit _favoriteImagesCubit;
  PhotoModel? featuredPhoto;
  bool isFavorite = false;

  Future<void> loadNewImage() async {
    emit(FeaturedImageLoading());

    try {
      final newPhoto = await photoRepository.fetchAndCacheSinglePhotoFromNetwork('featuredImage');
      featuredPhoto = newPhoto ?? featuredPhoto;
      isFavorite = false;

      if (featuredPhoto != null) {
        emit(FeaturedImageLoaded(featuredPhoto!, isFavorite: isFavorite));
      } else {
        emit(FeaturedImageNetworkError());
      }
    } catch (_) {
      emit(FeaturedImageNetworkError());
    }
  }

  Future<void> markImageAsFavorite() async {
    try {
      await photoRepository.moveCachedPhoto(
        'featuredImage',
        'favoriteImages',
        featuredPhoto!,
      );

      if (featuredPhoto != null) {
        isFavorite = true;
        emit(FeaturedImageLoaded(featuredPhoto!, isFavorite: isFavorite));
      } else {
        emit(FeaturedImageNetworkError());
      }
    } catch (_) {
      emit(FeaturedImageNetworkError());
    }
    await _favoriteImagesCubit.loadFavorites();
  }
}

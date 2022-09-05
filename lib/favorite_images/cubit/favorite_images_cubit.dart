import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:very_good_coffee/data_models/photo_model.dart';
import 'package:very_good_coffee/photo_repository/photo_repository.dart';

part 'favorite_images_state.dart';

class FavoriteImagesCubit extends Cubit<FavoriteImagesState> {
  FavoriteImagesCubit(this._photoRepository) : super(FavoriteImagesInitial());

  final PhotoRepository _photoRepository;

  Future<void> loadFavorites() async {
    try {
      emit(FavoriteImagesLoaded(await _photoRepository.getPhotosFromPersistentCache('featuredImage'))); // For quick test with featuredImage cache
    } catch (_) {
      emit(FavoriteImagesJsonParseError());
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:very_good_coffee/data_models/photo_model.dart';
import 'package:very_good_coffee/photo_repository/photo_repository.dart';

part 'favorite_images_state.dart';

class FavoriteImagesCubit extends Cubit<FavoriteImagesState> {
  FavoriteImagesCubit(this.photoRepository) : super(FavoriteImagesInitial());

  final PhotoRepository photoRepository;

  Future<void> loadFavorites() async {
    try {
      emit(FavoriteImagesLoaded(await photoRepository.getPhotosFromPersistentCache('favoriteImages')));
    } catch (_) {
      emit(FavoriteImagesJsonParseError());
    }
  }
}

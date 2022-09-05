part of 'favorite_images_cubit.dart';

@immutable
abstract class FavoriteImagesState {}

class FavoriteImagesInitial extends FavoriteImagesState {}

class FavoriteImagesRefreshing extends FavoriteImagesState {}

class FavoriteImagesLoaded extends FavoriteImagesState {
  FavoriteImagesLoaded(
    this.photos,
  );

  final List<PhotoModel> photos;
}

class FavoriteImagesJsonParseError extends FavoriteImagesState {}

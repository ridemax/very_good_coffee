part of 'featured_image_cubit.dart';

@immutable
abstract class FeaturedImageState {}

class FeaturedImageInitial extends FeaturedImageState {}

class FeaturedImageLoading extends FeaturedImageState {}

class FeaturedImageLoaded extends FeaturedImageState {
  FeaturedImageLoaded(
    this.photo, {
    this.isFavorite = false,
  });

  final PhotoModel photo;
  final bool isFavorite;
}

class FeaturedImageNetworkError extends FeaturedImageState {}

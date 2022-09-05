import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorite_images/favorite_images.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FavoriteImagesView extends StatelessWidget {
  const FavoriteImagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<FavoriteImagesCubit, FavoriteImagesState>(builder: (context, state) {
      if (state is FavoriteImagesLoaded) {
        final images = state.photos;
        final count = images.length;
        return ListView.separated(
          itemCount: count,
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return Image(image: state.photos[index].image!);
          },
        );
      } else {
        return const SizedBox(height: 20, child: Center(child: CircularProgressIndicator()));
      }
    });
  }
}

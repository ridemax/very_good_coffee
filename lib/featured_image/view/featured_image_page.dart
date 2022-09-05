import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/featured_image/cubit/featured_image_cubit.dart';
import 'package:very_good_coffee/l10n/l10n.dart';

class FeaturedImageView extends StatelessWidget {
  const FeaturedImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      child: BlocBuilder<FeaturedImageCubit, FeaturedImageState>(
        builder: (context, state) {
          var prompt = l10n.buttonServeNewImage;
          if (state is NetworkError) prompt = l10n.tryAgain;
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const Image(
                        image: AssetImage('assets/images/barista.png'),
                        height: 128,
                        width: 128,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.tight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          height: 128,
                          color: Theme.of(context).primaryColorDark,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              l10n.baristaWelcome,
                              maxLines: 5,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (state is! FeaturedImageLoading) {
                        context.read<FeaturedImageCubit>().loadNewImage();
                      }
                    },
                    child: Text(prompt),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: state is FeaturedImageLoaded
                      ? _featuredImage(context, state, l10n)
                      : state is FeaturedImageLoading
                          ? const CircularProgressIndicator()
                          : state is NetworkError
                              ? Text(l10n.networkOffline)
                              : const SizedBox(height: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _featuredImage(BuildContext context, FeaturedImageLoaded state, AppLocalizations l10n) {
    return Column(
      children: [
        Image.file(state.photo.image!),
        Container(
          color: Theme.of(context).primaryColorDark,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.isFavorite)
                Text(l10n.addedToFavorites, style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColorLight))
              else
                IconButton(
                  iconSize: 44,
                  icon: Icon(Icons.favorite_outline, color: Theme.of(context).primaryColorLight),
                  onPressed: () => context.read<FeaturedImageCubit>().markImageAsFavorite(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

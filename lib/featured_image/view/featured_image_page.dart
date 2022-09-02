import 'dart:developer';

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
                    onPressed: () => context.read<FeaturedImageCubit>().loadNewImage(),
                    child: const Text('Show me the java!'),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: state is FeaturedImageLoaded
                      ? Image(image: state.photo.image!)
                      : state is FeaturedImageLoading
                          ? const CircularProgressIndicator()
                          : const Center(child: Text('Error!')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

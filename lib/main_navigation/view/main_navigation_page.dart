import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee/favorite_images/favorite_images.dart';
import 'package:very_good_coffee/featured_image/view/featured_image_page.dart';
import 'package:very_good_coffee/l10n/l10n.dart';
import 'package:very_good_coffee/main_navigation/cubit/main_navigation_cubit.dart';
import 'package:very_good_coffee/main_navigation/main_navigation.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainNavigationCubit(),
      child: const MainNavigationView(),
    );
  }
}

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentIndex = context.select((MainNavigationCubit cubit) => cubit.state);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.veryGoodAppBarTitle),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.coffee_rounded),
            label: l10n.navigationBarHomeLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: l10n.navigationBarFavoritesLabel,
          ),
        ],
        currentIndex: currentIndex,
        onTap: (int newTabIndex) {
          context.read<MainNavigationCubit>().setCurrentTabIndex(newTabIndex);
          if (newTabIndex == 1) {
            context.read<FavoriteImagesCubit>().loadFavorites();
          }
        },
      ),
      body: currentIndex == 0 ? const FeaturedImageView() : const FavoriteImagesView(),
    );
  }
}

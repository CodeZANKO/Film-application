import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:film_app/core/theme/app_theme.dart';
import 'package:film_app/features/movies/presentation/bloc/navigation_bloc.dart';
import 'package:film_app/features/movies/presentation/pages/home_page.dart';
import 'package:film_app/features/movies/presentation/pages/explore_screen.dart';
import 'package:film_app/features/movies/presentation/pages/actors_screen.dart';
import 'package:film_app/features/tv_series/presentation/pages/tv_series_screen.dart';
import 'package:film_app/features/movies/presentation/pages/profile_screen.dart';

import 'package:film_app/core/widgets/glass_container.dart';
import 'package:film_app/core/widgets/liquid_background.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: LiquidBackground(
            child: IndexedStack(
              index: state.index,
              children: const [
                HomePage(),
                ExploreScreen(),
                TVSeriesScreen(),
                ActorsScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context, state.index),
          extendBody: true,
          backgroundColor: AppColors.background,
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: GlassContainer(
        height: 72,
        borderRadius: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, Icons.home_rounded, NavbarItem.home,
                currentIndex == 0),
            _buildNavItem(context, Icons.movie_rounded, NavbarItem.explore,
                currentIndex == 1),
            _buildNavItem(context, Icons.live_tv_rounded, NavbarItem.tvSeries,
                currentIndex == 2),
            _buildNavItem(context, Icons.people_rounded, NavbarItem.actors,
                currentIndex == 3),
            _buildNavItem(context, Icons.person_rounded, NavbarItem.profile,
                currentIndex == 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, NavbarItem item, bool isActive) {
    return GestureDetector(
      onTap: () => context.read<NavigationBloc>().getNavBarItem(item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? AppColors.primary : Colors.grey),
          if (isActive)
            Container(
              height: 4,
              width: 4,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
                  
            )
        ],
      ),
    );
  }
}


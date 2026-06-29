import 'package:flutter_bloc/flutter_bloc.dart';

enum NavbarItem { home, explore, actors, tvSeries, profile }

class NavigationState {
  final NavbarItem navbarItem;
  final int index;
  NavigationState(this.navbarItem, this.index);
}

class NavigationBloc extends Cubit<NavigationState> {
  NavigationBloc() : super(NavigationState(NavbarItem.home, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(NavigationState(NavbarItem.home, 0));
        break;
      case NavbarItem.explore:
        emit(NavigationState(NavbarItem.explore, 1));
        break;
      case NavbarItem.tvSeries:
        emit(NavigationState(NavbarItem.tvSeries, 2));
        break;
      case NavbarItem.actors:
        emit(NavigationState(NavbarItem.actors, 3));
        break;
      case NavbarItem.profile:
        emit(NavigationState(NavbarItem.profile, 4));
        break;
    }
  }
}


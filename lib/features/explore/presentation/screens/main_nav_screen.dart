import 'package:flutter/material.dart';
import '../../../../core/state/app_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/explore/presentation/screens/explore_screen.dart';
import '../../../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../../../../features/trip/presentation/screens/trip_screen.dart';
import '../../../../features/profile/presentation/screens/profile_screen.dart';

class MainNavScreen extends StatelessWidget {
  const MainNavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = AppState.instance;

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final currentIndex = appState.currentTabIndex;

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: const [
              ExploreScreen(), // Tab 0: Explorar
              ExploreScreen(), // Tab 1: Início
              WishlistScreen(), // Tab 2: Desejos
              TripScreen(), // Tab 3: Trip
              ProfileScreen(), // Tab 4: Perfil
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) => appState.setTabIndex(index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded),
                  label: 'Explorar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == 1
                        ? Icons.home_rounded
                        : Icons.home_outlined,
                  ),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == 2
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                  label: 'Desejos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == 3
                        ? Icons.backpack_rounded
                        : Icons.backpack_outlined,
                  ),
                  label: 'Trip',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    currentIndex == 4
                        ? Icons.person_rounded
                        : Icons.person_outline_rounded,
                  ),
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

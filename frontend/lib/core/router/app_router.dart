import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/buyer/presentation/pages/buyer_home_page.dart';

import '../../features/farmer/presentation/pages/farmer_home_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/register',
    redirect: (context, state) {
      final status = authState.status;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (status == AuthStatus.initial) {
        return null;
      }

      final isLoggedIn = status == AuthStatus.authenticated;

      if (!isLoggedIn) {
        if (!isLoggingIn && !isRegistering) {
          return '/login';
        }
      } else {
        if (isLoggingIn || isRegistering) {
          final isFarmer = authState.user?.role == 'FARMER';
          return isFarmer ? '/farmer-home' : '/buyer-home';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/buyer-home',
        builder: (context, state) => const BuyerHomePage(),
      ),
      GoRoute(
        path: '/farmer-home',
        builder: (context, state) => const FarmerHomePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});


import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shelter_booking/landing/presentation/landing_screen.dart';
import 'package:shelter_booking/login/presentation/login_screen.dart';
import 'package:shelter_booking/login/presentation/reset_password_screen.dart';
import 'package:shelter_booking/login_wrapper_screen.dart';
import 'package:shelter_booking/main_wrapper_screen.dart';
import 'package:shelter_booking/register/presentation/register_screen.dart';
import 'package:shelter_booking/shelters_screen/home_screen/presentation/home_screen.dart';

import 'guards.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  preferRelativeImports: false,
  routes: [
    AutoRoute(
      guards: [AuthGuard],
      page: MainWrapperScreen,
      initial: true,
      children: [
        AutoRoute(
          page: HomeScreen,
          initial: true,
        ),
      ],
    ),
    AutoRoute(
      page: LoginWrapperScreen,
      initial: true,
      children: [
        AutoRoute(
          page: LandingScreen,
          initial: true,
        ),
        AutoRoute(page: LoginScreen),
        AutoRoute(page: RegisterScreen),
        AutoRoute(page: ResetPasswordScreen),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter({required super.authGuard});
}

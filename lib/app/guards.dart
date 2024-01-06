import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelter_booking/app/app_router.dart';
import 'package:shelter_booking/core/core.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final isUserLoggedIn = prefs.getBool(Strings.isLoggedInText) ?? false;

    if (isUserLoggedIn) {
      resolver.next();
    } else {
      router.push(const LoginWrapperRoute());
      resolver.next(false);
    }
  }
}

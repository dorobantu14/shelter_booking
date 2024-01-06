import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelter_booking/app/app_router.dart';
import 'package:shelter_booking/app/guards.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/firebase_options.dart';
import 'package:shelter_booking/login/data/login_data.dart';
import 'package:shelter_booking/login/domain/repository/login_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appRouter = AppRouter(authGuard: AuthGuard());
  final firebaseApp = Firebase.app();
  final database = FirebaseDatabase.instanceFor(
    app: firebaseApp,
    databaseURL: "https://shelter-booking-375a3-default-rtdb.firebaseio.com/",
  );
  runApp(
    MultiRepositoryProvider(
      providers: getRepositoryProviders(database),
      child: MyApp(
        appRouter: appRouter,
      ),
    ),
  );
}

List<RepositoryProvider<dynamic>> getRepositoryProviders(
    FirebaseDatabase database) {
  return [
    RepositoryProvider<LoginRepository>(
      create: (_) => LoginRepository(
        loginData: LoginData(database: database),
      ),
    ),
  ];
}

Future<bool> getLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(Strings.isLoggedInText) ?? false;
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter;

  const MyApp({
    super.key,
    required AppRouter appRouter,
  }) : _appRouter = appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Strings.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        useMaterial3: true,
      ),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
    );
  }
}

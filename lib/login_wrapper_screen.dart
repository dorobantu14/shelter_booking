import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelter_booking/login/domain/bloc/login_bloc.dart';
import 'package:shelter_booking/login/domain/repository/login_repository.dart';

class LoginWrapperScreen extends StatelessWidget {
  const LoginWrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getProviders(context),
      child: const AutoRouter(),
    );
  }

  List<BlocProvider> getProviders(BuildContext context) {
    return [
      BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(
          context.read<LoginRepository>(),
        ),
      ),
    ];
  }
}

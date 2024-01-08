import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelter_booking/shelters_screen/domain/bloc/shelters_bloc.dart';

class MainWrapperScreen extends StatelessWidget {
  const MainWrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: getProviders(context),
      child: const AutoRouter(),
    );
  }

  getProviders(BuildContext context) {
    return [
      BlocProvider<SheltersBloc>(
        create: (_) => SheltersBloc(),
      ),
    ];
  }
}

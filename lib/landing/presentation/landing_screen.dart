import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shelter_booking/app/app_router.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/login/domain/bloc/login_bloc.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 16),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.userLoggedIn) {
                context.router.push(const MainWrapperRoute());
              }
          },
          builder: (context, state) {
            return state.status == LoginStatus.loading
                ? const SpinKitThreeInOut(color: AppColors.blue)
                : Column(
                    children: [
                      getTitleSection(context),
                      getLoginOptions(context),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget getLoginOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          getLoginByEmailButton(context),
        ],
      ),
    );
  }

  Widget getTitleSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getAppLogo(context),
        getAppTitle(),
      ],
    );
  }

  Widget getLoginByEmailButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
      child: AppButton(
        onPressed: () {
          context.router.push(const LoginRoute());
        },
        color: AppColors.lightBlue,
        text: Strings.loginByEmailText,
        iconPath: Strings.emailIconPath,
      ),
    );
  }

  Widget getAppTitle() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          Strings.appTitle,
          style: TextStyles.boldTitleTextStyle,
        ),
      );

  Widget getAppLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SvgPicture.asset(
        Strings.appLogoPath,
        height: MediaQuery.of(context).size.height * 0.33,
        width: MediaQuery.of(context).size.width * 0.6,
      ),
    );
  }
}

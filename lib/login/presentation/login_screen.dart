import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shelter_booking/app/app_router.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/login/domain/bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(refreshCallback);
    passwordController.addListener(refreshCallback);
  }

  void refreshCallback() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.userLoggedIn) {
            context.router.push(const MainWrapperRoute());
          }

          if (state.status == LoginStatus.userNotExisting) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return getAlertDialog(context);
                });
          }
        },
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getBackButton(context),
                  getLoginIcon(),
                  getLoginTitle(),
                  getEmailField(),
                  getPasswordField(),
                  getResetPasswordButton(context),
                  getLoginButton(),
                  getNoAccountText(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getResetPasswordButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8),
      child: GestureDetector(
        onTap: () {
          context.router.push(const ResetPasswordRoute());
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              Strings.resetPasswordText,
              style: TextStyles.boldGreyTextStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget getBackButton(BuildContext context) {
    return AppBackButton(
      onTap: () {
        context.router.pop();
      },
    );
  }

  Widget getNoAccountText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(Strings.noAccountText),
          getSignUpButton(context),
        ],
      ),
    );
  }

  Widget getSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: () {
          context.router.push(const RegisterRoute());
        },
        child: const Text(
          Strings.signUpText,
          style: TextStyles.normalBoldTextStyle,
        ),
      ),
    );
  }

  Widget getLoginTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.loginText,
          style: TextStyles.boldSubtitleTextStyle,
        ),
        Text(Strings.pleaseSignInText),
      ],
    );
  }

  Widget getAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.accountNotFoundText),
      content: const Text(Strings.noAccountOrWrongCredentialsText),
      actions: <Widget>[
        getTryAgainButton(context),
        getRegisterButton(context),
      ],
    );
  }

  Widget getRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.router.pop();
        context.router.push(const RegisterRoute());
      },
      child: const Text(Strings.registerText),
    );
  }

  Widget getTryAgainButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.router.pop();
      },
      child: const Text(Strings.tryAgainText),
    );
  }

  Widget getLoginIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Strings.loginIconPath,
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.3,
        ),
      ],
    );
  }

  Widget getPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: AppTextField(
        borderRadius: 16,
        hintText: Strings.passwordText,
        obscureText: !isPasswordVisible,
        suffixIcon: getVisibilityIcon(),
        controller: passwordController,
      ),
    );
  }

  Widget getVisibilityIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPasswordVisible = !isPasswordVisible;
        });
      },
      child: isPasswordVisible
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
    );
  }

  Widget getEmailField() => Form(
        key: _emailKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: AppTextField(
            borderRadius: 16,
            hintText: Strings.emailText,
            controller: emailController,
            validator: isEmailValid,
          ),
        ),
      );

  String? isEmailValid(String? email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(email ?? '')) {
      return 'Email should look like: user@gotravel.com';
    }
    return null;
  }

  Widget getLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 44, left: 24, right: 24),
      child: AppButton(
          onPressed: () {
            if (_emailKey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginEvent.loginUserByEmail(
                  email: emailController.text,
                  password: passwordController.text));
            }
          },
          buttonEnabled:
              emailController.text != '' && passwordController.text != '',
          color: AppColors.blue,
          text: Strings.signInText),
    );
  }
}

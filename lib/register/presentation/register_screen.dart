import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shelter_booking/app/app_router.dart';
import 'package:shelter_booking/login/domain/bloc/login_bloc.dart';

import '../../core/core.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(refreshCallback);
    passwordController.addListener(refreshCallback);
    nameController.addListener(refreshCallback);
  }

  void refreshCallback() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.userRegistered) {
            context.router.push(const LoginRoute());
          }
        },
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBackButton(
                  onTap: () {
                    context.router.pop();
                  },
                ),
                getRegisterIcon(context),
                getRegisterTitle(),
                getNameField(),
                getEmailField(),
                getPasswordField(),
                getRegisterButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? isEmailValid(String? email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(email ?? '')) {
      return 'Email incorrect format: xx@xx.xx';
    }
    return null;
  }

  String? isPasswordValid(String? password) {
    const lengthRequirement = 8;
    final uppercasePattern = RegExp(r'[A-Z]');
    final lowercasePattern = RegExp(r'[a-z]');
    final digitPattern = RegExp(r'[0-9]');
    final specialCharPattern = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    final hasLength = password!.length >= lengthRequirement;
    final hasUppercase = uppercasePattern.hasMatch(password);
    final hasLowercase = lowercasePattern.hasMatch(password);
    final hasDigit = digitPattern.hasMatch(password);
    final hasSpecialChar = specialCharPattern.hasMatch(password);

    if (hasLength &&
        hasUppercase &&
        hasLowercase &&
        hasDigit &&
        hasSpecialChar) {
      return null;
    }
    return 'Password not strong enough';
  }

  Widget getRegisterTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.registerText,
          style: TextStyles.boldSubtitleTextStyle,
        ),
        Text(Strings.pleaseSignUpText),
      ],
    );
  }

  Widget getRegisterIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Strings.registerIconPath,
          width: MediaQuery.of(context).size.width * 0.33,
          height: MediaQuery.of(context).size.height * 0.33,
        ),
      ],
    );
  }

  Widget getPasswordField() {
    return Form(
      key: _passwordKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: AppTextField(
          borderRadius: 16,
          hintText: Strings.passwordText,
          obscureText: !isPasswordVisible,
          suffixIcon: getVisibilityIcon(),
          controller: passwordController,
          validator: isPasswordValid,
        ),
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
          padding: const EdgeInsets.only(top: 12),
          child: AppTextField(
            borderRadius: 16,
            hintText: Strings.emailText,
            controller: emailController,
            validator: isEmailValid,
          ),
        ),
      );

  Widget getRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 44, left: 24, right: 24),
      child: AppButton(
          onPressed: () {
            final validEmail = _emailKey.currentState!.validate();
            final validPassword = _passwordKey.currentState!.validate();
            if (validEmail && validPassword) {
              context.read<LoginBloc>().add(
                    LoginEvent.registerUser(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
            }
          },
          buttonEnabled: emailController.text != '' &&
              passwordController.text != '' &&
              nameController.text != '',
          color: AppColors.blue,
          text: Strings.signUpText),
    );
  }

  Widget getNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: AppTextField(
        borderRadius: 16,
        hintText: Strings.nameText,
        controller: nameController,
      ),
    );
  }
}

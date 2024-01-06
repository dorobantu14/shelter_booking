import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelter_booking/core/core.dart';
import 'package:shelter_booking/login/domain/bloc/login_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  final _emailKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.addListener(refreshCallback);
  }

  void refreshCallback() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.resetEmailPasswordSent) {
            context.router.pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getResetPasswordTitle(),
              getEmailField(),
              getResetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  String? isEmailValid(String? email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(email ?? '')) {
      return 'Email should look like: user@gotravel.com';
    }
    return null;
  }

  Widget getResetPasswordTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.resetPasswordText,
          style: TextStyles.boldSubtitleTextStyle,
        ),
        Text(
          Strings.enterEmailAddressText,
          style: TextStyles.normalGreyTextStyle,
        ),
      ],
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

  Widget getResetPasswordButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 44, left: 24, right: 24),
      child: AppButton(
          onPressed: () {
            if (_emailKey.currentState!.validate()) {
              context.read<LoginBloc>().add(
                    LoginEvent.resetPassword(
                      email: emailController.text,
                    ),
                  );
            }
          },
          buttonEnabled: emailController.text != '',
          color: AppColors.blue,
          text: Strings.resetPasswordText),
    );
  }
}

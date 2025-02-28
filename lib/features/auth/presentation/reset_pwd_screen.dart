// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/constants/assets_path.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/core/widgets/custom_button.dart';
import 'package:taskify/core/widgets/custom_textfield.dart';
import 'package:taskify/core/widgets/error_message.dart';
import 'package:taskify/core/widgets/success_message.dart';
import 'package:taskify/features/auth/blocs/reset_pwd_bloc/reset_pwd_bloc.dart';
import 'package:taskify/features/auth/blocs/reset_pwd_bloc/reset_pwd_event.dart';
import 'package:taskify/features/auth/blocs/reset_pwd_bloc/reset_pwd_state.dart';
import 'package:taskify/features/auth/data/models/reset_pwd_model.dart';

class ResetPwdScreen extends StatefulWidget {
  const ResetPwdScreen({super.key});

  @override
  State<ResetPwdScreen> createState() => _ResetPwdScreenState();
}

class _ResetPwdScreenState extends State<ResetPwdScreen> {
  // Text editing controller
  final emailController = TextEditingController();
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Focus node
  final FocusNode _emailFocusNode = FocusNode();

  void _onFocusChange() {
    setState(() {
      // Trigger rebuild
    });
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Remove and dispose listener
    _emailFocusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _resetPwd() {
    if (_formKey.currentState!.validate()) {
      // Create reset password model with form data
      final resetPwdModel = ResetPwdModel(
        email: emailController.text.trim(),
      );
      // Trigger reset password event
      context.read<ResetPwdBloc>().add(ResetPasswordRequested(resetPwdModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    //set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            LineAwesomeIcons.angle_left_solid,
          ),
        ),
      ),
      body: BlocConsumer<ResetPwdBloc, ResetPwdState>(
        listener: (context, state) {
          if (state is ResetPwdFailure) {
            ErrorMessage.show(context, state.errorMessage);
          }
          if (state is ResetPwdSuccess) {
            //show success message
            SuccessMessage.show(
              context,
              'Reset link was sent to ${emailController.text.trim()}',
            );
            // Navigate to the log in screen
            Navigator.pushNamed(
              context,
              TaskifyRouter.logInScreenRoute,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Image.asset(
                            AssetsPath.taskifyLogo,
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Heading
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Text(
                            'Reset password',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Sub heading
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Fill out the form below',
                        style: TextStyle(
                          color: AppColors.greyDark,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email textfield
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email*',
                      prefixIcon: Icons.mail,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.text,
                      isLoading: state is ResetPwdLoading,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "What's your email?";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Reset password button
                    CustomButton(
                      onPressed: _resetPwd,
                      buttonText: 'Reset',
                      isLoading: state is ResetPwdLoading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

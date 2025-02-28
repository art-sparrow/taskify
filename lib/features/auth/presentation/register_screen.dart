// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/constants/assets_path.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/core/widgets/custom_button.dart';
import 'package:taskify/core/widgets/custom_pwd_textfield.dart';
import 'package:taskify/core/widgets/custom_textfield.dart';
import 'package:taskify/core/widgets/error_message.dart';
import 'package:taskify/features/auth/blocs/register_bloc/register_bloc.dart';
import 'package:taskify/features/auth/blocs/register_bloc/register_event.dart';
import 'package:taskify/features/auth/blocs/register_bloc/register_state.dart';
import 'package:taskify/features/auth/data/models/register_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  // Focus nodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  void _onFocusChange() {
    setState(() {
      // Trigger rebuild
    });
  }

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _nameFocusNode.addListener(_onFocusChange);
    _phoneFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    // Remove listeners
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _nameFocusNode.removeListener(_onFocusChange);
    _phoneFocusNode.removeListener(_onFocusChange);
    // Dispose listeners
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text.length < 8) {
        ErrorMessage.show(context, 'Password should be at least 8 characters');
        return;
      }
      // Create register model with form data
      final signUpModel = RegisterModel(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        joinedOn: '',
        uid: '',
        fcmToken: '',
      );
      // Trigger register event
      context.read<RegisterBloc>().add(RegisterRequested(signUpModel));
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
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterFailure) {
            ErrorMessage.show(context, state.errorMessage);
          }
          if (state is RegisterSuccess) {
            // Show notification
            /* NotificationService().showNotification(
              id: 0,
              title: 'Welcome',
              message: 'Enjoy your task management journey!',
            ); */
            // Navigate to the landing screen
            Navigator.pushNamed(
              context,
              TaskifyRouter.landingScreenRoute,
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
                            'Register',
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
                    // Name textfield
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Name*',
                      prefixIcon: Icons.person_rounded,
                      focusNode: _nameFocusNode,
                      keyboardType: TextInputType.text,
                      isLoading: state is RegisterLoading,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "What's your name?";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // phone textfield
                    CustomTextField(
                      controller: phoneController,
                      labelText: 'Phone*',
                      prefixIcon: Icons.phone,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.number,
                      isLoading: state is RegisterLoading,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "What's your phone?";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Email textfield
                    CustomTextField(
                      controller: emailController,
                      labelText: 'Email*',
                      prefixIcon: Icons.mail,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.text,
                      isLoading: state is RegisterLoading,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "What's your email?";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Password textfield
                    CustomPwdTextField(
                      controller: passwordController,
                      labelText: 'Password*',
                      prefixIcon: Icons.key,
                      focusNode: _passwordFocusNode,
                      keyboardType: TextInputType.text,
                      suffixIcon: LineAwesomeIcons.eye,
                      isLoading: state is RegisterLoading,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "What's your password?";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // register button
                    CustomButton(
                      onPressed: _register,
                      buttonText: 'Register',
                      isLoading: state is RegisterLoading,
                    ),
                    const SizedBox(height: 15),
                    // Log in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Do you have an account?',
                          style: TextStyle(
                            color: AppColors.greyDark,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          // navigate to the log in screen
                          onTap: state is RegisterLoading
                              ? null
                              : () async {
                                  await Navigator.pushNamed(
                                    context,
                                    TaskifyRouter.logInScreenRoute,
                                  );
                                },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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

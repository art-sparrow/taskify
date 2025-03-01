import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:taskify/core/constants/assets_path.dart';
import 'package:taskify/core/services/notification_service.dart';
import 'package:taskify/core/utils/app_colors.dart';
import 'package:taskify/core/utils/router.dart';
import 'package:taskify/core/widgets/custom_button.dart';
import 'package:taskify/core/widgets/custom_pwd_textfield.dart';
import 'package:taskify/core/widgets/custom_textfield.dart';
import 'package:taskify/core/widgets/error_message.dart';
import 'package:taskify/features/auth/blocs/login_bloc/login_bloc.dart';
import 'package:taskify/features/auth/blocs/login_bloc/login_event.dart';
import 'package:taskify/features/auth/blocs/login_bloc/login_state.dart';
import 'package:taskify/features/auth/data/models/login_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  // Focus nodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
  }

  @override
  void dispose() {
    // Remove listeners
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    // Dispose listeners
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _logIn() {
    if (_formKey.currentState!.validate()) {
      // Create SignIn model with form data
      final logInModel = LogInModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Trigger sign in event
      context.read<LogInBloc>().add(LogInRequested(logInModel));
    }
  }

  void _logInViaGoogle() {
    // Trigger sign in event
    context.read<LogInBloc>().add(GoogleLogInRequested());
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
      body: BlocConsumer<LogInBloc, LogInState>(
        listener: (context, state) {
          if (state is LogInFailure) {
            // Show error message
            ErrorMessage.show(context, state.errorMessage);
          }
          if (state is LogInSuccess) {
            // Show notification
            NotificationService().showNotification(
              id: 1,
              title: 'Welcome back',
              message: 'Pick up from where you left!',
            );
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
                            'Log in',
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
                      isLoading: state is LogInLoading,
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
                      prefixIcon: Icons.key_rounded,
                      focusNode: _passwordFocusNode,
                      keyboardType: TextInputType.text,
                      suffixIcon: LineAwesomeIcons.eye,
                      isLoading: state is LogInLoading,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "What's your password?";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Reset password link
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: GestureDetector(
                        onTap: state is LogInLoading
                            ? () {}
                            : () async {
                                await Navigator.pushNamed(
                                  context,
                                  TaskifyRouter.resetPwdScreenRoute,
                                );
                              },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Trouble signing in?',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Log in button
                    CustomButton(
                      onPressed: _logIn,
                      buttonText: 'Log in',
                      isLoading: state is LogInLoading,
                    ),
                    const SizedBox(height: 25),
                    // Google log in
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.greyDark,
                              thickness: 0.2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                color: AppColors.greyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.greyDark,
                              thickness: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google log in button
                        GestureDetector(
                          onTap: _logInViaGoogle,
                          child: const CircleAvatar(
                            backgroundColor: AppColors.transparent,
                            radius: 20,
                            backgroundImage: AssetImage(
                              AssetsPath.googleLogo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Are you new here?',
                          style: TextStyle(
                            color: AppColors.greyDark,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          // navigate to the register screen
                          onTap: state is LogInLoading
                              ? () {}
                              : () async {
                                  await Navigator.pushNamed(
                                    context,
                                    TaskifyRouter.registerScreenRoute,
                                  );
                                },
                          child: const Text(
                            'Register',
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

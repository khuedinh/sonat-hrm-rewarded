import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/activity_indicator/activity_indicator.dart';
import 'package:sonat_hrm_rewarded/src/packages/authentication_repository/authentication_repository.dart';
import 'package:sonat_hrm_rewarded/src/screens/login/cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) {
          if (current.status.isFailure &&
              previous.status.isFailure != current.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content:
                      Text(current.errorMessage ?? 'Authentication Failure'),
                ),
              );
          }
          return true;
        },
        builder: (context, state) => Scaffold(
          body: (Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                image: AssetImage('assets/images/login_image.png'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "WELCOME",
                                  style: TextStyle(
                                      color: Color(0xFF212B36),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                              ),
                              Text(
                                "To Sonat HRM Rewarded",
                                style: TextStyle(
                                    color: Color(0xFF212B36),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          const Image(
                            image: AssetImage('assets/images/sonat_logo.jpg'),
                            width: 100,
                          ),
                          Material(
                            color: Colors.white,
                            child: Column(
                              children: [
                                _GoogleLoginButton(),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            context.read<LoginCubit>().logInWithGoogle();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: const Color(0xFFE2E2E2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/google_logo.png'),
                  width: 24,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Sign in with Google",
                  style: TextStyle(
                      color: Color(0xFF212B36),
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(
                  width: 10,
                ),
                state.status.isInProgress
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: ActivityIndicator(),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}

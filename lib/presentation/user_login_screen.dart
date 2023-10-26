import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:android_pos_mini/general_functions/general_functions.dart';
import 'package:android_pos_mini/models/api_models/admin/admin_user.dart';
import 'package:android_pos_mini/presentation/admin_login_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showProgressBar = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RootBloc, RootState>(
      listener: (context, state) {
        if (state.runtimeType == NavigateFromLoginScreenToMainScreenState) {
          final user = (state as NavigateFromLoginScreenToMainScreenState).userName;
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  MainScreen(userName: user,)));
        }
        if (state.runtimeType == LoginScreenShowSnackbarMessageState) {
          final message =
              (state as LoginScreenShowSnackbarMessageState).errorMessage;

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      },
      listenWhen: (prev, cur) {
        if (cur is UiActionState) {
          return true;
        } else {
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur is UiBuildState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        var showPassword = false;

        if (state.runtimeType == LoginScreenShowPasswordState) {
          showPassword = (state as LoginScreenShowPasswordState).showPassword;
        }
        if (state.runtimeType == ApiFetchingStartedState) {
          _showProgressBar = true;
        }
        if (state.runtimeType == ApiFetchingFailedState) {
          _showProgressBar = false;
        }

        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: _showProgressBar ? 0.3 : 1,
                    child: Card(
                      //color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, left: 16, right: 16, bottom: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter valid user name';
                                  }
                                  return null;
                                },
                                controller: _userNameController,
                                decoration: InputDecoration(
                                  label: const Text("User Name"),
                                  hintText: "Enter User Name",
                                  hintStyle: TextStyle(
                                    color: Colors.black26.withOpacity(0.3),
                                  ),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 3) {
                                    return 'Please enter valid password';
                                  }
                                  return null;
                                },
                                maxLines: 1,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  label: const Text("Password"),
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                    color: Colors.black26.withOpacity(0.3),
                                  ),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: showPassword
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                    onPressed: () {
                                      context.read<RootBloc>().add(
                                          LoginScreenShowPasswordClickedEvent(
                                              showPassword: showPassword));
                                    },
                                  ),
                                ),
                                obscureText: !showPassword,
                                onFieldSubmitted: (value) {
                                  if (_formKey.currentState!.validate()) {
                                    final adminUser = AdminUser(
                                      adminName: _userNameController.text,
                                      adminPassword:
                                      _passwordController.text,
                                      licenseKey: 'key',
                                      isLicenceKeyVerified: true,
                                    );
                                    context.read<RootBloc>().add(
                                      LoginScreenLoginEvent(
                                        adminUser: adminUser,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminLoginScreen()));
                                  },
                                  child: const Text("Login as admin user"),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: _showProgressBar
                                    ? null
                                    : () {
                                        // To hide keyboard
                                        hideKeyboard(context);

                                        if (_formKey.currentState!.validate()) {
                                          final adminUser = AdminUser(
                                            adminName: _userNameController.text,
                                            adminPassword:
                                                _passwordController.text,
                                            licenseKey: 'key',
                                            isLicenceKeyVerified: true,
                                          );
                                          context.read<RootBloc>().add(
                                                LoginScreenLoginEvent(
                                                  adminUser: adminUser,
                                                ),
                                              );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white),
                                child: const Text('Login'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _showProgressBar
                  ? const CircularProgressIndicator()
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}

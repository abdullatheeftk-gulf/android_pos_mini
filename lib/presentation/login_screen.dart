import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.green.shade50,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 24,left:16,right:16,bottom: 16),
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
                        controller: _passwordController,
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          hintText: "Enter Password",
                          hintStyle: TextStyle(
                            color: Colors.black26.withOpacity(0.3),
                          ),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        child: const Text('Login'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}

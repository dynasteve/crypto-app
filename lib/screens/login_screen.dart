import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    final storedPassword = prefs.getString('password');

    // simple credential check
    if (_emailController.text == storedEmail &&
        _passwordController.text == storedPassword) {
      await prefs.setBool('logged_in', true);
      if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() => _errorMessage = 'Invalid email or password');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'AIO Crypto',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: const Text('Don’t have an account? Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

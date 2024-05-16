import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    final AuthResponse response = await supabase.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    final Session? session = response.session;
    final User? user = response.user;
    if (session != null && user != null) {
      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up failed! Please try again.')),
      );
    }
  }

  void _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final AuthResponse response = await supabase.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final Session? session = response.session;
    final User? user = response.user;
    setState(() {
      _isLoading = false;
    });
    if (session != null && user != null) {
      // Navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign In failed. Please ensure your details are correct.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Auth Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (!_isLoading)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                  ),
                  ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

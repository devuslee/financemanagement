import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/moneymap.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 60), // Adjust this based on your design
                        _buildPasswordField("Enter New Password", Icons.lock_outline, passwordController),
                        SizedBox(height: 20),
                        _buildPasswordField("Confirm New Password", Icons.lock_outline, confirmPasswordController),
                        SizedBox(height: 20),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Text(
                              _error!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updatePassword,
                            child: Text("Update Password"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String labelText, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        suffixIcon: IconButton(
          icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
    );
  }

  void _updatePassword() async {
    setState(() {
      _error = null;
    });

    if (passwordController.text.isEmpty) {
      setState(() {
        _error = "Please enter a password";
      });
      return;
    } else if (!_isPasswordValid(passwordController.text)) {
      setState(() {
        _error = "Password must be at least 8 characters long and contain symbols, capital letters, and numbers";
      });
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        _error = "Please confirm your password";
      });
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _error = "Passwords do not match";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.currentUser?.updatePassword(passwordController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      setState(() {
        _error = "Failed to update password: ${e.toString()}";
      });
    }
  }

  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+]).{8,}$');
    return regex.hasMatch(password);
  }
}

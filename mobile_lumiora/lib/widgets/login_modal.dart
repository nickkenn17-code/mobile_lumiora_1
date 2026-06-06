import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginModal extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginModal({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  // State variable to determine the form mode (Login or Register)
  bool _isRegisterMode = false;

  final Color olive = const Color(0xFFA3B04A);

  Future<void> _handleSubmit() async {
    final username = _userController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passController.text;

    if (username.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    if (_isRegisterMode) {
      // ==========================================
      // REGISTER SCENARIO
      // ==========================================
      // Simulate a short loading delay for registration
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );

      // Automatically return to login mode after successful registration
      setState(() {
        _isRegisterMode = false;
        _loading = false;
      });
    } else {
      // ==========================================
      // LOGIN SCENARIO
      // ==========================================
      final authService = AuthService();
      final success = await authService.login(username, phone, password);

      if (!mounted) return;

      if (success) {
        Navigator.pop(context);
        widget.onLoginSuccess();
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials';
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title changes dynamically based on the mode
            Text(
              _isRegisterMode ? 'Create New Account' : 'Sign In to Continue', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF202020)),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade400),
                ),
                child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade700)),
              ),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
              enabled: !_loading,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: olive,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _loading ? null : _handleSubmit,
                // Main button text changes dynamically
                child: _loading
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isRegisterMode ? 'REGISTER' : 'LOGIN', style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loading ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 8),
            // Switch button at the bottom to toggle form mode
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRegisterMode ? "Already have an account? " : "Don't have an account? ",
                  style: const TextStyle(color: Colors.black54),
                ),
                GestureDetector(
                  onTap: _loading 
                      ? null 
                      : () {
                          setState(() {
                            _isRegisterMode = !_isRegisterMode;
                            // Reset error message when switching modes
                            _errorMessage = null; 
                          });
                        },
                  child: Text(
                    _isRegisterMode ? "Login" : "Register",
                    style: TextStyle(
                      color: olive,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
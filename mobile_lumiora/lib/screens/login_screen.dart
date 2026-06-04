// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _userController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passController = TextEditingController();
//   bool _loading = false;

//   final Color pageBg = const Color(0xFFF2EEE6);
//   final Color olive = const Color(0xFFA3B04A);
//   final Color oliveDark = const Color(0xFF8E9B3A);

//   Future<void> _login() async {
//     final username = _userController.text.trim();
//     final phone = _phoneController.text.trim();
//     final password = _passController.text;
//     if (username.isEmpty || password.isEmpty || phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter username, phone number, and password')));
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       final apiHost = kIsWeb ? 'localhost' : '10.0.2.2';
//       final uri = Uri.parse('http://$apiHost:3000/api/login');
//       final resp = await http.post(uri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'username': username, 'phone': phone, 'password': password}));

//       if (resp.statusCode == 200) {
//         final body = jsonDecode(resp.body);
//         if (body['success'] == true) {
//           if (!mounted) return;
//           Navigator.pushReplacementNamed(context, '/menu');
//           return;
//         }
//       }

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _userController.dispose();
//     _phoneController.dispose();
//     _passController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: pageBg,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 26),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 88,
//                   height: 88,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF2EEE1),
//                     shape: BoxShape.circle,
//                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0,6))],
//                   ),
//                   child: const Center(child: Text('L', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: Color(0xFFB18A49)))),
//                 ),
//                 const SizedBox(height: 18),
//                 const Text('Welcome to LUMIORA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF202020))),
//                 const SizedBox(height: 8),
//                 const Text('Sign in to continue', style: TextStyle(color: Colors.black54)),
//                 const SizedBox(height: 20),

//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF7F3EA),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: const Color(0xFFD6C9B8)),
//                   ),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: _userController,
//                         decoration: const InputDecoration(labelText: 'Username'),
//                       ),
//                       const SizedBox(height: 12),
//                       TextField(
//                         controller: _phoneController,
//                         decoration: const InputDecoration(labelText: 'Phone Number'),
//                       ),
//                       const SizedBox(height: 12),
//                       TextField(
//                         controller: _passController,
//                         decoration: const InputDecoration(labelText: 'Password'),
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: 18),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: olive, padding: const EdgeInsets.symmetric(vertical: 14)),
//                           onPressed: _loading ? null : _login,
//                           child: _loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('LOGIN', style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Create an account', style: TextStyle(color: Colors.black87)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

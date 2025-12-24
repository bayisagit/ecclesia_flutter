import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../widgets/auth_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Column(
        children: [
          AuthHeader(title: 'Sign Up', showBackButton: true),
          // Form Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First Name',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'John',
                                    filled: true,
                                    fillColor: Theme.of(context).cardColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter first name' : null,
                                  onChanged: (val) {
                                    setState(() => firstName = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Name',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Doe',
                                    filled: true,
                                    fillColor: Theme.of(context).cardColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter last name' : null,
                                  onChanged: (val) {
                                    setState(() => lastName = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'demo@email.com',
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter an email';
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(val)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Create a password',
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (val.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          if (!val.contains(RegExp(r'[A-Z]'))) {
                            return 'Must contain at least one uppercase letter';
                          }
                          if (!val.contains(RegExp(r'[a-z]'))) {
                            return 'Must contain at least one lowercase letter';
                          }
                          if (!val.contains(RegExp(r'[0-9]'))) {
                            return 'Must contain at least one number';
                          }
                          if (!val.contains(
                            RegExp(r'[!@#\$&*~^%()_+=|<>?{}\[\]~-]'),
                          )) {
                            return 'Must contain at least one special character';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          onPressed: loading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    final auth = Provider.of<AuthService>(
                                      context,
                                      listen: false,
                                    );
                                    try {
                                      await auth.signUp(
                                        email,
                                        password,
                                        firstName,
                                        lastName,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.of(
                                        context,
                                      ).popUntil((route) => route.isFirst);
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      setState(() {
                                        loading = false;
                                        if (e is FirebaseAuthException) {
                                          error =
                                              e.message ?? 'An error occurred';
                                        } else {
                                          error = e.toString();
                                        }
                                      });
                                    }
                                  }
                                },
                          child: loading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Center(
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Center(child: Text('Or sign up with Google')),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: Text(
                            'Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async {
                            final auth = Provider.of<AuthService>(
                              context,
                              listen: false,
                            );
                            dynamic result = await auth.signInWithGoogle();
                            if (!context.mounted) return;
                            if (result == null) {
                              setState(
                                () => error = 'Could not sign up with Google',
                              );
                            } else {
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xFFFF8A80),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

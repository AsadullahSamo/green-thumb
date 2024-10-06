import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green/constants.dart';
import 'package:green/ui/root_page.dart'; // Import your homepage here
import 'package:green/ui/screens/forgot_password.dart';
import 'package:green/ui/screens/signup_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHovered = false;
  bool isRegisterHovered = false; // Track hover state for Register text
  bool isResetHovered = false; // Track hover state for Reset Here text

  signin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Show success message before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully logged in!')),
      );

      // Delay navigation to allow user to see success message
      Future.delayed(Duration(seconds: 1), () {
        // Navigate to the homepage on successful sign-in
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RootPage()),
        );
      });
    } on FirebaseAuthException catch (e) {
    // Handle specific Firebase authentication errors
    String errorMessage;
    
    if(e.message == 'The supplied auth credential is incorrect, malformed or has expired.') {
      errorMessage = 'Invalid email or password';
    } else {
      errorMessage = e.message!; // Fallback error message
    }
      // Show the error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Center the column items
              children: [
                Image.asset('assets/images/signin.png'),
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHovered = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHovered = false;
                    });
                  },
                  child: Container(
                    width: size.width * 0.98, // Set width to 90%
                    height: 35, // Set height to 25px
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signin(); // Call signin function
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isHovered
                            ? Constants.primaryColor.withOpacity(0.8) // Hover color
                            : Constants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded shape
                        ),
                        elevation: 5, // Adding elevation for depth
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white, // Change text color to primary
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click, // Apply cursor pointer effect
                  onEnter: (_) {
                    setState(() {
                      isResetHovered = true; // Track hover state
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isResetHovered = false; // Reset hover state
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPassword())
                      );
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'Forgot Password? ',
                            style: TextStyle(
                              color: isResetHovered ? Constants.primaryColor : Constants.blackColor, // Change color on hover
                              decoration: isResetHovered ? TextDecoration.underline : TextDecoration.none, // Underline on hover
                            ),
                          ),
                          TextSpan(
                            text: 'Reset Here',
                            style: TextStyle(
                              color: isResetHovered ? Colors.blue : Constants.primaryColor, // Change color on hover
                              decoration: isResetHovered ? TextDecoration.underline : TextDecoration.none, // Underline on hover
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click, // Apply cursor pointer effect
                  onEnter: (_) {
                    setState(() {
                      isRegisterHovered = true; // Track hover state
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isRegisterHovered = false; // Reset hover state
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp())
                      );
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'New to Green Thumb? ',
                            style: TextStyle(
                              color: isRegisterHovered
                                  ? Constants.primaryColor
                                  : Constants.blackColor, // Change color on hover
                              decoration: isRegisterHovered
                                  ? TextDecoration.underline
                                  : TextDecoration.none, // Underline on hover
                            ),
                          ),
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: isRegisterHovered
                                  ? Colors.blue
                                  : Constants.primaryColor, // Change color on hover
                              decoration: isRegisterHovered
                                  ? TextDecoration.underline
                                  : TextDecoration.none, // Underline on hover
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

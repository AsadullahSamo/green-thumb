import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green/constants.dart';
import 'package:green/ui/screens/widgets/profile_widget.dart';
import 'package:green/ui/screens/signin_page.dart';
import 'package:page_transition/page_transition.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user
  User? user;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser; // Get the current logged-in user
  }

  // Function to log out the user
  Future<void> _signOut() async {
    await _auth.signOut();
    // Ensure a proper transition back to the sign-in page
    Navigator.push(
      context,
      PageTransition(child: const SignIn(), type: PageTransitionType.fade),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Add some top padding
              // User avatar
              Container(
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Constants.primaryColor.withOpacity(.5),
                    width: 5.0,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 40),
                ),
              ),
              const SizedBox(height: 10),
              // Display user information
              SizedBox(
                width: size.width * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      user?.displayName ?? 'John Doe', // Display user's name if available
                      style: TextStyle(
                        color: Constants.blackColor,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 3),
                    SizedBox(
                      height: 24,
                      child: Image.asset("assets/images/verified.png"),
                    ),
                  ],
                ),
              ),
              Text(
                user?.email ?? 'johndoe@gmail.com', // Display user's email
                style: TextStyle(
                  color: Constants.blackColor.withOpacity(.3),
                ),
              ),
              const SizedBox(height: 30),
              // Profile options (Wrap inside Expanded to manage layout)
              SizedBox(
                width: size.width * .8,
                child: Column(
                  children: [
                    _buildProfileOption(Icons.person, 'My Profile'),
                    SizedBox(height: 10),
                    _buildProfileOption(Icons.settings, 'Settings'),
                    SizedBox(height: 10),
                    _buildProfileOption(Icons.notifications, 'Notifications'),
                    SizedBox(height: 10),
                    _buildProfileOption(Icons.chat, 'FAQs'),
                    SizedBox(height: 10),
                    _buildProfileOption(Icons.share, 'Share'),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _signOut, // Log out on tap
                      child: _buildProfileOption(Icons.logout, 'Log Out', isLogout: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {bool isLogout = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        onPressed: isLogout ? _signOut : () {
          // Handle other profile options if needed
        },
        child: ProfileWidget(
          icon: icon,
          title: title,
        ),
      ),
    );
  }
}

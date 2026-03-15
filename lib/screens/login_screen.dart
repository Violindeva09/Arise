import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/system_provider.dart';
import '../config/ui_config.dart';
import '../services/system_audio_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AriseUI.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: AriseUI.hudPanel(),
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AriseUI.ornament(),
                const SizedBox(height: 16),
                Text("HUNTER IDENTIFICATION",
                    style: AriseUI.heading.copyWith(fontSize: 18)),
                const SizedBox(height: 32),
                _buildField(_userController, "USERNAME", Icons.person_outline),
                const SizedBox(height: 16),
                _buildField(_emailController, "EMAIL ID", Icons.email_outlined),
                const SizedBox(height: 16),
                _buildField(_passController, "PASSWORD", Icons.lock_outline,
                    isPassword: true),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_userController.text.isNotEmpty &&
                          _emailController.text.isNotEmpty &&
                          _passController.text.isNotEmpty) {
                        SystemAudioService().playLevelUp();
                        Provider.of<SystemProvider>(context, listen: false)
                            .init(
                          _userController.text,
                          _emailController.text,
                        );
                      } else {
                        SystemAudioService().playAlert();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AriseUI.primary.withOpacity(0.05),
                      side: BorderSide(color: AriseUI.primary, width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    child: Text("AUTHENTICATE",
                        style: AriseUI.label.copyWith(letterSpacing: 4)),
                  ),
                ),
                const SizedBox(height: 32),
                _buildDivider(),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                        child: _buildSocialButton(
                            "GOOGLE", Icons.g_mobiledata, Colors.redAccent)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildSocialButton(
                            "APPLE", Icons.apple, Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white10)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text("OR CONTINUE WITH",
              style:
                  AriseUI.label.copyWith(color: Colors.white24, fontSize: 8)),
        ),
        const Expanded(child: Divider(color: Colors.white10)),
      ],
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () async {
        SystemAudioService().playClick();
        if (label == "GOOGLE") {
          await _handleGoogleSignIn();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: AriseUI.holographic(color: color, opacity: 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 12),
            Text(label,
                style: AriseUI.label
                    .copyWith(fontSize: 10, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null && mounted) {
          SystemAudioService().playLevelUp();
          Provider.of<SystemProvider>(context, listen: false).init(
            user.displayName ?? "Hunter",
            user.email ?? "",
          );
        }
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      if (mounted) {
        SystemAudioService().playAlert();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Authentication Failed: $e"),
            backgroundColor: AriseUI.danger,
          ),
        );
      }
    }
  }

  Widget _buildField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AriseUI.primary, size: 18),
        labelText: label,
        labelStyle: AriseUI.label.copyWith(fontSize: 10, color: Colors.white38),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AriseUI.primary)),
        filled: true,
        fillColor: Colors.black,
      ),
    );
  }
}

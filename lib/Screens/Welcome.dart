import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Subtle shadow effect
      body: Center(
        child: Container(
          width: 320,
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red top with hockey player
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFD32F2F),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/screen_pic.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // White bottom with text and buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    // Logo
                    Image.asset(
                      'assets/screen_pic.png',
                      height: 32,
                    ),
                    SizedBox(height: 8),
                    // Title
                    Text(
                      "Plan, Play, and Perform to Your Best.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Subtitle
                    Text(
                      "Everything you need to manage teams, track performance, and stay updated with Namibian hockey.",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                            Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SignupScreen()),
  );

                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFD32F2F),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                                                      Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
}

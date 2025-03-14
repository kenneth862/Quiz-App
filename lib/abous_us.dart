import 'package:flutter/material.dart';

class AboutUs {
  static void showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // Transparent background
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Apply rounded corners
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bgg.jpg'), // Ensure the path is correct
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(50), // Ensure the border radius matches
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ // FIXED: 'children' list is properly used
                ClipRRect(
                  borderRadius: BorderRadius.circular(40), 
                  child: Image.asset(
                    'images/dadas.jpg', 
                    width: 80, // Adjust as needed
                    height: 80,
                    fit: BoxFit.cover, // Ensures the image fills the shape
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Adjusted for visibility
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome to Quiz App! 🎉\n\n'
                  'Quiz App is designed to make learning fun and interactive. Our goal is to provide an engaging way for users to test their knowledge across various topics.\n\n'
                  'Features:\n- Multiple-choice quizzes\n- Timer-based questions\n- Leaderboard to track top scores\n- Customizable app themes\n\n'
                  'Developed with ❤️ using Flutter. Enjoy learning and have fun! 🚀',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Adjusted for better contrast
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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

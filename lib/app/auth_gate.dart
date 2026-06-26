import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../screens/welcome/welcome_screen.dart';
import '../screens/passenger_home/passenger_home_screen.dart';
import '../screens/driver_home/driver_home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        if (!authSnapshot.hasData) {
          return const WelcomeScreen();
        }

        final uid = authSnapshot.data!.uid;

        return FutureBuilder(
          future: firestoreService.getUser(uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            if (!userSnapshot.hasData || userSnapshot.data == null) {
              return const WelcomeScreen();
            }

            final user = userSnapshot.data!;

            if (user.userType == 'driver') {
              return const DriverHomeScreen();
            }

            return const PassengerHomeScreen();
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00C853),
        ),
      ),
    );
  }
}
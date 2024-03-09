import 'package:chat/core/service/auth_service.dart';
import 'package:chat/view/settings_screen/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    // Get the currently logged-in user
    final User? currentUser = _authService.getCurrentUser();

    // Stream to listen for changes in the user document
    Stream<DocumentSnapshot>? userSnapshot;

    if (currentUser != null) {
      userSnapshot = FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .snapshots();
    }

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Icon(
                          Icons.message,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                      if (userSnapshot != null)
                        StreamBuilder<DocumentSnapshot>(
                          stream: userSnapshot,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error fetching user name");
                            }
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              if (data != null && data['userName'] != null) {
                                return Text(data['userName']);
                              } else {
                                return const Text("No name");
                              }
                            }
                            return const CircularProgressIndicator();
                          },
                        )
                      else
                        const Text("Loading..."),
                    ],
                  ),
                ),
              ),

              // Home
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () => Navigator.pop(context),
                ),
              ),

              // Settings
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: const Text('S E T T I N G S'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: () => _authService.signOut(),
            ),
          ),
        ],
      ),
    );
  }
}

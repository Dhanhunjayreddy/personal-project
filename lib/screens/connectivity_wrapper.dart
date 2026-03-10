import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Listen to real-time network changes
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        // In newer versions of connectivity_plus, it returns a List of results
        final results = snapshot.data ?? [ConnectivityResult.wifi];
        final isOffline = results.contains(ConnectivityResult.none);

        if (isOffline) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.wifi_slash,
                      size: 80,
                      color: isDark ? Colors.grey[400] : Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'You are offline',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your internet connection and try again. The app will resume automatically.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const CupertinoActivityIndicator(),
                  ],
                ),
              ),
            ),
          );
        }

        // If online, show the normal app content
        return child;
      },
    );
  }
}

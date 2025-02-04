import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_detail_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

Future<void> _syncData() async {
  // Check the connectivity status
  List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.none)) {
    // If no internet connection, show a toast message
    _showToast("No internet connection");
  } else {
    // If there is internet, sync the data
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUsers();
      _showToast("Syncing data...");
    } catch (e) {
      _showToast("Failed to sync data: ${e.toString()}");
    }
  }
}

// Helper function to show a toast message
void _showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserProvider>(context, listen: false).fetchUsers(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: const Text('GeoTodo'),centerTitle: true, actions: [
             // Sync button to manually trigger data synchronization
            IconButton(
              icon: const Icon(Icons.sync, color: Colors.green),
              onPressed: () async {
                await _syncData();
               
              },
            ),
          ]),
          body: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              // Show loading spinner if there are no users yet
              return userProvider.users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                     // Build a list view to display each user
                      itemCount: userProvider.users.length,
                      itemBuilder: (context, index) {
                        var user = userProvider.users[index];

                        return Card(                          
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          shadowColor: Colors.black,
                          child: ListTile(
                            title: Text(user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.email),
                                Text("Location: (${user.lat}, ${user.lng})",
                                    style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                            trailing: ElevatedButton(
                              // Button to navigate to the user detail screen
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailScreen(user),
                                  ),
                                );
                              },
                              child: const Text("View Details"),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        );
      },
    );
  }
}
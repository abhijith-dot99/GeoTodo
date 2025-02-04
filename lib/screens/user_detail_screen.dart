import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../models/todo_model.dart';
import '../services/location_service.dart';
import '../providers/todo_provider.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;
  const UserDetailScreen(this.user, {super.key});

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Position? currentPosition;
  double? distance;
  bool isInsideGeoFence = false;
  bool geoFenceNotifications = false;

  @override
  void initState() {
    super.initState();
    // Fetch user's todos after the widget is rendered
     WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<TodoProvider>(context, listen: false).fetchTodos(widget.user.id);
  });
    _updateLocation();
  }

  /// Updates the user's GPS location & calculates distance
  void _updateLocation() async {
    try {
      currentPosition = await LocationService.getCurrentLocation();
      // Calculate the distance between the user's static location and current location
      distance = LocationService.calculateDistance(
        widget.user.lat,
        widget.user.lng,
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      _checkGeoFence();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  /// Check if the user is inside the geo-fence (within 500 meters)
  void _checkGeoFence() {
    if (distance != null && distance! < 100) {
      isInsideGeoFence = true;
    }
  }

  /// Toggle Geo-fence notifications
  void _toggleGeoFenceNotifications(bool value) {
    setState(() {
      geoFenceNotifications = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display user details such as name, email, phone, and static location
              Text('👤 Name: ${widget.user.name} ', style: const TextStyle(fontSize: 16)),
              Text('📧 Email: ${widget.user.email}', style: const TextStyle(fontSize: 16)),
              Text('📞 Phone: ${widget.user.phone} ', style: const TextStyle(fontSize: 16)),
              Text('📍 Static Location: (${widget.user.lat}, ${widget.user.lng})', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              // If currentPosition is null, show a loading spinner; else display current location and distance
              currentPosition == null
                  ? const CircularProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📌 Current Location: (${currentPosition!.latitude}, ${currentPosition!.longitude})',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '📏 Distance: ${distance?.toStringAsFixed(2) ?? "Calculating..."} meters',
                          style: const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
               // Button to refresh the GPS location
              Center(
                child: ElevatedButton(
                  onPressed: _updateLocation,
                  child: const Text('🔄 Refresh GPS'),
                ),
              ),
              const SizedBox(height: 20),
              // Display geo-fence status (inside or outside) based on the calculated distance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🛑 Geo-Fence Status:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    isInsideGeoFence ? "✅ Inside Geo-Fence" : "❌ Outside Geo-Fence",
                    style: TextStyle(fontSize: 16, color: isInsideGeoFence ? Colors.green : Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Switch to enable or disable geo-fence notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🔔 Geo-Fence Notifications', style: TextStyle(fontSize: 16)),
                  Switch(value: geoFenceNotifications, onChanged: _toggleGeoFenceNotifications),
                ],
              ),
              const SizedBox(height: 10),
              const Text('✅ To-Do List:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              Consumer<TodoProvider>(
                builder: (context, todoProvider, child) {
                  if (todoProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (todoProvider.todos.isEmpty) {
                    return const Text('No todos available');
                  }
                  return ListView.builder(
                    shrinkWrap: true, // Prevents ListView from taking full available space
                    physics: const NeverScrollableScrollPhysics(), // Prevent scrolling inside this ListView
                    itemCount: todoProvider.todos.length,
                    itemBuilder: (context, index) {
                      final todo = todoProvider.todos[index];
                      return ListTile(
                        title: Text(todo.title),
                        trailing: Icon(
                          todo.completed ? Icons.check_circle : Icons.circle_outlined,
                          color: todo.completed ? Colors.green : Colors.grey,
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}


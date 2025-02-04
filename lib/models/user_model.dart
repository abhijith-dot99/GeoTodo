// model class for user
class User {
  final int id;
  final String name;
  final String email;
  final double lat;
  final double lng;
  final String phone;


  // Constructor to initialize the User class
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.lat,
    required this.lng,
    required this.phone,
  });

// Factory method to create a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      lat: double.parse(json['address']['geo']['lat']),
      lng: double.parse(json['address']['geo']['lng']),
      phone: json['phone'],
    );
  }
}

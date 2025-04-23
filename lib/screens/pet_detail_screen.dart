import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pet_model.dart';

class PetDetailScreen extends StatefulWidget {
  final Pet pet;
  const PetDetailScreen({Key? key, required this.pet}) : super(key: key);

  @override
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  bool isFavorite = false;

  void _launchEmail(BuildContext context) async {
    final email = 'shelter@example.com'; // You can make this dynamic per pet
    final subject = Uri.encodeComponent('Inquiry about ${widget.pet.name}');
    final body = Uri.encodeComponent(
      'Hello,\n\nI am interested in adopting ${widget.pet.name}. Please share more details.\n\nThanks!',
    );
    final uri = Uri.parse('mailto:$email?subject=$subject&body=$body');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            color: isFavorite ? Colors.red : Colors.white,
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              // Optional: Save to Firestore later
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            pet.imageUrl,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pet.name,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${pet.breed} • ${pet.age} years old',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pet.description,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _launchEmail(context),
              icon: Icon(Icons.email),
              label: Text("Contact Shelter"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

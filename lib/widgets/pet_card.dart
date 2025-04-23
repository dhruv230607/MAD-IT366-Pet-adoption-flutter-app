import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../screens/pet_detail_screen.dart';
import '../services/favorite_service.dart'; // make sure this exists

class PetCard extends StatefulWidget {
  final Pet pet;

  const PetCard({Key? key, required this.pet}) : super(key: key);

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.pet.isFavorited; // assumes your Pet model has this field
  }

  void _toggleFavorite() async {
    await FavoriteService().toggleFavorite(widget.pet.id, {
      'id': widget.pet.id,
      'title': widget.pet.name,
      'type': widget.pet.breed,
      'imageUrl': widget.pet.imageUrl,
      'timestamp': DateTime.now(), // or serverTimestamp() if using Firestore
    });

    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(widget.pet.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(widget.pet.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${widget.pet.breed} • ${widget.pet.age} years old'),
        trailing: IconButton(
          icon: Icon(
            isFavorited ? Icons.favorite : Icons.favorite_border,
            color: isFavorited ? Colors.red : null,
          ),
          onPressed: _toggleFavorite,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PetDetailScreen(pet: widget.pet),
            ),
          );
        },
      ),
    );
  }
}

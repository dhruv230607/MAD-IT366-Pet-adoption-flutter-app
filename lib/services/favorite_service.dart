import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pet_model.dart';

class FavoriteService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Toggle favorite status (add or remove from favorites)
  Future<void> toggleFavorite(String itemId, Map<String, dynamic> data) async {
    final userId = _auth.currentUser!.uid;
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(itemId);

    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete(); // Unfavorite
    } else {
      await docRef.set(data); // Add to favorites
    }
  }

  // Fetch the user's favorite pets and convert them to Pet objects
  Future<List<Pet>> getFavorites() async {
    final userId = _auth.currentUser!.uid;
    try {
      // Fetch favorites from Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      // Convert the snapshot data to a list of Pet objects
      return snapshot.docs
          .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching favorites: $e");
      return []; // Return an empty list if there's an error
    }
  }

  // Save a pet as a favorite
  Future<void> saveFavorite(Pet pet) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(pet.id)
          .set(pet.toMap());
    } catch (e) {
      print("Error saving favorite: $e");
    }
  }

  // Remove a pet from favorites
  Future<void> removeFavorite(Pet pet) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(pet.id)
          .delete();
    } catch (e) {
      print("Error removing favorite: $e");
    }
  }
}

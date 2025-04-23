import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class FirestoreService {
  final CollectionReference petsRef = FirebaseFirestore.instance.collection('pets');

  Future<List<Pet>> getPets() async {
    final snapshot = await petsRef.get();
    return snapshot.docs
        .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}

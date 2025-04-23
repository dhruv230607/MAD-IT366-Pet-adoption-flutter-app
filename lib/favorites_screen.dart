import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../widgets/pet_card.dart';
import '../services/favorite_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Pet> _favoritePets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load favorite pets from the FavoriteService
  Future<void> _loadFavorites() async {
    try {
      List<Pet> pets = await FavoriteService().getFavorites(); // Fetch favorites
      setState(() {
        _favoritePets = pets;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading favorites: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Favorites")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favoritePets.isEmpty
              ? Center(child: Text("No favorite pets yet. ❤️"))
              : ListView.builder(
                  itemCount: _favoritePets.length,
                  itemBuilder: (context, index) {
                    return PetCard(pet: _favoritePets[index]);
                  },
                ),
    );
  }
}

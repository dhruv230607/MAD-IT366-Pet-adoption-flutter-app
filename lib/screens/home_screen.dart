import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/pet_card.dart';
import '../models/pet_model.dart';
import 'add_pet_screen.dart';
import '../favorites_screen.dart';  // Import Favorites Screen
import 'home_screen.dart';  // HomeScreen will now be part of a MainScreen

class HomeScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adopt a Pet")),
      body: FutureBuilder<List<Pet>>(
        future: firestoreService.getPets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final pets = snapshot.data ?? [];

          if (pets.isEmpty) {
            return Center(child: Text("No pets available for adoption."));
          }

          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              return PetCard(pet: pets[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPetScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Pet',
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[ // Removed 'const' here
    HomeScreen(),         // Your existing HomeScreen widget
    FavoritesScreen(),    // Your FavoritesScreen widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adopt a Pet")),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddPetScreen()),
                );
              },
              child: Icon(Icons.add),
              tooltip: 'Add Pet',
            )
          : null,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({Key? key}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> addPet() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('pets').add({
          'name': nameController.text.trim(),
          'breed': breedController.text.trim(),
          'age': int.parse(ageController.text.trim()),
          'imageUrl': imageUrlController.text.trim(),
          'description': descriptionController.text.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet added successfully!')),
        );

        Navigator.pop(context); // Go back to home
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }

      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    ageController.dispose();
    imageUrlController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Pet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Pet Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter name' : null,
                    ),
                    TextFormField(
                      controller: breedController,
                      decoration: InputDecoration(labelText: 'Breed'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter breed' : null,
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter age' : null,
                    ),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: InputDecoration(labelText: 'Image URL'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter image URL' : null,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      validator: (value) =>
                          value!.isEmpty ? 'Enter description' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: addPet,
                      child: Text('Add Pet'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class Pet {
  final String id;
  final String name;
  final String breed;
  final int age;
  final String imageUrl;
  final String description;
  bool isFavorited;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.imageUrl,
    required this.description,
    this.isFavorited = false,
  });

  factory Pet.fromMap(Map<String, dynamic> data, String id) {
    return Pet(
      id: id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      age: data['age'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'imageUrl': imageUrl,
      'age': age,
      'isFavorited': isFavorited,
    };
  }
}

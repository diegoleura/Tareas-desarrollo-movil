class Pizza {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> ingredients;
  final bool available;

  const Pizza({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.ingredients,
    this.available = true,
  });
}

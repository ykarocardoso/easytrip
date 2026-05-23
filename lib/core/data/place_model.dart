class PlaceModel {
  final String id;
  final String title;
  final String location;
  final String description;
  final double pricePerNight;
  final double rating;
  final String category;
  final String imageUrl;
  final bool isFavorited;

  PlaceModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.pricePerNight,
    required this.rating,
    required this.category,
    required this.imageUrl,
    required this.isFavorited,
  });

  PlaceModel copyWith({
    String? id,
    String? title,
    String? location,
    String? description,
    double? pricePerNight,
    double? rating,
    String? category,
    String? imageUrl,
    bool? isFavorited,
  }) {
    return PlaceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      description: description ?? this.description,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}

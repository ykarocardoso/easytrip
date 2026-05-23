import 'package:flutter/material.dart';
import '../data/place_model.dart';
import '../mock/mock_data.dart';

class TripModel {
  final PlaceModel place;
  final String dateRange;
  final DateTime bookingDate;

  TripModel({
    required this.place,
    required this.dateRange,
    required this.bookingDate,
  });
}

class AppState extends ChangeNotifier {
  // Private constructor for singleton pattern
  AppState._() {
    _places = List.from(initialMockPlaces);
  }

  static final AppState instance = AppState._();

  late List<PlaceModel> _places;
  final List<TripModel> _bookedTrips = [];
  int _currentTabIndex = 0;

  // Getters
  List<PlaceModel> get places => _places;
  List<TripModel> get bookedTrips => _bookedTrips;
  int get currentTabIndex => _currentTabIndex;

  List<PlaceModel> get favoritePlaces =>
      _places.where((place) => place.isFavorited).toList();

  // Actions
  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    final index = _places.indexWhere((place) => place.id == id);
    if (index != -1) {
      _places[index] = _places[index].copyWith(
        isFavorited: !_places[index].isFavorited,
      );
      notifyListeners();
    }
  }

  void bookPlace(PlaceModel place, String dateRange) {
    // Add to bookings
    _bookedTrips.add(
      TripModel(
        place: place,
        dateRange: dateRange,
        bookingDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

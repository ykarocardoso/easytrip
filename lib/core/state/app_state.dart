import 'package:flutter/material.dart';
import '../data/place_model.dart';
import '../mock/mock_data.dart';
import '../database/database_helper.dart';

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

  // User Profile State
  String _userName = 'Usuário EasyTrip';
  String _userEmail = 'usuario@easytrip.com';
  String _userAvatarUrl = 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=300';
  String? _userAvatarFilePath;

  // Getters
  List<PlaceModel> get places => _places;
  List<TripModel> get bookedTrips => _bookedTrips;
  int get currentTabIndex => _currentTabIndex;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userAvatarUrl => _userAvatarUrl;
  String? get userAvatarFilePath => _userAvatarFilePath;

  Future<void> initialize() async {
    // Load profile
    final profile = await DatabaseHelper.instance.getUserProfile();
    if (profile != null) {
      _userName = profile['name'] as String? ?? _userName;
      _userEmail = profile['email'] as String? ?? _userEmail;
      _userAvatarUrl = profile['avatar_url'] as String? ?? _userAvatarUrl;
      _userAvatarFilePath = profile['avatar_file_path'] as String?;
    }

    // Load favorites
    final favIds = await DatabaseHelper.instance.getFavoriteIds();
    _places = _places.map((place) {
      if (favIds.contains(place.id)) {
        return place.copyWith(isFavorited: true);
      }
      return place.copyWith(isFavorited: false);
    }).toList();

    notifyListeners();
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? avatarUrl,
    String? avatarFilePath,
  }) async {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (avatarUrl != null) {
      _userAvatarUrl = avatarUrl;
      _userAvatarFilePath = null;
    }
    if (avatarFilePath != null) {
      _userAvatarFilePath = avatarFilePath;
    }
    notifyListeners();

    await DatabaseHelper.instance.saveUserProfile(
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      avatarFilePath: avatarFilePath,
      clearFilePath: avatarUrl != null,
    );
  }

  List<PlaceModel> get favoritePlaces =>
      _places.where((place) => place.isFavorited).toList();

  // Actions
  void setTabIndex(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final index = _places.indexWhere((place) => place.id == id);
    if (index != -1) {
      final isNewFav = !_places[index].isFavorited;
      _places[index] = _places[index].copyWith(
        isFavorited: isNewFav,
      );
      notifyListeners();

      await DatabaseHelper.instance.setFavorite(id, isFavorited: isNewFav);
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

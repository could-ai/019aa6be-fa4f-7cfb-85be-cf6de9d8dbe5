import '../models/password_item.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  
  factory MockDataService() {
    return _instance;
  }
  
  MockDataService._internal() {
    // Initialize with some dummy data
    _items.addAll([
      PasswordItem(
        id: '1',
        title: 'Google',
        accountName: 'user@gmail.com',
        password: 'password123',
        website: 'https://google.com',
        updatedAt: DateTime.now(),
      ),
      PasswordItem(
        id: '2',
        title: 'GitHub',
        accountName: 'dev_user',
        password: 'secure_password_456',
        website: 'https://github.com',
        notes: 'My personal dev account',
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      PasswordItem(
        id: '3',
        title: 'Netflix',
        accountName: 'movie_fan',
        password: 'watch_movies_789',
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ]);
  }

  final List<PasswordItem> _items = [];

  List<PasswordItem> get items => List.unmodifiable(_items);

  void addItem(PasswordItem item) {
    _items.add(item);
  }

  void updateItem(PasswordItem item) {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((element) => element.id == id);
  }
}

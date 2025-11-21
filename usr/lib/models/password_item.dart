class PasswordItem {
  String id;
  String title;
  String accountName;
  String password;
  String? website;
  String? notes;
  DateTime updatedAt;

  PasswordItem({
    required this.id,
    required this.title,
    required this.accountName,
    required this.password,
    this.website,
    this.notes,
    required this.updatedAt,
  });
}

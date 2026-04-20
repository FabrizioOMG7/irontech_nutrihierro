enum AppAlertType {
  ironIntakeReminder,
  nutritionTip,
}

class AppAlert {
  final String id;
  final AppAlertType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const AppAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  AppAlert copyWith({
    String? id,
    AppAlertType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppAlert(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

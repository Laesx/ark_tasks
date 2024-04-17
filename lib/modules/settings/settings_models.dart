/// Some fields are modifiable to allow for quick and simple edits.
/// But to apply those edits, the [SettingsNotifier] should be used.
class Settings {
  Settings._({
    required this.unreadNotifications,
  });

  factory Settings(Map<String, dynamic> map) => Settings._(
        unreadNotifications: map['unreadNotificationCount'] ?? 0,
      );

  factory Settings.empty() => Settings._(unreadNotifications: 0);

  final int unreadNotifications;
  //final Map<NotificationType, bool> notificationOptions;

  Settings copy({int unreadNotifications = 0}) => Settings._(
        unreadNotifications: unreadNotifications,
      );

  Map<String, dynamic> toMap() => {};
}

import 'package:ark_jots/modules/auth/account.dart';
import 'package:ark_jots/modules/home/home_provider.dart';
import 'package:ark_jots/utils/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Current app version.
const versionCode = '1.0.1';

/// General options keys.
enum _OptionKey {
  themeMode,
  themeIndex,
  pureWhiteOrBlackTheme,
  defaultHomeTab,
  confirmExit,
  analogueClock,
  lastNotificationId,
  lastVersionCode,
  lastBackgroundWork,
}

/// User state keys.
enum _ProfileKey {
  selectedAccount,
  accounts,
}

/// Hive box keys.
const _optionsBoxKey = 'options';
const _profileBoxKey = 'profiles';

/// Local settings.
/// [notifyListeners] is called when the theme configuration changes.
class Options extends ChangeNotifier {
  Options._(
    this._selectedAccount,
    this._accounts,
    this._themeMode,
    this._theme,
    this._pureWhiteOrBlackTheme,
    this._defaultHomeTab,
    this._confirmExit,
    this._analogueClock,
    this._lastNotificationId,
    this._lastBackgroundWork,
    this._lastVersionCode,
  );

  factory Options._read() {
    // TODO: The accounts logic has to be changed
    final accounts =
        (_profileBox.get(_ProfileKey.accounts.name) as List<dynamic>? ?? [])
            .cast<Map<dynamic, dynamic>>()
            .map((a) => Account.fromMap(a.cast<String, dynamic>()))
            .toList();

    final selectedAccount = _profileBox.get(_ProfileKey.selectedAccount.name);

    int themeMode = _optionBox.get(_OptionKey.themeMode.name) ?? 0;
    if (themeMode < 0 || themeMode >= ThemeMode.values.length) themeMode = 0;

    int homeTab = _optionBox.get(_OptionKey.defaultHomeTab.name) ?? 0;
    if (homeTab < 0 || homeTab >= HomeTab.values.length) homeTab = 0;

    return Options._(
      selectedAccount,
      accounts,
      ThemeMode.values[themeMode],
      _optionBox.get(_OptionKey.themeIndex.name),
      _optionBox.get(_OptionKey.pureWhiteOrBlackTheme.name) ?? false,
      HomeTab.values[homeTab],
      _optionBox.get(_OptionKey.confirmExit.name) ?? false,
      _optionBox.get(_OptionKey.analogueClock.name) ?? false,
      _optionBox.get(_OptionKey.lastNotificationId.name) ?? -1,
      _optionBox.get(_OptionKey.lastBackgroundWork.name),
      _optionBox.get(_OptionKey.lastVersionCode.name) ?? '',
    );
  }

  factory Options() => _instance;

  static late Options _instance;

  static bool _didInit = false;

  /// Should be called before use.
  static Future<void> init() async {
    if (_didInit) return;
    _didInit = true;

    WidgetsFlutterBinding.ensureInitialized();

    /// Configure home directory if not in the browser.
    if (!kIsWeb) Hive.init((await getApplicationDocumentsDirectory()).path);

    /// Initialise boxes and instance.
    await Hive.openBox(_optionsBoxKey);
    await Hive.openBox(_profileBoxKey);
    _instance = Options._read();
  }

  /// Clears option data and resets instance.
  /// Doesn't affect local profile settings or online account settings.
  static void resetOptions() {
    Hive.box(_optionsBoxKey).clear();
    _instance = Options._read();
  }

  static Box get _optionBox => Hive.box(_optionsBoxKey);
  static Box get _profileBox => Hive.box(_profileBoxKey);

  int? _selectedAccount;
  List<Account> _accounts;
  ThemeMode _themeMode;
  int? _theme;
  bool _pureWhiteOrBlackTheme;
  HomeTab _defaultHomeTab;
  bool _confirmExit;
  bool _analogueClock;
  int _lastNotificationId;
  DateTime? _lastBackgroundWork;
  String _lastVersionCode;

  int? get selectedAccount => _selectedAccount;
  List<Account> get accounts => _accounts;
  ThemeMode get themeMode => _themeMode;
  int? get theme => _theme;
  bool get pureWhiteOrBlackTheme => _pureWhiteOrBlackTheme;
  HomeTab get defaultHomeTab => _defaultHomeTab;
  bool get confirmExit => _confirmExit;
  bool get analogueClock => _analogueClock;
  int get lastNotificationId => _lastNotificationId;
  DateTime? get lastBackgroundWork => _lastBackgroundWork;
  String get lastVersionCode => _lastVersionCode;

  int? get id {
    if (_selectedAccount == null) return null;
    return _accounts[_selectedAccount!].id;
  }

  set selectedAccount(int? v) {
    if (v == null) {
      if (selectedAccount == null) return;
      _selectedAccount = null;
      _profileBox.delete(_ProfileKey.selectedAccount.name);
      _instance.lastNotificationId = -1;
    } else if (v != _selectedAccount && v > -1 && v < _accounts.length) {
      _selectedAccount = v;
      _profileBox.put(_ProfileKey.selectedAccount.name, v);
    }
  }

  set accounts(List<Account> v) {
    _accounts = v;
    final accountMaps = accounts.map((a) => a.toMap()).toList();
    _profileBox.put(_ProfileKey.accounts.name, accountMaps);
  }

  set themeMode(ThemeMode v) {
    if (v == _themeMode) return;
    _themeMode = v;
    _optionBox.put(_OptionKey.themeMode.name, v.index);
    notifyListeners();
  }

  set theme(int? v) {
    if (v == _theme) return;

    if (v == null) {
      _theme = null;
      _optionBox.delete(_OptionKey.themeIndex.name);
      notifyListeners();
      return;
    }

    if (v < 0 || v >= colorSeeds.length) return;
    _theme = v;
    _optionBox.put(_OptionKey.themeIndex.name, v);
    notifyListeners();
  }

  set pureWhiteOrBlackTheme(bool v) {
    if (_pureWhiteOrBlackTheme == v) return;
    _pureWhiteOrBlackTheme = v;
    _optionBox.put(_OptionKey.pureWhiteOrBlackTheme.name, v);
    notifyListeners();
  }

  set defaultHomeTab(HomeTab v) {
    _defaultHomeTab = v;
    _optionBox.put(_OptionKey.defaultHomeTab.name, v.index);
  }

  set confirmExit(bool v) {
    _confirmExit = v;
    _optionBox.put(_OptionKey.confirmExit.name, v);
  }

  set analogueClock(bool v) {
    _analogueClock = v;
    _optionBox.put(_OptionKey.analogueClock.name, v);
  }

  set lastNotificationId(int v) {
    _lastNotificationId = v;
    _optionBox.put(_OptionKey.lastNotificationId.name, v);
  }

  set lastBackgroundWork(DateTime? v) {
    _lastBackgroundWork = v;
    _optionBox.put(_OptionKey.lastBackgroundWork.name, v);
  }

  void updateVersionCodeToLatestVersion() {
    _lastVersionCode = versionCode;
    _optionBox.put(_OptionKey.lastVersionCode.name, versionCode);
  }

  /// If the [name] or [avatarUrl] have changed, update the cached account info.
  void confirmAccountNameAndAvatar(int id, String name, String avatarUrl) {
    for (int i = 0; i < _accounts.length; i++) {
      final account = _accounts[i];
      if (account.id == id) {
        if (account.name != name) {
          _accounts[i] = Account(
            id: id,
            name: name,
          );
        }
        return;
      }
    }
  }
}

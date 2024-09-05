import 'package:flutter/material.dart';
import 'package:solo_safe_wallet/screens/online_transactions/receive/receive_online.dart';
import 'package:solo_safe_wallet/screens/online_transactions/send/send_online.dart';
import 'package:solo_safe_wallet/screens/settings/settings_page.dart';
import '../screens/auth/auth.dart';

class AppRoutes{
  static const String startAuth = '/start_auth';
  static const String createWallet = '/create_wallet';
  static const String restoreWallet = '/restore_wallet';
  static const String settings = '/settings';
  static const String receive_online = '/receive_online';
  static const String send_online = '/send_online';

  static Map<String, WidgetBuilder> routes = {
    startAuth: (context) => StartAuthPage(),
    createWallet: (context) => CreateWalletPage(),
    restoreWallet: (context) => RestoreWalletPage(),
    settings: (context) => SettingsPage(),
    receive_online: (context) => ReceiveCryptoPage(),
    send_online: (context) => SendOnlinePage(),
  };
}
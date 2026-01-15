import 'package:flutter_dotenv/flutter_dotenv.dart';

class AdConstants {
  static String get admobApplicationId =>
      dotenv.env['ADMOB_APPLICATION_ID'] ??
      'ca-app-pub-3940256099942544~3347511713';

  static String get bannerAdUnitId =>
      dotenv.env['ADMOB_BANNER_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/6300978111';

  static String get interstitialAdUnitId =>
      dotenv.env['ADMOB_INTERSTITIAL_AD_UNIT_ID'] ??
      'ca-app-pub-3940256099942544/1033173712';
}

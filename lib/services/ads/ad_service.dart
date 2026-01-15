import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class AdService {
  static AdService? _instance;
  static AdService get instance {
    _instance ??= AdService._();
    return _instance!;
  }

  AdService._();

  final Logger _logger = Logger();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      _logger.i('AdMob initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize AdMob: $e');
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized;

  BannerAd? createBannerAd({
    required String adUnitId,
    AdSize? adSize,
    BannerAdListener? listener,
  }) {
    if (!_isInitialized) {
      _logger.w('AdMob not initialized, cannot create banner ad');
      return null;
    }

    try {
      final bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: adSize ?? AdSize.banner,
        request: const AdRequest(),
        listener:
            listener ??
            BannerAdListener(
              onAdLoaded: (_) {
                _logger.d('Banner ad loaded: $adUnitId');
              },
              onAdFailedToLoad: (ad, error) {
                _logger.e('Banner ad failed to load: $adUnitId, error: $error');
                ad.dispose();
              },
              onAdOpened: (_) {
                _logger.d('Banner ad opened: $adUnitId');
              },
              onAdClosed: (_) {
                _logger.d('Banner ad closed: $adUnitId');
              },
            ),
      );

      bannerAd.load();
      return bannerAd;
    } catch (e) {
      _logger.e('Failed to create banner ad: $e');
      return null;
    }
  }

  void createInterstitialAd({
    required String adUnitId,
    InterstitialAdLoadCallback? onAdLoaded,
    FullScreenContentCallback<InterstitialAd>? fullScreenContentCallback,
  }) {
    if (!_isInitialized) {
      _logger.w('AdMob not initialized, cannot create interstitial ad');
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback:
          onAdLoaded ??
          InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _logger.d('Interstitial ad loaded: $adUnitId');
              ad.fullScreenContentCallback =
                  fullScreenContentCallback ??
                  FullScreenContentCallback<InterstitialAd>(
                    onAdDismissedFullScreenContent: (ad) {
                      _logger.d('Interstitial ad dismissed: $adUnitId');
                      ad.dispose();
                    },
                    onAdFailedToShowFullScreenContent: (ad, error) {
                      _logger.e(
                        'Interstitial ad failed to show: $adUnitId, error: $error',
                      );
                      ad.dispose();
                    },
                    onAdShowedFullScreenContent: (ad) {
                      _logger.d('Interstitial ad showed: $adUnitId');
                    },
                  );
            },
            onAdFailedToLoad: (error) {
              _logger.e(
                'Interstitial ad failed to load: $adUnitId, error: $error',
              );
            },
          ),
    );
  }
}

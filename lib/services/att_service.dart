import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:logger/logger.dart';

enum ATTStatus { notDetermined, restricted, denied, authorized, notSupported }

class ATTService {
  static ATTService? _instance;
  static ATTService get instance {
    _instance ??= ATTService._();
    return _instance!;
  }

  ATTService._();

  final Logger _logger = Logger();
  ATTStatus? _currentStatus;

  Future<ATTStatus> requestTrackingAuthorization() async {
    if (!Platform.isIOS) {
      _logger.d('ATT is only supported on iOS, skipping request');
      _currentStatus = ATTStatus.notSupported;
      return ATTStatus.notSupported;
    }

    try {
      final trackingStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      _currentStatus = _mapTrackingStatus(trackingStatus);
      _logger.i('ATT authorization status: $_currentStatus');
      return _currentStatus!;
    } catch (e) {
      _logger.e('Failed to request ATT authorization: $e');
      _currentStatus = ATTStatus.notDetermined;
      return ATTStatus.notDetermined;
    }
  }

  Future<ATTStatus> getTrackingStatus() async {
    if (!Platform.isIOS) {
      _logger.d('ATT is only supported on iOS');
      _currentStatus = ATTStatus.notSupported;
      return ATTStatus.notSupported;
    }

    if (_currentStatus != null) {
      return _currentStatus!;
    }

    try {
      final trackingStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      _currentStatus = _mapTrackingStatus(trackingStatus);
      return _currentStatus!;
    } catch (e) {
      _logger.e('Failed to get ATT status: $e');
      return ATTStatus.notDetermined;
    }
  }

  ATTStatus _mapTrackingStatus(TrackingStatus status) {
    switch (status) {
      case TrackingStatus.notDetermined:
        return ATTStatus.notDetermined;
      case TrackingStatus.restricted:
        return ATTStatus.restricted;
      case TrackingStatus.denied:
        return ATTStatus.denied;
      case TrackingStatus.authorized:
        return ATTStatus.authorized;
      case TrackingStatus.notSupported:
        return ATTStatus.notSupported;
    }
  }

  ATTStatus? get currentStatus => _currentStatus;

  bool get isAuthorized => _currentStatus == ATTStatus.authorized;
}

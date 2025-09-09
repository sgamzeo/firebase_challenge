import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService() : _remoteConfig = FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  Future<void> initialize() async {
    await _remoteConfig.setDefaults(const {
      'contest_name': 'Eurovision Song Contest',
      'contest_year': 2024,
      'contest_image_url': '',
      'isHidden': true,
    });

    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Error fetching remote config: $e');
    }
  }

  String get contestName => _remoteConfig.getString('contest_name');
  int get contestYear => _remoteConfig.getInt('contest_year');
  String get contestImageUrl => _remoteConfig.getString('contest_image_url');
  bool get isHidden => _remoteConfig.getBool('isHidden');
}

import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:seeds/datasource/remote/model/firebase_eos_servers.dart';

const String _activeEOSEndpointKey = 'eos_enpoints';
const String _hyphaEndPointKey = 'hypha_end_point';
const String _defaultEndPointUrlKey = 'default_end_point';
const String _defaultV2EndPointUrlKey = 'default_v2_end_point';
const String _featureFlagImportAccount = 'feature_flag_import_account';
const String _featureFlagExportRecoveryPhrase = 'feature_flag_export_recovery_phrase';
const String _featureFlagDelegate = 'feature_flag_delegate';
const String _featureFlagClaimUnplantedSeeds = 'feature_flag_unplant_claim_seeds';

// MAINNET CONFIG
const String _eosEndpoints = '[ { "url": "https://api.telosfoundation.io", "isDefault": true } ]';
const String _hyphaEndPointUrl = 'https://node.hypha.earth';
const String _defaultEndPointUrl = "https://api.telosfoundation.io";
// we need a separate endpoint for v2/history as most nodes don't support v2
const String _defaultV2EndpointUrl = "https://api.telosfoundation.io";

// DO NOT PUSH TO PROD WITH THIS SET TO TRUE. This is used for testing purposes only
const bool testnetMode = false;

// TESTNET CONFIG: Used for testing purposes.
const String _testnetEosEndpoints = '[ { "url": "https://test.hypha.earth", "isDefault": true } ]';
const String _testnetHyphaEndPointUrl = 'https://test.hypha.earth';
const String _testnetDefaultEndPointUrl = "https://test.hypha.earth";
const String _testnetDefaultV2EndpointUrl = "https://api-test.telosfoundation.io";
// END - TESTNET CONFIG

class _FirebaseRemoteConfigService {
  late RemoteConfig _remoteConfig;

  factory _FirebaseRemoteConfigService() => _instance;

  _FirebaseRemoteConfigService._();

  static final _FirebaseRemoteConfigService _instance = _FirebaseRemoteConfigService._();

  final defaults = <String, dynamic>{
    _featureFlagImportAccount: false,
    _featureFlagExportRecoveryPhrase: false,
    _featureFlagDelegate: false,
    _featureFlagClaimUnplantedSeeds: false,
    _activeEOSEndpointKey: _eosEndpoints,
    _hyphaEndPointKey: _hyphaEndPointUrl,
    _defaultEndPointUrlKey: _defaultEndPointUrl,
    _defaultV2EndPointUrlKey: _defaultV2EndpointUrl
  };

  void refresh() {
    _remoteConfig.fetch().then((value) {
      print(" _remoteConfig fetch worked");
      _remoteConfig.activate().then((bool value) {
        print(" _remoteConfig activate worked params were activated $value");
      }).onError((error, stackTrace) {
        print(" _remoteConfig activate failed");
      });
    }).onError((error, stackTrace) {
      print(" _remoteConfig fetch failed");
    });
  }

  Future initialise() async {
    _remoteConfig = RemoteConfig.instance;
    await _remoteConfig.setDefaults(defaults);

    /// Maximum age of a cached config before it is considered stale. we set to 60 secs since we store important data.
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      minimumFetchInterval: const Duration(seconds: 60),
      fetchTimeout: const Duration(seconds: 60),
    ));

    refresh();
  }

  bool get featureFlagImportAccountEnabled => _remoteConfig.getBool(_featureFlagImportAccount);
  bool get featureFlagExportRecoveryPhraseEnabled => _remoteConfig.getBool(_featureFlagExportRecoveryPhrase);
  bool get featureFlagDelegateEnabled => _remoteConfig.getBool(_featureFlagDelegate);
  bool get featureFlagClaimUnplantedSeedsEnabled => _remoteConfig.getBool(_featureFlagClaimUnplantedSeeds);

  String get hyphaEndPoint => testnetMode ? _testnetHyphaEndPointUrl : _remoteConfig.getString(_hyphaEndPointKey);

  String get defaultEndPointUrl =>
      testnetMode ? _testnetDefaultEndPointUrl : _remoteConfig.getString(_defaultEndPointUrlKey);

  String get defaultV2EndPointUrl =>
      testnetMode ? _testnetDefaultV2EndpointUrl : _remoteConfig.getString(_defaultV2EndPointUrlKey);

  FirebaseEosServer get activeEOSServerUrl =>
      parseEosServers(testnetMode ? _testnetEosEndpoints : _remoteConfig.getString(_activeEOSEndpointKey)).firstWhere(
          (FirebaseEosServer element) => element.isDefault!,
          orElse: () => parseEosServers(_remoteConfig.getString(_eosEndpoints)).first);
}

// A function that converts a response body into a List<FirebaseEosServer>.
List<FirebaseEosServer> parseEosServers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FirebaseEosServer>((json) => FirebaseEosServer.fromJson(json)).toList();
}

/// Singleton
_FirebaseRemoteConfigService remoteConfigurations = _FirebaseRemoteConfigService();

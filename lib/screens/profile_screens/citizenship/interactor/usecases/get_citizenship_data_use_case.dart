import 'package:async/async.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/api/planted_repository.dart';
import 'package:seeds/datasource/remote/api/profile_repository.dart';
import 'package:seeds/datasource/remote/api/seeds_history_repository.dart';

class GetCitizenshipDataUseCase {
  final PlantedRepository _plantedRepository = PlantedRepository();
  final SeedsHistoryRepository _seedsHistoryRepository = SeedsHistoryRepository();
  final ProfileRepository _profileRepository = ProfileRepository();

  Future<List<Result>> run() {
    final account = settingsStorage.accountName;
    final futures = [
      _plantedRepository.getPlanted(account),
      _seedsHistoryRepository.getNumberOfTransactions(account),
      _profileRepository.getScore(account: account, contractName: "accts.seeds", tableName: "cbs"),
    ];
    return Future.wait(futures);
  }
}

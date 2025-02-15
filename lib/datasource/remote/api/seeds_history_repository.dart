import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/datasource/remote/api/network_repository.dart';
import 'package:seeds/datasource/remote/model/seeds_history_model.dart';
import 'package:seeds/domain-shared/app_constants.dart';

///Seeds History Table
class SeedsHistoryRepository extends NetworkRepository {
  Future<Result<SeedsHistoryModel>> getNumberOfTransactions(String userAccount) {
    print('[http] get seeds seeds history for account: $userAccount ');

    final String request = createRequest(
      code: historySeeds,
      scope: historySeeds,
      table: tableTotals,
      lowerBound: userAccount,
      upperBound: userAccount,
    );

    final seedsHistoryURL = Uri.parse('$hyphaURL/v1/chain/get_table_rows');

    return http
        .post(seedsHistoryURL, headers: headers, body: request)
        .then((http.Response response) => mapHttpResponse<SeedsHistoryModel>(response, (dynamic body) {
              return SeedsHistoryModel.fromJson(body);
            }))
        .catchError((dynamic error) => mapHttpError(error));
  }
}

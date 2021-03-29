import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:seeds/constants/config.dart';
import 'package:seeds/v2/datasource/remote/api/network_repository.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';

export 'package:async/src/result/result.dart';

class RatesRepository extends NetworkRepository {
  Future<Result> getFiatRates() {
    print("[http] get fiat rates");

    return http
        .get("https://api.exchangeratesapi.io/latest?base=USD")
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return FiatRateModel.fromJson(body);
            }))
        .catchError((error) => mapHttpError(error));
  }

  Future<Result> getFiatRatesAlternate() {
    print("[http] get fiat rates from fixer");

    return http
        .get("http://data.fixer.io/api/latest?access_key=${Config.fixerApiKey}&symbols=CRC,GTQ,USD")
        .then((http.Response response) => mapHttpResponse(response, (dynamic body) {
              return FiatRateModel.fromJsonFixer(body);
            }))
        .catchError((error) => mapHttpError(error));
  }


  // See rate_notifier - all 3 calls in 1 future

  //   Future<FiatRateModel> getFiatRatesAlternate() async {
  //   print("[http] get alternate fiat rates");

  //   Response res = await get("http://data.fixer.io/api/latest?access_key=${Config.fixerApiKey}&symbols=CRC,GTQ,USD");

  //   if (res.statusCode == 200) {
  //     Map<String, dynamic> body = res.parseJson();
  //     return FiatRateModel.fromJsonFixer(body);
  //   } else {
  //     print("Cannot fetch alternate rates..." + res.body.toString());
  //     return FiatRateModel(null, base: null, error: true);
  //   }
  // }

}

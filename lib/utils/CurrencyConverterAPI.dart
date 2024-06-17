import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'MYR', 'AUD', 'CAD', 'CNY', 'EUR', 'GBP', 'HKD', 'JPY', 'NZD', 'SGD', 'USD'
];

const apiKey = 'fca_live_k2LnKbPdWKx3Zhrbjm8y804IGqe2sQwNG8lkQirf';
const coinAPIURL = "https://api.freecurrencyapi.com/v1/latest";

class CoinData {
  String? baseCurrency;
  String? finalCurrency;

  CoinData({this.baseCurrency, this.finalCurrency});

  Future<double> getCoinData() async {
    if (baseCurrency == null || finalCurrency == null) {
      throw 'Base currency and final currency must be provided';
    }
    final url = Uri.parse('$coinAPIURL?apikey=$apiKey&base_currency=$baseCurrency');
    print('Requesting URL: $url'); // Debug print

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body)['data'][finalCurrency];
        print('Response Data: ${jsonDecode(response.body)['data']}'); // Debug print

        if (decodedData == null) {
          throw 'Final currency not found in the response';
        }

        return decodedData as double;
      } else {
        print('Request failed with status: ${response.statusCode}');
        throw 'Problem with get request';
      }
    } catch (error) {
      print('Error during HTTP request: $error');
      throw 'Problem with get request';
    }
  }
}


//final url = Uri.parse('$coinAPIURL?apikey=$apiKey&base_currency=$baseCurrency');
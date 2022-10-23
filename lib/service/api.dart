import 'dart:convert';

import 'package:http/http.dart' as http;

const String host = "https://data.tmd.go.th";
const API_KEY = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQ0MWIyZGVkNjhkMzk2YjU1YWYxYWExZGYzNTRlYmRiYTdlYTFiODAxZTVhMjAwNjEwODkxODNmNGJlNTIyZTFlYzYxNmJmMzZjNDc5ODlkIn0.eyJhdWQiOiIyIiwianRpIjoiZDQxYjJkZWQ2OGQzOTZiNTVhZjFhYTFkZjM1NGViZGJhN2VhMWI4MDFlNWEyMDA2MTA4OTE4M2Y0YmU1MjJlMWVjNjE2YmYzNmM0Nzk4OWQiLCJpYXQiOjE2NjY0OTI0MDIsIm5iZiI6MTY2NjQ5MjQwMiwiZXhwIjoxNjk4MDI4NDAyLCJzdWIiOiIyMjMyIiwic2NvcGVzIjpbXX0.DAYZHFPbpspY-f48h986WZQ1lywwPDVo0W-gyT04SjfmffsMeTCoB8Yg3CRACJYqjC_I1pLYB4rHyUAY7PxvSVm1LkH12dxaj5gsoxDnDkSlNPlaYx-OQOgz8MX9HB7SKMkxcPGf1azvPIHw2wRy2TejT5sqyg1WY9PDeVgMzNVqUPtiWfy-Fkl9-A690TcE5ikjyfGigI_l_kj5HECzSuez090b-8nXJ9d-VpoY3vGmtec-aYbim_wd5KR5WTU-B_YEMdHQmS0yLpXsoIkdnjDBxOhaPPzP-JmvEJukt6bnbFE4JaAEGTApjnaCh_n-MH3D9CQwY9Gt93EUthKAlPINr6oD2B8jhmtJ3UbjCPEXpowsmr8N-yq-eGTeg80xAe2BdxE_dXhoNSahwJZijk4l9kjFXTFAz98vHhO2lwXHXuFZ872vaMcqZk4vSnukKxXLS1nBQl-RlEdzU42cPHxetONSOuO1YzE4GxO_j6cpWAE8XVM02PA-L2Ll2JUCvJpfXSs0XCeDcvW5mLOC6qKAkZxF8heHfuh7-pURm7ksFwBZecbnqSxA51WlZCsay8zyzAhsCG78tuD_ppbINU7BNqqeZRmFkProWyJ_6oKgmF9i2LT7r8ijwqKqtHn1CYDr5e3Bpy75RY8FGwbE6i-G6eJuK2C3iPkg-WgWfpU';

const String progressWaitMessage = "กรุณารอสักครู่...";
const String errorInternetConnection = "ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้ กรุณาลองอีกครั้ง";
const String errorDataNotFound = "ไม่พบข้อมูล";
const String errorSomethingWentWrong = "เกิดข้อผิดพลาดในการทำงาน กรุณาลองใหม่อีกครั้ง";

class DefaultReturn<Class> {
  final int status;
  final String message;
  final Class? data;

  DefaultReturn({required this.status, required this.message, this.data});
  factory DefaultReturn.fromJson(Map<String, dynamic> json, Function(dynamic) callback) {
    Class? temp;
    String? error;
    try{
      temp = callback(json['data']);
    } catch(e) {
      temp = null;
      error = json['status']==200?e.toString():null;
    }
    return DefaultReturn(
        status: json['status'],
        message: error??json['message'],
        data: temp
    );
  }
}

Future<DefaultReturn<Class>> defaultApiGetNoLoad<Class>(Map<String, String> data, String url,
    Function(dynamic) jsonConvert, Future<bool> Function(DefaultReturn<Class>) onSuccess) async {
  http.Response response;
  DefaultReturn<Class> responseData;
  try {
    String query = '';
    for(String key in data.keys){
      query = '$query&$key=${data[key]}';
    }
    query = query.isNotEmpty?'?${query.substring(1)}':'';
    response = await http
        .get(Uri.parse(host + url + query),
        headers: {"accept": "application/json",
          "authorization": API_KEY
        }
    );
    responseData = DefaultReturn<Class>.fromJson(json.decode(response.body), jsonConvert);
  } catch (e) {
    throw errorInternetConnection;
  }
  if (responseData.status == 200) {
    if(await onSuccess(responseData)){
      return responseData;
    }
    throw errorSomethingWentWrong;
  }
  throw responseData.message;
}

/*=================Start=GetForecastDataList====================*/
class ForecastList {
  final List<ForecastData> forecasts;

  ForecastList({required this.forecasts});

  factory ForecastList.fromJson(Map<String, dynamic> json) {
    List<ForecastData> temp = [];
    try{
      temp = (json['forecasts'] as List).map((i) => ForecastData.fromJson(i)).toList();
    } catch(e){}
    return ForecastList(
        forecasts: temp
    );
  }
}

class ForecastData {
  final ForecastDetail? data;

  ForecastData({this.data});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    ForecastDetail? temp;
    try{
      temp = ForecastDetail.fromJson(json["data"]);
    } catch(e){}
    return ForecastData(
        data: temp
    );
  }
}

class ForecastDetail {
  final int cond;
  final double rh;
  final double tc_max;
  final double tc_min;
  final double wd10m;
  final double ws10m;

  ForecastDetail({
    required this.cond,
    required this.rh,
    required this.tc_max,
    required this.tc_min,
    required this.wd10m,
    required this.ws10m
  });

  factory ForecastDetail.fromJson(Map<String, dynamic> json) {
    return ForecastDetail(
        cond: json["cond"],
        rh: json["rh"],
        tc_max: json["tc_max"],
        tc_min: json["tc_min"],
        wd10m: json["wd10m"],
        ws10m: json["ws10m"]
    );
  }
}

Future<DefaultReturn<List<ForecastList>>> getForecastDataList(Map<String, String> requestData) async {
  return defaultApiGetNoLoad<List<ForecastList>>(requestData, "/nwpapi/v1/forecast/location/daily/at", (data) => (data['WeatherForecasts'] as List).map((i) => ForecastList.fromJson(i)).toList(), (returnData) async {
    if(returnData.data==null||returnData.data!.isEmpty){
      return false;
    }
    return true;
  });
}
/*=================End=GetForecastDataList====================*/
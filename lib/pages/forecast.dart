import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../service/api.dart';
import 'package:intl/intl.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  bool isLoading = false;
  String errorMessage = '';
  List<ForecastData> forecasts = [];
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    loadData();
  }

  AssetImage getWeatherImage(String con){
    switch(con){
      case "1":
        return const AssetImage("assets/01_clear.jpg");
      case "2":
        return const AssetImage("assets/02_partly_cloudy.jpg");
      case "3":
        return const AssetImage("assets/03_cloudy.jpg");
      case "4":
        return const AssetImage("assets/04_overcast.jpg");
      case "5":
        return const AssetImage("assets/05_light_rain.jpg");
      case "6":
        return const AssetImage("assets/06_moderate_rain.jpg");
      case "7":
        return const AssetImage("assets/07_heavy_rain.jpg");
      case "8":
        return const AssetImage("assets/08_thunderstorm.jpg");
      case "9":
        return const AssetImage("assets/09_very_cold.jpg");
      case "10":
        return const AssetImage("assets/10_cold.jpg");
      case "11":
        return const AssetImage("assets/11_cool.jpg");
      default:
        return const AssetImage("assets/12_very_hot.jpg");
    }
  }

  Future<void> loadData() async {
    if(isLoading){
      return;
    }
    setState((){
      isLoading = true;
    });
    try{
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          setState(() {
            errorMessage = "ไม่สามารถเข้าถึงข้อมูลตำแหน่งปัจจุบันได้";
            isLoading = false;
          });
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<ForecastData> data = (await getForecastDataList({
        "lat": position.latitude.toString(),
        "lon": position.longitude.toString(),
        "fields": "tc_max,tc_min,rh,ws10m,wd10m,cond",
        "date": dateFormat.format(DateTime.now()),
        "duration": "20"
      }))[0].forecasts;
      if(data.isNotEmpty){
        setState(() {
          forecasts = data;
          errorMessage = '';
          isLoading = false;
        });
        return;
      }
      setState(() {
        errorMessage = errorDataNotFound;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
              onRefresh: () => loadData(),
              child: forecasts.isNotEmpty?ListView.builder(
                  itemCount: forecasts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      child: Image(
                        image: getWeatherImage(forecasts[index].data?.cond??''),
                        fit: BoxFit.fill,
                      ),
                    );
                  }):
              isLoading?const Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(color: Colors.blue)
                ),
              ):
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(errorMessage, textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      MaterialButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: const Text('Refresh'),
                          onPressed: (){
                            loadData();
                          })
                    ],
                  ),
                ),
              )
          ),
        )
    );
  }
}
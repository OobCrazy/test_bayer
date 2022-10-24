import 'package:bordered_text/bordered_text.dart';
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
  DateFormat showFormat = DateFormat('dd MMM yyyy');

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
  String getWeatherText(String con){
    switch(con){
      case "1":
        return "ท้องฟ้าแจ่มใส";
      case "2":
        return "มีเมฆบางส่วน";
      case "3":
        return "เมฆเป็นส่วนมาก";
      case "4":
        return "มีเมฆมาก";
      case "5":
        return "ฝนตกเล็กน้อย";
      case "6":
        return "ฝนปานกลาง";
      case "7":
        return "ฝนตกหนัก";
      case "8":
        return "ฝนฟ้าคะนอง";
      case "9":
        return "อากาศหนาวจัด";
      case "10":
        return "อากาศหนาว";
      case "11":
        return "อากาศเย็น";
      default:
        return "อากาศร้อนจัด";
    }
  }
  String getWeatherTime(String time){
    try{
      DateTime dt = DateTime.parse(time);
      return showFormat.format(dt);
    } catch(e) {
      return '';
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
        "duration": "7"
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
                      child: Stack(
                        children: [
                          Image(
                            image: getWeatherImage(forecasts[index].data?.cond??''),
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      BorderedText(
                                        strokeWidth: 3.0,
                                        strokeColor: Colors.black,
                                        child: Text(
                                          getWeatherText(forecasts[index].data?.cond??''),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 30, color: Colors.white)
                                        )
                                      ),
                                      BorderedText(
                                          strokeWidth: 3.0,
                                          strokeColor: Colors.white,
                                          child: Text(
                                              getWeatherTime(forecasts[index].time),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 25, color: Colors.black)
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                        BorderedText(
                                            strokeWidth: 3.0,
                                            strokeColor: Colors.white,
                                            child: const Text(
                                                "อุณหภูมิ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 20, color: Colors.black)
                                            )
                                        ),
                                        const SizedBox(height: 10),
                                        BorderedText(
                                            strokeWidth: 3.0,
                                            strokeColor: Colors.black,
                                            child: Text(
                                                "ต่ำสุด: ${forecasts[index].data?.tc_min??''} °C",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontSize: 18, color: Colors.white)
                                            )
                                        ),
                                        BorderedText(
                                            strokeWidth: 3.0,
                                            strokeColor: Colors.black,
                                            child: Text(
                                                "สูงสุด: ${forecasts[index].data?.tc_max??''} °C",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(fontSize: 18, color: Colors.white)
                                            )
                                        )
                                      ]),
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                        BorderedText(
                                            strokeWidth: 3.0,
                                            strokeColor: Colors.white,
                                            child: const Text(
                                                "ความชื้น",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 20, color: Colors.black)
                                            )
                                        ),
                                        const SizedBox(height: 10),
                                        BorderedText(
                                            strokeWidth: 3.0,
                                            strokeColor: Colors.black,
                                            child: Text(
                                                "${forecasts[index].data?.rh??''} %",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 18, color: Colors.white)
                                            )
                                        )
                                      ]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
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
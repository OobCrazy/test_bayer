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
                    return Column(
                      children: [
                        Text(forecasts[index].data?.cond.toString()??''),
                        Text(forecasts[index].data?.rh.toString()??''),
                        Text(forecasts[index].data?.tc_max.toString()??''),
                        Text(forecasts[index].data?.tc_min.toString()??''),
                        Text(forecasts[index].data?.wd10m.toString()??''),
                        Text(forecasts[index].data?.ws10m.toString()??'')
                      ],
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
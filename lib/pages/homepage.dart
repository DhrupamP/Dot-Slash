import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:try_notif/pages/disease.dart';
import 'package:try_notif/pages/singleHome.dart';
import 'package:weather/weather.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'disease.dart';
import 'package:weather_icons/weather_icons.dart';
import '../main.dart';

String apikey = "c7f3ca513a67d8c827f86198c25c05c1";
WeatherFactory wf = new WeatherFactory(apikey);
List<String> croplist = [];

int temp1 = 0;
int temp2 = 0;
int temp3 = 0;
int temp4 = 0;
int temp5 = 0;
int temp6 = 0;

List<String> crops = [
  "Wheat",
  "Rice",
  "Sugarcane",
  "Soyabean",
  "Corn",
  "Moong",
  "Apples",
  "Tomato",
  "Grape",
  "Bajra",
  "Tur",
  "Tea",
  "Coffee",
  "Cotton",
  "Peas",
  "Mustard",
  "Potato",
  "Strawberry"
];
List<int> maxTemp = [
  40,
  42,
  38,
  35,
  40,
  38,
  25,
  32,
  32,
  32,
  18,
  14,
  28,
  37,
  30,
  25,
  21,
  30
];
List<int> minTemp = [
  4,
  20,
  21,
  15,
  0,
  22,
  -2,
  18,
  24,
  18,
  8,
  12,
  15,
  21,
  15,
  15,
  7,
  22
];
void getData() async {
  List<Weather> forcast = await wf.fiveDayForecastByLocation(21.9203, 73.4232);
  temp1 = forcast[0].temperature!.celsius!.toInt();
  temp2 = forcast[5].temperature!.celsius!.toInt();
  temp3 = forcast[15].temperature!.celsius!.toInt();
  temp4 = forcast[25].temperature!.celsius!.toInt();
  temp5 = forcast[30].temperature!.celsius!.toInt();
  temp6 = forcast[39].temperature!.celsius!.toInt();
}

Color temperatureCompare(String crop) {
  int idx = crops.indexOf(crop);
  print(temp1);
  if (temp1 > maxTemp[idx] ||
      temp2 > maxTemp[idx] ||
      temp3 > maxTemp[idx] ||
      temp4 > maxTemp[idx] ||
      temp5 > maxTemp[idx] ||
      temp6 > maxTemp[idx]) {
    return Colors.red;
  } else if (temp1 < minTemp[idx] ||
      temp2 < minTemp[idx] ||
      temp3 < minTemp[idx] ||
      temp4 < minTemp[idx] ||
      temp5 < minTemp[idx] ||
      temp6 < minTemp[idx]) {
    return Colors.blue.shade300;
  }
  return Color(0xffededed);
}

String tempCompare(String crop) {
  int idx = crops.indexOf(crop);
  // print(idx);
  // print(maxTemp[idx]);
  if (temp1 > maxTemp[idx]) {
    return "Attention Required!!Temprature is expected to rise.";
  } else if (temp2 > maxTemp[idx]) {
    return "Attention Required!!Temprature is expected to rise in 1 day.";
  } else if (temp3 > maxTemp[idx]) {
    return "Attention Required!!Temprature is expected to rise in 2 days.";
  } else if (temp4 > maxTemp[idx]) {
    return "Attention Required!!Temprature is expected to rise in 3 days.";
  } else if (temp5 > maxTemp[idx]) {
    return "Attention Required!!Temprature is expected to rise in 4 days.";
  } else if (temp6 > maxTemp[idx]) {
    return "Attention Required!!Temprature is expected to rise in 5 days.";
  } else if (temp1 < minTemp[idx]) {
    return "Attention Required!!Temprature is expected to drop.";
  } else if (temp2 < minTemp[idx]) {
    return "Attention Required!!Temprature is expected to drop in 1 day.";
  } else if (temp3 < minTemp[idx]) {
    return "Attention Required!!Temprature is expected to drop in 2 days.";
  } else if (temp4 < minTemp[idx]) {
    return "Attention Required!!Temprature is expected to drop in 3 days.";
  } else if (temp5 < minTemp[idx]) {
    return "Attention Required!!Temprature is expected to drop in 4 days.";
  } else if (temp6 < minTemp[idx]) {
    return "Attention Required!!Temprature is expected to drop in 5 days.";
  }
  return "Your Crop is safe. Weather is Optimum.";
}

// String tempControl(String crop) {
//   int idx = crops.indexOf(crop);
// }

String currweather = "";
IconData curricon = WeatherIcons.thunderstorm;
String currtemp = "deg cel";
String currstatus = "";
int c = 0;
void getCurrentData() async {
  Weather w = await wf.currentWeatherByLocation(24.3501, 56.7133);
  currweather = w.weatherIcon!;
  c = w.temperature!.celsius!.toInt();
  currtemp = c.toString();
  print(w.temperature!.celsius);
  if (currweather == "11d") {
    curricon = WeatherIcons.day_thunderstorm;
    currstatus = "Thunder Storm";
  } else if (currweather == "09d") {
    curricon = WeatherIcons.day_showers;
    currstatus = "Drizzling";
  } else if (currweather == "10d") {
    curricon = WeatherIcons.day_rain;
    currstatus = "Rainy";
  } else if (currweather == "13d") {
    curricon = WeatherIcons.day_snow;
    currstatus = "Snow";
  } else if (currweather == "50d") {
    curricon = WeatherIcons.day_haze;
    currstatus = "Haze";
  } else if (currweather == "01d") {
    curricon = WeatherIcons.day_sunny;
    currstatus = "Sunny";
  } else if (currweather == "02d" || currweather == "03d") {
    curricon = WeatherIcons.day_cloudy;
    currstatus = "Cloudy";
  } else if (currweather == "04d") {
    curricon = WeatherIcons.day_cloudy_high;
    currstatus = "Cloudy";
  } else if (currweather == "11n") {
    curricon = WeatherIcons.night_thunderstorm;
    currstatus = "Thunder Storm";
  } else if (currweather == "09n") {
    curricon = WeatherIcons.night_showers;
    currstatus = "Drizzling";
  } else if (currweather == "10n") {
    curricon = WeatherIcons.night_rain;
    currstatus = "Rainy";
  } else if (currweather == "13n") {
    curricon = WeatherIcons.night_snow;
    currstatus = "Snow";
  } else if (currweather == "50n") {
    curricon = WeatherIcons.night_fog;
    currstatus = "Haze";
  } else if (currweather == "01n") {
    curricon = WeatherIcons.night_clear;
    currstatus = "Clear";
  } else if (currweather == "02n" || currweather == "03n") {
    curricon = WeatherIcons.night_cloudy;
    currstatus = "Cloudy";
  } else if (currweather == "04n") {
    curricon = WeatherIcons.night_cloudy_high;
    currstatus = "Cloudy";
  }
}

Image imageselector(String crop) {
  if (crop == "Wheat") {
    return Image.asset("assets/images/corn.jfif");
  } else if (crop == "Rice") {
    return Image.asset("assets/images/rice.jfif");
  } else if (crop == "Sugarcane") {
    return Image.asset("assets/images/sugarcane.jfif");
  } else if (crop == "Soyabean") {
    return Image.asset("assets/images/soyabean.jfif");
  } else if (crop == "Corn") {
    return Image.asset("assets/images/corn.jfif");
  } else if (crop == "Moong") {
    return Image.asset("assets/images/moong.jfif");
  } else if (crop == "Apples") {
    return Image.asset("assets/images/apple.jfif");
  } else if (crop == "Tomato") {
    return Image.asset("assets/images/tomato.jfif");
  } else if (crop == "Grape") {
    return Image.asset("assets/images/grapes.jfif");
  } else if (crop == "Bajra") {
    return Image.asset("assets/images/jwar.jfif");
  } else if (crop == "Tur") {
    return Image.asset("assets/images/tur.jfif");
  } else if (crop == "Tea") {
    return Image.asset("assets/images/tea.jfif");
  } else if (crop == "Coffee") {
    return Image.asset("assets/images/coffee.jpg");
  } else if (crop == "Cotton") {
    return Image.asset("assets/images/cotton.jfif");
  } else if (crop == "Peas") {
    return Image.asset("assets/images/peas.jfif");
  } else if (crop == "Mustard") {
    return Image.asset("assets/images/mustard.jfif");
  } else if (crop == "Potato") {
    return Image.asset("assets/images/potato.jfif");
  } else if (crop == "Strawberry") {
    return Image.asset("assets/images/strawberry.jfif");
  } else {
    return Image.asset("assets/images/corn.jfif");
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin fltrNotif = FlutterLocalNotificationsPlugin();
  Future notificationSelected(String? payload) async {}

  Future<void> addData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("name", croplist);
  }

  void putData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      croplist = pref.getStringList("name") as List<String>;
    });
  }

  Future showNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      "my id",
      "dot slash",
      importance: Importance.max,
    );
    NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);
    await fltrNotif.show(0, "notif", "new notif", generalNotificationDetails);
  }

  void initState() {
    super.initState();

    putData();
    getCurrentData();
    AndroidInitializationSettings androidinitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidinitialize);
    fltrNotif.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
    getData();
    // setState(() {
    //   Navigator.pushReplacement(
    //     context,
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation1, animation2) => SingleHome(),
    //       transitionDuration: Duration.zero,
    //     ),
    //   );
    // });
  }

  String dropdownValue = "Wheat";
  @override
  Widget build(BuildContext context) {
    var sh = MediaQuery.of(context).size.height;
    var sw = MediaQuery.of(context).size.width;

    TextEditingController myController = TextEditingController();
    List<Widget> pages = [HomePage(), DiseasePage()];
    String selectedcrop = "";
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("ADD CROP"),
                    content: Container(
                      height: sh * 0.15,
                      child: Column(
                        children: [
                          DropdownButtonFormField(
                            hint: Text("Select Crop"),
                            items: crops
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                selectedcrop = newValue;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  croplist.add(selectedcrop);
                                  Navigator.pop(context);
                                  addData();
                                });
                              },
                              child: Text("ADD"))
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Icon(Icons.add)),
      body: Container(
          height: sh,
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -1),
                child: Container(
                  width: sw * 1,
                  height: sh * 0.4,
                  decoration: const BoxDecoration(
                      color: Color(0xff021837),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     const Center(
                  //       child: Text(
                  //         "APP NAME",
                  //         style: TextStyle(fontSize: 20, color: Colors.white),
                  //       ),
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         const Text(
                  //           "Hi, User",
                  //           style: TextStyle(fontSize: 20, color: Colors.white),
                  //         ),
                  //         Icon(
                  //           curricon,
                  //           color: Colors.white,
                  //         ),
                  //         Text(
                  //           currtemp,
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         Container(
                  //           decoration: BoxDecoration(
                  //               shape: BoxShape.circle, color: Colors.white),
                  //         )
                  //       ],
                  //     )
                  //   ],
                  // ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(0, -0.6),
                        child: Text(
                          "APP NAME",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.3, 0),
                        child: Icon(
                          curricon,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment(0.3, 0.1),
                        child: Text(
                          currtemp + "°C",
                          style: TextStyle(fontSize: 55, color: Colors.white),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.5),
                        child: Text(
                          currstatus,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0.9),
                child: Container(
                  height: sh * 0.6,
                  child: ListView.builder(
                      itemCount: croplist.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return Container(
                          child: CropTile(
                            img: imageselector(croplist[idx]),
                            color: temperatureCompare(croplist[idx]),
                            name: croplist[idx],
                            text: tempCompare(croplist[idx]),
                          ),
                        );
                      }),
                ),
              ),
            ],
          )),
    );
  }
}

class CropTile extends StatefulWidget {
  const CropTile(
      {Key? key,
      required this.name,
      required this.color,
      required this.text,
      required this.img})
      : super(key: key);
  final String name;
  final Color color;
  final String text;
  final Image img;

  @override
  State<CropTile> createState() => _CropTileState();
}

class _CropTileState extends State<CropTile> {
  void putData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      croplist = pref.getStringList("name") as List<String>;
    });
  }

  Future<void> addData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("name", croplist);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.15,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Container(
          //   padding: EdgeInsets.all(10),
          //   height: 70,
          //   child: widget.img,
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
          // ),
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.09,
            child: ClipRRect(
              child: widget.img,
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ],
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 30),
            onPressed: () {
              print(croplist);
              setState(() {
                croplist.remove(widget.name);
                addData();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        SingleHome(),
                    transitionDuration: Duration.zero,
                  ),
                );
              });
              print(croplist);
            },
          ),
        ],
      ),
    );
  }
}

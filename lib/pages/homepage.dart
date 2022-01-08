import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:try_notif/pages/disease.dart';
import 'package:try_notif/pages/singleHome.dart';
import 'package:weather/weather.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'disease.dart';
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

int temp11 = 0;
int temp12 = 0;
int temp13 = 0;
int temp14 = 0;
int temp15 = 0;
int temp16 = 0;

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
  13,
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
  var x = forcast[0].cloudiness;
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
  } else if (temp11 < minTemp[idx] ||
      temp12 < minTemp[idx] ||
      temp13 < minTemp[idx] ||
      temp14 < minTemp[idx] ||
      temp15 < minTemp[idx] ||
      temp16 < minTemp[idx]) {
    return Colors.blue.shade300;
  }
  return Color(0xffededed);
}

String tempCompare(String crop) {
  int idx = crops.indexOf(crop);
  // print(idx);
  // print(maxTemp[idx]);
  if (temp1 > maxTemp[idx]){return "Attention Required!!Temprature is expected to rise.";}
  else if (temp2 > maxTemp[idx]){return "Attention Required!!Temprature is expected to rise in 1 day.";}
  else if (temp3 > maxTemp[idx]){return "Attention Required!!Temprature is expected to rise in 2 days.";}
  else if (temp4 > maxTemp[idx]){return "Attention Required!!Temprature is expected to rise in 3 days.";}
  else if (temp5 > maxTemp[idx]){return "Attention Required!!Temprature is expected to rise in 4 days.";}
  else if (temp6 > maxTemp[idx]){return "Attention Required!!Temprature is expected to rise in 5 days.";}
  else if (temp11 < minTemp[idx]){return "Attention Required!!Temprature is expected to drop.";}
  else if (temp12 < minTemp[idx]){return "Attention Required!!Temprature is expected to drop in 1 day.";}
  else if (temp13 < minTemp[idx]){return "Attention Required!!Temprature is expected to drop in 2 days.";}
  else if (temp14 < minTemp[idx]){return "Attention Required!!Temprature is expected to drop in 3 days.";}
  else if (temp15 < minTemp[idx]){return "Attention Required!!Temprature is expected to drop in 4 days.";}
  else if (temp16 < minTemp[idx]){return "Attention Required!!Temprature is expected to drop in 5 days.";}
  return "Your Crop is safe. Weather is Optimum.";
}

// String tempControl(String crop) {
//   int idx = crops.indexOf(crop);
// }
// String currweather = "";
//
// void getCurrentData() async {
//   Weather w = await wf.currentWeatherByLocation(21.9203, 73.4232);
//
//   currweather = w.weatherIcon!;
//   if(currweather =="11d"){
//     return FontAwesomeIcons.
//   }
// }

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

    AndroidInitializationSettings androidinitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidinitialize);
    fltrNotif.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
    getData();
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
                  height: sh * 0.3,
                  decoration: const BoxDecoration(
                      color: Color(0xff021837),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: Text(
                          "APP NAME",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Hi, User",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Container(
                  height: 300,
                  child: ListView.builder(
                      itemCount: croplist.length,
                      itemBuilder: (BuildContext context, int idx) {
                        return Container(
                          child: CropTile(
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
  const CropTile({Key? key, required this.name, required this.color,required this.text})
      : super(key: key);
  final String name;
  final Color color;
  final String text;

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
      height: 80,
      width: 300,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(widget.name),
          Text(widget.text),
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

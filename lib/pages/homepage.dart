import 'package:flutter/material.dart';
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
void getData() async {
  List<Weather> forcast = await wf.fiveDayForecastByLocation(21.9203, 73.4232);
  temp1 = forcast[0].temperature as int;
  temp2 = forcast[5].temperature as int;
  temp3 = forcast[15].temperature as int;
  temp4 = forcast[25].temperature as int;
  temp5 = forcast[30].temperature as int;
  temp6 = forcast[39].temperature as int;
  print(temp2);
}

Color temperatureCompare(String crop) {
  int idx = crops.indexOf(crop);
  if (temp1 > maxTemp[idx] ||
      temp2 > maxTemp[idx] ||
      temp3 > maxTemp[idx] ||
      temp4 > maxTemp[idx] ||
      temp5 > maxTemp[idx] ||
      temp6 > maxTemp[idx]) {
    return Colors.red;
  }
  return Colors.white;
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

    AndroidInitializationSettings androidinitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidinitialize);
    fltrNotif.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var sh = MediaQuery.of(context).size.height;
    var sw = MediaQuery.of(context).size.width;

    TextEditingController myController = TextEditingController();
    List<Widget> pages = [HomePage(), DiseasePage()];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("ADD CROP"),
                    content: Container(
                      child: Column(
                        children: [
                          TextField(controller: myController),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  croplist.add(myController.text);
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
  const CropTile({Key? key, required this.name, required this.color})
      : super(key: key);
  final String name;
  final Color color;

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

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

void getData() async {
  List<Weather> forcast = await wf.fiveDayForecastByLocation(21.9203, 73.4232);
  print(forcast[39]);
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
  const CropTile({Key? key, required this.name}) : super(key: key);
  final String name;

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
      decoration: const BoxDecoration(
        color: Color(0xffededed),
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

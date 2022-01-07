import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

String apikey = "c7f3ca513a67d8c827f86198c25c05c1";
WeatherFactory wf = new WeatherFactory(apikey);
List<String> croplist = ["wheat", "rice", "mango"];

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
    AndroidInitializationSettings androidinitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidinitialize);
    fltrNotif.initialize(initializationSettings,
        onSelectNotification: notificationSelected);
  }

  int _selectedIndex = 2;
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sh = MediaQuery.of(context).size.height;
    var sw = MediaQuery.of(context).size.width;

    TextEditingController myController = TextEditingController();
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
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
                            croplist.add(myController.text);
                            Navigator.pop(context);
                          },
                          child: Text("ADD"))
                    ],
                  ),
                ),
              );
            });
      }),
      body: Container(
          height: sh,
          child: Stack(
            children: [
              Align(
                alignment: Alignment(0, -1),
                child: Container(
                  width: sw * 1,
                  height: sh * 0.3,
                  decoration: BoxDecoration(
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
              Align(
                alignment: Alignment(0, 1),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  iconSize: 30,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  backgroundColor: Colors.white,
                  selectedItemColor: Color(0xff021837),
                  unselectedItemColor: Color(0xff021837),
                  currentIndex: _selectedIndex,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.camera_alt), label: ""),
                    BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.newspaper), label: ""),
                    BottomNavigationBarItem(icon: Icon(Icons.folder), label: "")
                  ],
                  onTap: onItemTapped,
                ),
              )
            ],
          )),
    );
  }
}

class CropTile extends StatelessWidget {
  const CropTile({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
          Text(name),
          Icon(
            Icons.delete,
            size: 30,
          ),
        ],
      ),
    );
  }
}

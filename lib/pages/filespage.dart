import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -0.4),
              child: Icon(
                FontAwesomeIcons.folderPlus,
                size: MediaQuery.of(context).size.height * 0.3,
                color: Colors.blue,
              ),
            ),
            Align(
              alignment: Alignment(0, 0.3),
              child: Text(
                "Store your Important Files Here",
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.6),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                    // style: ButtonStyle(
                    // backgroundColor:
                    //     MaterialStateProperty.all(Color(0xff021837))),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {}),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.8),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {})),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:try_notif/pages/filespage.dart';
import 'package:try_notif/pages/singleHome.dart';
import 'loading.dart';
class Filee extends StatefulWidget {
  const Filee({Key? key}) : super(key: key);

  @override
  _FileeState createState() => _FileeState();
}
FirebaseStorage storage = FirebaseStorage.instance;
class _FileeState extends State<Filee> {
  late File file;
  void _uploadFile(File file, String filename) async {
    try {
      await storage.ref(filename).putFile(file, SettableMetadata(customMetadata: {'name': filename}));
      setState(() {
        loading=false;
      });
    } on FirebaseException catch (error) {
      print(error);
    }
  }
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    setState(() {});
  }
  Future signOut() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.remove('uid');
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){return SingleHome();}));
  }
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "name": fileMeta.customMetadata?['name'] ?? 'File.pdf',
      });
    });
    return files;
  }
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Your Files")),
        backgroundColor: Color(0xff021837),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed:(){signOut();}),
        ],
      ),
      body: Container(
        child: Align(
          alignment: Alignment(0, 0.8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.5,

                child: FutureBuilder(
                  future: _loadImages(),
                  builder: (context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> image = snapshot.data![index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              dense: false,
                              leading: Icon(Icons.insert_drive_file),
                              title: Text(image['name']),
                              trailing: IconButton(
                                onPressed: () => _delete(image['path']),
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height *0.17,),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                      child: Text(
                        "Upload File",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async{
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf','docx'],
                          allowMultiple: false,
                        );
                        if(result != null) {
                          setState(() {
                            file = File(result.files.single.path!);
                            loading=true;
                            _uploadFile(file,p.basename(file!.path));
                          });
                        }
                      })),
            ],
          ),

        ),
      ),
    );
  }
}
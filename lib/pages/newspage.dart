import 'package:flutter/material.dart';
import 'package:newsapi/newsapi.dart';
import 'package:try_notif/pages/loading.dart';
import 'package:url_launcher/url_launcher.dart';

String newsapikey = '15b94a69059948bab9895e07f56b606b';
List<Article> ans = [];

NewsApi newsapi = NewsApi(apiKey: newsapikey);

void launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch';
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<void> getNews() async {
    var mynews = await newsapi.everything(
      q: "farmers in india",
      language: 'en',
    );
    setState(
      () {
        ans = mynews.articles as List<Article>;
        loading=false;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }
  bool loading=true;
  @override
  Widget build(BuildContext context) {
    return loading==true ? Loading():Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Latest NEWS")),
        backgroundColor: Color(0xff021837),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: ans.length,
            itemBuilder: (BuildContext context, int idx) {
              return NewsTile(text: ans[idx].title.toString(), index: idx);
            }),
      ),
    );
  }
}

class NewsTile extends StatefulWidget {
  const NewsTile({Key? key, required this.text, required this.index})
      : super(key: key);
  final String text;
  final int index;
  @override
  _NewsTileState createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  @override
  Widget build(BuildContext context) {
    var sh = MediaQuery.of(context).size.height;
    var sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        launchURL(ans[widget.index].url);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 20,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        // height: sh * 0.5,
        // width: sw * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(ans[widget.index].urlToImage)),
              Text(
                widget.text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text((ans[widget.index].content)),
            ],
          ),
        ),
      ),
    );
  }
}

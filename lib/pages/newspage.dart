import 'package:flutter/material.dart';
import 'package:newsapi/newsapi.dart';

String newsapikey = '15b94a69059948bab9895e07f56b606b';
List<Article> ans = [];
NewsApi newsapi = NewsApi(apiKey: newsapikey);

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
      },
    );
    print(ans);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: ans.length,
            itemBuilder: (BuildContext context, int idx) {
              return Container(
                padding: EdgeInsets.all(20),
                child: Text(ans[idx].title.toString()),
              );
            }),
      ),
    );
  }
}

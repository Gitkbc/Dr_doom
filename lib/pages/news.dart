import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doom/model/news_model.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<NewsModel> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    Uri url = Uri.parse(
        "https://newsdata.io/api/1/news?apikey=pub_53182918df78bfad73d24def0861bbf6ca922&q=Health");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["status"] == 'success') {
          List<dynamic> results = jsonData["results"];
          newsList.clear(); // Clear old data before adding new data

          for (var element in results) {
            NewsModel newsModel = NewsModel(
              title: element['title'] ?? 'No Title', 
              imageUrl: element['image_url'] ?? '', 
              description: element['description'] ?? 'No Description', 
            );
            newsList.add(newsModel);
          }
        }
      } else {
        print('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health News"),
        backgroundColor: const Color.fromARGB(255, 168, 217, 239), 
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return NewsTile(
                  title: newsList[index].title,
                  description: newsList[index].description,
                  imageUrl: newsList[index].imageUrl,
                );
              },
            ),
    );
  }

  Widget NewsTile({required String title, required String description, String? imageUrl}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      leading: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(imageUrl)
          : const Icon(Icons.image_not_supported),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
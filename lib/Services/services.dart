import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doom/model/news_model.dart';

class NewsApi {
  List<NewsModel> dataStore = [];

  Future<void> getNews() async {
    Uri url = Uri.parse("https://newsdata.io/api/1/news?apikey=pub_53182918df78bfad73d24def0861bbf6ca922&q=Health");
    var response = await http.get(url);
    
    if (response.statusCode == 200) { 
      var jsonData = jsonDecode(response.body);
      
      if (jsonData["status"] == 'success') { 
        jsonData["results"].forEach((element) {
          // Check if necessary fields are not null
          if (element['image_url'] != null && 
              element['description'] != null && 
              element['title'] != null) {
              
            NewsModel newsModel = NewsModel(
              title: element['title'],
              imageUrl: element['image_url'],
              description: element['description']
            );
            
            dataStore.add(newsModel);  
          }
        });
      } else {
      
        print("Failed to fetch news: ${jsonData["status"]}");
      }
    } else {
    
      print("Failed to fetch news: ${response.statusCode}");
    }
  }
}

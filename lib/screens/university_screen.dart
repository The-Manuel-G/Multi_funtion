import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/university_model.dart';
import 'package:url_launcher/url_launcher.dart';

class UniversityScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Universities'),
      ),
      body: Consumer<UniversityModel>(
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter Country',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => model.searchUniversities(_controller.text),
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 20),
                if (model.isLoading) CircularProgressIndicator(),
                if (model.errorMessage.isNotEmpty) Text(model.errorMessage, style: TextStyle(color: Colors.red)),
                Expanded(
                  child: ListView.builder(
                    itemCount: model.universities.length,
                    itemBuilder: (context, index) {
                      final university = model.universities[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                university['name'],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text('Domain: ${university['domains'].join(', ')}'),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () => _launchURL(university['web_pages'][0]),
                                child: Row(
                                  children: [
                                    Icon(Icons.link, color: Colors.blue),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        university['web_pages'][0],
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<void> searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

    if (response.statusCode == 200) {
      setState(() {
        searchResults = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              searchMovies(query);
            }
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index]['show'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0), 
                            child: Image.network(
                              movie['image'] != null
                                  ? movie['image']['medium']
                                  : 'https://via.placeholder.com/100',
                              width: 80,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            movie['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                movie['summary'] != null
                                    ? _removeHtmlTags(movie['summary'])
                                    : 'No summary available',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87),
                              ),
                              Divider(color: Colors.red), 
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(movie: movie),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

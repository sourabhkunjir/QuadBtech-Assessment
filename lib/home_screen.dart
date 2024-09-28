import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuadBTech Movies'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Search Bar below the AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Hero(
              tag: 'search_bar',
              child: TextField(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: Icon(Icons.search, color: Colors.red),
                  suffixIcon: Icon(Icons.arrow_forward_ios, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: movies.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index]['show'];
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(8.0),
                              leading: Hero(
                                tag: movie['id'].toString(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    movie['image'] != null
                                        ? movie['image']['medium']
                                        : 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                movie['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 60),
                                child: Text(
                                  movie['summary'] != null
                                      ? _removeHtmlTags(movie['summary'])
                                      : 'No summary available',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
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
                          Divider(
                            color: Colors.red[400],
                            thickness: 4,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/search');
          }
        },
      ),
    );
  }

  String _removeHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

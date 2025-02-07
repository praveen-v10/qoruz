import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:qourz/pages/marketPlace/single_post_page.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({super.key});

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  int _selectedTabIndex = 1; // "Recent" tab is selected initially
  final List<String> _tabs = ["For You", "Recent", "My Request", "Top Rating"];

  late Future<List<Map<String, dynamic>>> _recentData; // List to hold the data

  @override
  void initState() {
    super.initState();
    _recentData = _fetchData(); // Fetch the data initially
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    final response = await http.get(Uri.parse("https://staging3.hashfame.com/api/v1/interview.mplist?page=1"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Map<String, dynamic>> requests = [];
      if (data["ok"] && data["marketplace_requests"] != null) {
        var requestsData = data["marketplace_requests"];

        // Loop through all the requests
        for (var request in requestsData) {
          requests.add(request);
        }
        print(requests);
      }
      return requests;
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Marketplace',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFE5A2B), Color(0xFFFC3A5D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu_open_outlined,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type your requirement here . . .",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/search_bar_icon.png'),
                    radius: 16,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                    if (_tabs[index] == "Recent") {
                      // Call the API when "Recent" tab is selected
                      _recentData = _fetchData();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: _selectedTabIndex == index ? Color(0xFFFFEFEF) : Colors.white,
                      border: Border.all(width: 1, color: _selectedTabIndex == index ? Colors.red : Colors.grey),
                    ),
                    child: Row(
                      children: [
                        if (_tabs[index] == "Top Rating") ...[
                          Icon(Icons.star, color: Colors.amber),
                          SizedBox(width: 5),
                        ],
                        Center(
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: _selectedTabIndex == 1
                ? FutureBuilder<List<Map<String, dynamic>>>(
              future: _recentData, // Ensure _recentData is assigned
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  var requests = snapshot.data!;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      var request = requests[index];
                      // var profileImage = request['profile_image'] ?? ''; // Safe null check
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: (){
                            var idHash = request['id_hash'];
                            Get.to(SinglePostPage(idHash: idHash));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.grey.shade300),
                                borderRadius:BorderRadius.circular(18),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: SizedBox(
                                          width: 50,  // Set the width of the image (size of the circular profile image)
                                          height: 50, // Set the height of the image (same value as width to maintain a circle)
                                          child: Image(
                                            image: request['user_details']['profile_image'] != null
                                                ? NetworkImage(request['user_details']['profile_image'])
                                                : AssetImage('assets/search_bar_icon.png') as ImageProvider,
                                            fit: BoxFit.cover,  // Ensures the image covers the entire circular area
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 14),  // Add space between the image and the name
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            request['user_details']['name']?.isNotEmpty == true
                                                ? request['user_details']['name']
                                                : 'Guest',  // Check if name is empty or null
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${request['user_details']['designation']?.isNotEmpty == true ? request['user_details']['designation'] : ''} '
                                                '${request['user_details']['company']?.isNotEmpty == true ? 'at ${request['user_details']['company']}' : ''}',
                                            style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey),
                                          ),

                                          Row(
                                            children: [
                                              Icon(Icons.access_time_rounded,color: Colors.grey,size: 20),
                                              Text(
                                                '${request['created_at']?.isNotEmpty == true ? request['created_at'] : ''} ',

                                                style: TextStyle(fontWeight: FontWeight.normal,color: Colors.grey),
                                              ),
                                            ],
                                          )


                                        ],
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(CupertinoIcons.person_2,color: Colors.blue,size: 20),
                                       SizedBox(width: 4,),
                                        Text(
                                          ' Looking for ${request['service_type']?.isNotEmpty == true ? request['service_type'] : ''} ',

                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Budget: ₹ ${request['request_details'] != null && request['request_details']['budget']?.isNotEmpty == true ? request['request_details']['budget'] : 'xxxxx'}',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                        Text(
                                          'brand: ${request['request_details'] != null && request['request_details']['brand']?.isNotEmpty == true ? request['request_details']['brand'] : 'xxxxx'}',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                        ),

                                        Text(
                                          'Location: Goa & Kerala ',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                        ),

                                        Text(
                                          'Type: ${request['description']?.isNotEmpty == true ? request['description'] : ''} ',

                                          style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black),
                                        ),

                                        SizedBox(height: 6,),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF5F6FB),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min, // This ensures the container width is based on the content size
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: Colors.black,
                                                  size: 20,
                                                ),
                                                Text(
                                                  request['request_details'] != null && request['request_details']['cities'] != null && request['request_details']['cities'].isNotEmpty
                                                      ? request['request_details']['cities'].join(', ') + ' +1more' // Joining cities with comma and adding "+1more"
                                                      : 'Bangalore, Tamilnadu, Kerala +1more',
                                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                                )

                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF5F6FB),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min, // This ensures the container width is based on the content size
                                                  children: [
                                                    Icon(
                                                      Icons.facebook_outlined,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      ' ${request['request_details'] != null && request['request_details']['followers_range'] != null
                                                          ? '${request['request_details']['followers_range']['ig_followers_min'] ?? ''} - ${request['request_details']['followers_range']['ig_followers_max'] ?? ''}'
                                                          : '1k to 10k'} ',
                                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                                    ),

                                                  ],
                                                )

                                              ),
                                            ),

                                          ],
                                        ),
                          SizedBox(height: 4,),

                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF5F6FB),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child:Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.account_tree_outlined,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      'Categories: ${request['request_details'] != null && request['request_details']['categories'] != null
                                                          ? request['request_details']['categories'].join(', ')  // Join categories with a comma
                                                          : 'Lifestyle, Fashion'} ',
                                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                                                      overflow: TextOverflow.ellipsis, // Handles overflow and adds ellipsis
                                                      maxLines: 1,  // Restrict to a single line, if desired
                                                    ),
                                                  ),
                                                ],
                                              )



                                          ),
                                        ),
                                      ],
                                    ),
                                  ),




                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
                : Center(
              child: Text(
                '${_tabs[_selectedTabIndex]}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
        floatingActionButton: Material(
          color: Colors.transparent, // Makes the material background transparent
          child: InkWell(
            onTap: () {
              // Handle your action here
            },
            borderRadius: BorderRadius.circular(30), // Set the rounded corners here
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding for spacing between icon and text
              decoration: BoxDecoration(
                color: Colors.red, // Set the background color to red
                borderRadius: BorderRadius.circular(30), // Round the corners
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Makes sure it wraps the content size
                children: [
                  Icon(Icons.add, color: Colors.white), // Icon for the button
                  SizedBox(width: 8), // Add some space between the icon and text
                  Text(
                    'Post Request',
                    style: TextStyle(color: Colors.white), // Text color
                  ),
                ],
              ),
            ),
          ),
        )


    );
  }
}

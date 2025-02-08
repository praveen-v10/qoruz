import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class SinglePostPage extends StatefulWidget {
  final String idHash;
  const SinglePostPage({super.key, required this.idHash});

  @override
  State<SinglePostPage> createState() => _SinglePostPageState();
}

class _SinglePostPageState extends State<SinglePostPage> {
  late Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    super.initState();
    // Fetch data using the passed 'id_hash' value from the URL
    _data = fetchData(widget.idHash);
  }

  Future<Map<String, dynamic>> fetchData(String idHash) async {
    final response = await http.get(Uri.parse('https://staging3.hashfame.com/api/v1/interview.mplist?id_hash=$idHash'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);

      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
         color: Colors.white
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              toastification.show(
                context: context, // optional if you use ToastificationWrapper
                title: Text('Delete Post'),
                alignment: Alignment.bottomCenter,
                autoCloseDuration: const Duration(seconds: 3),

                primaryColor: Colors.red,
                backgroundColor: Colors.white,
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFE5A2B), Color(0xFFFC3A5D)],

                ),
                borderRadius: BorderRadius.circular(8),
                 // Circular box
              ),
              child: IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: Colors.white, // White icon color
                ),
                onPressed: () {
                  toastification.show(
                    context: context, // optional if you use ToastificationWrapper
                    title: Text('Share the Post'),
                    alignment: Alignment.bottomCenter,
                    autoCloseDuration: const Duration(seconds: 3),

                    primaryColor: Colors.red,
                    backgroundColor: Colors.white,
                  );
                },
              ),
            ),
          ),
        ],

      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          // Get the 'web_marketplace_requests' data from the response
          var data = snapshot.data!['web_marketplace_requests'];

          return SingleChildScrollView(  // Wrapping the content with SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your existing content here (Container, Padding, etc.)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 50,  // Set the width of the image (size of the circular profile image)
                                height: 50, // Set the height of the image (same value as width to maintain a circle)
                                child: Image(
                                  image: data['user_details']['profile_image'] != null
                                      ? NetworkImage(data['user_details']['profile_image'])
                                      : AssetImage('assets/search_bar_icon.png') as ImageProvider,
                                  fit: BoxFit.cover,  // Ensures the image covers the entire circular area
                                ),
                              ),
                            ),
SizedBox(width: 6,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data['user_details']['name']?.isNotEmpty == true
                                          ? data['user_details']['name']
                                          : 'Guest',  // Check if name is empty or null
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.verified_user_outlined, color: Colors.green, size: 18),
                                  ],
                                ),
                                Text(
                                  '${data['user_details']['designation']?.isNotEmpty == true ? data['user_details']['designation'] : ''}',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.maps_home_work_outlined, color: Colors.grey, size: 20),
                                    Text(
                                      '${data['user_details']['company']?.isNotEmpty == true ? ' ${data['user_details']['company']}' : ''}',
                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                         // Add space between the image and the name


                        Text(
                          '${data['created_at']?.isNotEmpty == true ? data['created_at'] : ''} ',
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .normal,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                // The rest of the content (Text, Rows, etc.)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Looking for', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16,color: Colors.grey)),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset( 'assets/vector.png',scale: 4,),
                          SizedBox(width: 4),
                          Text(
                            '${data['service_type']?.isNotEmpty == true ? data['service_type'] : ''}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),

                      Divider(color: Colors.grey.shade300,),

                      Text('Highlights', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16,color: Colors.grey)),

                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F6FB),
                              borderRadius:
                              BorderRadius.circular(
                                  8),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Icon(Icons.currency_rupee_outlined,color: Colors.black,size: 16,),
                                  SizedBox(width: 4,),
                                  Text(
                                    'Budget: ₹ ${data['request_details'] != null && data['request_details']['budget']?.isNotEmpty == true ? data['request_details']['budget'] : 'xxxxx'}',
                                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 16,),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 14,),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F6FB),
                              borderRadius:
                              BorderRadius.circular(
                                  8),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Image.asset( 'assets/vector2.png',scale: 3,),
                                  SizedBox(width: 4,),

                                  Text(
                                    'brand: ${data['request_details'] != null && data['request_details']['brand']?.isNotEmpty == true ? data['request_details']['brand'] : 'xxxxx'}',
                                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

SizedBox(height: 10,),
                      Text(
                        'Budget: ₹ ${data['request_details'] != null && data['request_details']['budget']?.isNotEmpty == true ? data['request_details']['budget'] : 'xxxxx'}',
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        'brand: ${data['request_details'] != null && data['request_details']['brand']?.isNotEmpty == true ? data['request_details']['brand'] : 'xxxxx'}',
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        'Location: Goa & Kerala ',
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                      ),
                      Text(
                        'Type: ${data['description']?.isNotEmpty == true ? data['description'] : ''}',
                        style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          toastification.show(
                            context: context, // optional if you use ToastificationWrapper
                            title: Text('Share via WhatsApp'),
                            alignment: Alignment.bottomCenter,
                            autoCloseDuration: const Duration(seconds: 3),

                            primaryColor: Colors.green,
                            backgroundColor: Colors.white,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE2FBEA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // This ensures the container width is based on the content size
                              children: [
                                Image.asset('assets/whatsapp.png',scale: 2,),
                                SizedBox(width: 10,),
                                Text(
                                  'Share via WhatsApp',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 14),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          toastification.show(
                            context: context, // optional if you use ToastificationWrapper
                            title: Text('Share on LinkedIn'),
                            alignment: Alignment.bottomCenter,
                            autoCloseDuration: const Duration(seconds: 3),

                            primaryColor: Colors.blue,
                            backgroundColor: Colors.white,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFE0EDF8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // This ensures the container width is based on the content size
                              children: [
                                Image.asset('assets/linkedin.png',scale: 2,),
                                SizedBox(width: 10,),
                                Text(
                                  'Share on LinkedIn',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black,fontSize: 14),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Add any additional widgets here
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Key Highlighted Details',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade400, fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Category",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  data['request_details']?['categories']?.join(', ') ?? 'Lifestyle, Fashion',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Platform",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  data['request_details']?['platform']?.join(', ') ?? 'Instagram, YouTube',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Language",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  data['request_details']?['languages']?.join(', ') ?? 'Arabic',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  data['request_details']?['cities']?.join(', ') ?? 'Chennai, Delhi',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Required Count",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  data['request_details']?['creator_count_min'] != null
                                      ? '${data['request_details']['creator_count_min']} - ${data['request_details']['creator_count_max']}'
                                      : '1 to 10',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Our Budget",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '₹ ${data['request_details']?['budget']?.isNotEmpty == true ? data['request_details']['budget'] : 'xxxxx'}',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),


                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Brand collab with",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${data['request_details'] != null && data['request_details']['brand']?.isNotEmpty == true ? data['request_details']['brand'] : 'xxxxx'}',
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Required followers",
                                  style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.facebook_outlined,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    Text(
                                      ' ${data['request_details'] != null && data['request_details']['followers_range'] != null
                                          ? '${data['request_details']['followers_range']['ig_followers_min'] ?? ''} - ${data['request_details']['followers_range']['ig_followers_max'] ?? ''}'
                                          : '1k to 10k'} ',
                                      style: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        ],
                      ),

SizedBox(height: 40,)
                    ],
                  ),
                ),



              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevents unnecessary space issues
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to start
          children: [
            Row(
              children: [
                Icon(Icons.watch_later_outlined, color: Colors.blue),
                SizedBox(width: 8), // Adds spacing between icon and text
                Expanded( // Prevents text overflow
                  child: Text(
                    'Your post will expire on 26 July',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    overflow: TextOverflow.ellipsis, // Ensures proper text handling
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Adds spacing before buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Transparent background
                      elevation: 0, // No shadow
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.red, width: 2), // Red border
                      ),
                    ),
                    onPressed: () {
                      toastification.show(
                        context: context, // optional if you use ToastificationWrapper
                        title: Text('Edit the account'),
                        alignment: Alignment.center,
                        autoCloseDuration: const Duration(seconds: 3),
                        primaryColor: Colors.red,
                        backgroundColor: Colors.white,
                      );
                      // Handle Edit action
                    },
                    child: Text(
                      "Edit",
                      style: TextStyle(color: Colors.red, fontSize: 16), // Red text color
                    ),
                  ),

                ),
                SizedBox(width: 10), // Spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      toastification.show(
                        context: context, // optional if you use ToastificationWrapper
                        title: Text('Close the account'),
                        alignment: Alignment.center,
                        autoCloseDuration: const Duration(seconds: 3),
                        primaryColor: Colors.red,
                        backgroundColor: Colors.white,
                      );
                      // Handle Close action
                    },
                    child: Text("Close", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),


    );
  }
}
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:oru/screens/product.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _tappedIndex; // Stores the tapped image index for applying shadow
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, String>> brandImages = [];
  bool isLoading = true; // To track loading state

  @override
  void initState() {
    super.initState();
    fetchBrandImages();
  }

  Future<void> fetchBrandImages() async {
    final response =
        await http.get(Uri.parse('http://40.90.224.241:5000/makeWithImages'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData["status"] == "SUCCESS") {
        setState(() {
          brandImages = (jsonData["dataObject"] as List)
              .map((item) => {
                    "make": item["make"].toString(),
                    "imagePath": item["imagePath"].toString(),
                  })
              .toList();
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Attach the key to Scaffold
      drawer: CustomDrawer(),

      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFFFFFFFF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu_outlined, size: 40),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Image.asset('assets/oru.jpeg', height: 80),
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Text('India'),
                    Icon(Icons.location_on_outlined),
                    Text('  '),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            // Avoid overlap with search bar
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (var label in [
                          'Sell Used Phones',
                          'Buy Used Phones',
                          'Compare Prices',
                          'My Profile',
                          'My Listings',
                          'Services',
                          'Register Your Store',
                          'Get The App'
                        ])
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(
                                label,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // R4 Image Banners (Auto and Manual Sliding)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    child: CarouselSlider.builder(
                      itemCount: 5, // Number of banners
                      itemBuilder: (context, index, realIndex) {
                        return Image.asset(
                          'assets/banner/ban${index + 1}.jpg',
                          fit: BoxFit.fill,
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "What's on your mind?",
                    style: TextStyle(fontSize: 22),
                  ),
                ),

                // Horizontal Slide of Images with Tap Shadow Effect
                Container(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 18,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTapDown: (_) {
                          setState(() {
                            _tappedIndex = index; // Apply shadow
                          });
                        },
                        onTapUp: (_) {
                          Future.delayed(Duration(milliseconds: 200), () {
                            setState(() {
                              _tappedIndex = null; // Remove shadow
                            });
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: _tappedIndex == index
                                ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      spreadRadius: 3,
                                      offset: Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Image.asset('assets/mind/m${index + 1}.png'),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 25),

                // Top Brands Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Top Brands', style: TextStyle(fontSize: 20)),
                      IconButton(
                          icon: Icon(Icons.arrow_forward), onPressed: () {}),
                    ],
                  ),
                ),

                // Horizontal Slide of Brand Images with Tap Shadow Effect
                Container(
                  height: 100,
                  child: isLoading
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5, // Placeholder count
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 80,
                                height: 80,
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: brandImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _tappedIndex = index + 100;
                                });
                              },
                              onTapUp: (_) {
                                Future.delayed(Duration(milliseconds: 200), () {
                                  setState(() {
                                    _tappedIndex = null;
                                  });
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Colors.grey[300], // Light grey background
                                  boxShadow: _tappedIndex == index + 100
                                      ? [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                            offset: Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  // Adjust the size
                                  backgroundColor: Colors.grey[100],
                                  // Background color
                                  child: ClipOval(
                                    child: Image.network(
                                      brandImages[index]["imagePath"]!,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.fitWidth,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.broken_image,
                                            size: 40);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Best deals in India",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                ProductGridWidget(),
                FAQSection(),
              ],
            ),
          ),

          // Search Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  prefixIcon: Icon(Icons.search, color: Colors.yellow[600]),
                  hintText: 'Search phones with make, model...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> fetchFilters() async {
  final response =
      await http.get(Uri.parse('http://40.90.224.241:5000/showSearchFilters'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['dataObject'];
  }
  return null;
}

class FilterSheet extends StatefulWidget {
  final Map<String, dynamic> filters;

  FilterSheet({required this.filters});

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  Map<String, List<String>> selectedFilters = {};
  String selectedCategory = '';
  double minPrice = 1000;
  double maxPrice = 5000;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.filters.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
          Divider(),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 150,
                  child: ListView(
                    padding: EdgeInsets.zero, // Remove default ListView padding
                    children: widget.filters.keys.map((category) {
                      bool isSelected = selectedCategory == category;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        // Equal spacing between rows
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => selectedCategory = category),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.amber.withOpacity(0.3)
                                  : Colors.transparent, // Highlight entire row
                              borderRadius: BorderRadius.circular(
                                  8), // Optional rounded corners
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 5, // Thick vertical line
                                      height: 20, // Adjust height
                                      color: isSelected
                                          ? Colors.amber
                                          : Colors.transparent,
                                    ),
                                    SizedBox(width: 8),
                                    // Space between line and text
                                    Text(
                                      "$category",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.amber
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                if (selectedFilters[category]?.length != null)
                                  Text(
                                    " ${selectedFilters[category]?.length}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.amber
                                          : Colors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey,
                ),
                Expanded(
                  child: selectedCategory == 'Price Range'
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Select Price Range',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            /*FlutterSlider(
                        values: [minPrice, maxPrice],
                        rangeSlider: true,
                        min: 1000,
                        max: 5000,
                        onDragging: (handlerIndex, lowerValue, upperValue) {
                          setState(() {
                            minPrice = lowerValue;
                            maxPrice = upperValue;
                          });
                        },
                      ),*/
                            Text('₹${minPrice.toInt()} - ₹${maxPrice.toInt()}')
                          ],
                        )
                      : ListView(
                          children: [
                            CheckboxListTile(
                              title: Text('All'),
                              value:
                                  selectedFilters[selectedCategory]?.length ==
                                      widget.filters[selectedCategory].length,
                              onChanged: (isChecked) {
                                setState(() {
                                  if (isChecked == true) {
                                    selectedFilters[selectedCategory] =
                                        List.from(
                                            widget.filters[selectedCategory]);
                                  } else {
                                    selectedFilters[selectedCategory]?.clear();
                                  }
                                });
                              },
                            ),
                            ...widget.filters[selectedCategory]
                                .map<Widget>((item) {
                              return CheckboxListTile(
                                title: Text(item),
                                value: selectedFilters[selectedCategory]
                                        ?.contains(item) ??
                                    false,
                                onChanged: (isChecked) {
                                  setState(() {
                                    if (isChecked == true) {
                                      selectedFilters
                                          .putIfAbsent(
                                              selectedCategory, () => [])
                                          .add(item);
                                    } else {
                                      selectedFilters[selectedCategory]
                                          ?.remove(item);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ],
                        ),
                )
              ],
            ),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => selectedFilters.clear()),
                  child: Text('Clear All',
                      style: TextStyle(color: Colors.amber, fontSize: 16)),
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Colors.grey,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Apply', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class FAQSection extends StatefulWidget {
  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  Map<String, bool> faqExpanded = {};
  List<dynamic> faqs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFAQs();
  }

  Future<void> fetchFAQs() async {
    final url = Uri.parse("http://40.90.224.241:5000/faq");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          faqs = data["FAQs"];
          for (var faq in faqs) {
            faqExpanded[faq["question"]] = false;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching FAQs: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200,
                height: 20,
                color: Colors.grey[300],
              ),
              Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey),
            ],
          ),
        ),
        Divider(),
        Column(
          children: List.generate(5, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  trailing: Icon(Icons.add, color: Colors.grey),
                ),
                Divider(),
              ],
            );
          }),
        ),
        Container(
          height: 100,
          width: double.infinity,
          color: Colors.grey[300],
        ),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Frequently Asked Questions",
                style: TextStyle(fontSize: 22),
              ),
              Icon(Icons.arrow_forward_ios_outlined)
            ],
          ),
        ),
        Divider(),
        Column(
          children: faqs.map((faq) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    faq["question"],
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      faqExpanded[faq["question"]]!
                          ? Icons.close
                          : Icons.add,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        faqExpanded[faq["question"]] =
                        !faqExpanded[faq["question"]]!;
                      });
                    },
                  ),
                ),
                if (faqExpanded[faq["question"]]!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      faq["answer"],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                Divider(),
              ],
            );
          }).toList(),
        ),
        Image.asset("assets/end.png"),
      ],
    );
  }

}

class CustomDrawer extends StatefulWidget {
  final bool isLoggedIn;
  final String? userName;
  final String? joinedDate;
  final String? userProfileImage;

  CustomDrawer({
    this.isLoggedIn = false,
    this.userName,
    this.joinedDate,
    this.userProfileImage,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFFFFFFF),
      child: Column(
        children: [
          // R1: ORU Logo and Close Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/oru.jpeg', height: 50),
                IconButton(
                  icon: Icon(Icons.close, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // R2: Login/SignUp Button or Profile Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: widget.isLoggedIn
                ? Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.userProfileImage != null
                            ? AssetImage(widget.userProfileImage!)
                            : AssetImage('assets/default_dp.png'),
                        radius: 30,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.userName ?? "User Name",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Joined: ${widget.joinedDate ?? 'N/A'}",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3E468F),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Login / Sign Up",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
          ),

          SizedBox(height: 20),

          // R3: Sell Your Phone Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffF6C018),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Sell Your Phone",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),
          SizedBox(height: 20),
          if (widget.isLoggedIn)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Row(
                children: [
                  Icon(Icons.logout_outlined),
                  TextButton(onPressed: () {}, child: Text("Logout")),
                ],
              ),
            ),
          Spacer(),

          // Bottom Section: 2x3 Grid of Images in Chips
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(6, (index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFFFFF),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/chip/image (${index + 1}).png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

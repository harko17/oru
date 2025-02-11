import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class ProductGridWidget extends StatefulWidget {
  @override
  _ProductGridWidgetState createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
  List<dynamic> products = [];
  List<String> adImages = ["assets/ad1.png", "assets/ad2.png"];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse("http://40.90.224.241:5000/filter");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"filter": {}}), // Fetch all products
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        products = data["data"]["data"] ?? []; // Adjust based on API response
      });
    } else {
      print("Failed to load products");
    }
  }

  void showFilterBottomSheet(BuildContext context) async {
    final filters = await fetchFilters();
    if (filters == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FilterSheet(filters: filters);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                  foregroundColor: Colors.black, // Black text color
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    side: BorderSide(color: Colors.grey.shade300), // Border
                  ),
                ),
                onPressed: () async {
                  final selectedSort = await showModalBottomSheet<String>(
                    context: context,
                    builder: (context) => SortSheet(),
                  );

                  if (selectedSort != null) {
                    print(
                        "Selected Sort Option: $selectedSort"); // Handle the selected sort option
                  }
                },
                icon: Icon(Icons.sort, color: Colors.black),
                // Sort icon (Suffix)
                label: Row(
                  children: [
                    Text("Sort", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 6),
                    // Space between text and arrow
                    Icon(Icons.arrow_drop_down, color: Colors.black),
                    // Down arrow
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              // Filter Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onPressed: () => showFilterBottomSheet(context),
                icon: Icon(Icons.filter_list, color: Colors.black),
                // Filter icon (Prefix)
                label: Row(
                  children: [
                    Text("Filter", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_drop_down, color: Colors.black),
                    // Down arrow (Suffix)
                  ],
                ),
              ),
            ],
          ),
        ),
        products.isEmpty
            ? GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.65,
          ),
          itemCount: 6, // Show 6 skeleton items
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            );
          },
        )
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.65,
            ),
            itemCount: products.length + (products.length ~/ 5),
            itemBuilder: (context, index) {
              if ((index + 1) % 6 == 0) {
                return AdCard(adImages[(index ~/ 6) % adImages.length]);
              }

              final actualIndex = index - (index ~/ 6);
              final product = products[actualIndex];

              final imageUrl = product["defaultImage"]?["fullImage"] ??
                  (product["images"] != null && product["images"].isNotEmpty
                      ? product["images"][0]["fullImage"]
                      : "https://via.placeholder.com/150");

              return ProductCard(
                imageUrl: imageUrl,
                name: product["marketingName"] ?? "Unknown",
                price: product["listingPrice"]?.toString() ?? "N/A",
                originalPrice: product["originalPrice"]?.toString() ?? "",
                discount: (product["discountPercentage"] ?? 0).toDouble(),
                storage: product["deviceStorage"] ?? "N/A",
                condition: product["deviceCondition"] ?? "N/A",
                location: product["listingLocality"] ?? "Unknown",
                isNegotiable: product["openForNegotiation"] ?? false,
                isVerified: product["verified"] ?? false,
                date: "July 25th",
              );
            },
          ),
        ),

      ],
    );
  }
}

// Ad Card Widget (Uses ad1.png & ad2.png)
class AdCard extends StatelessWidget {
  final String adImage;

  AdCard(this.adImage);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          adImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Product Card Widget (Same as before)
class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String originalPrice;
  final double discount;
  final String storage;
  final String condition;
  final String location;
  final bool isNegotiable;
  final bool isVerified;
  final String date;

  ProductCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.storage,
    required this.condition,
    required this.location,
    required this.isNegotiable,
    required this.isVerified,
    required this.date,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  widget.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (widget.isVerified)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "ORU Verified",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (widget.isNegotiable)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Text(
                        "PRICE NEGOTIABLE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 2),
                Text(
                  "${widget.storage} • ${widget.condition}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    if (widget.originalPrice.isNotEmpty)
                      Text(
                        "₹${widget.originalPrice}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    SizedBox(width: 4),
                    Text(
                      "₹${widget.price}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    if (widget.discount > 0)
                      Text(
                        " (${widget.discount.toInt()}% off)",
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  widget.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  widget.date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SortSheet extends StatefulWidget {
  @override
  _SortSheetState createState() => _SortSheetState();
}

class _SortSheetState extends State<SortSheet> {
  String? selectedSortOption;

  final List<String> sortOptions = [
    "Value For Money",
    "Price: High To Low",
    "Price: Low To High",
    "Latest",
    "Distance"
  ];

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
              Text('Sort',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 1),
              // Increased horizontal padding
              children: sortOptions.map((option) {
                bool isSelected = selectedSortOption == option;
                return GestureDetector(
                  onTap: () => setState(() => selectedSortOption = option),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    // Increased vertical padding for bigger list tile
                    child: Container(
                      height: 40,
                      color: isSelected
                          ? Colors.amber[100]
                          : Colors
                              .transparent, // Lighter background for selected item
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              option,
                              style: TextStyle(
                                fontSize: 18,
                                // Increased font size for better readability

                                color: isSelected
                                    ? Colors.amber
                                    : Colors
                                        .black, // Text color amber when selected
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.amber, width: 2),
                                color: isSelected
                                    ? Colors.amber
                                    : Colors
                                        .white, // Outer circle always visible, filled when selected
                              ),
                              child: Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors
                                            .transparent, // Inner circle filled when selected
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => setState(() => selectedSortOption = null),
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
                  onPressed: () => Navigator.pop(context, selectedSortOption),
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

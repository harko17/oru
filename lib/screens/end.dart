import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class PromoScreen extends StatelessWidget {
  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Link copied to clipboard")),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Subscription Section
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.amber,
              child: Column(
                children: [
                  Text(
                    "Get Notified About Our Latest Offers and Price Drops",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter your email here",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Send"),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Download App Section
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.black87,
              child: Column(
                children: [
                  Text(
                    "Download App",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.network("https://your_qr_code_link_for_playstore.png",
                              width: 100, height: 100),
                          SizedBox(height: 5),
                          Icon(Icons.android, color: Colors.white, size: 30),
                        ],
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          Image.network("https://your_qr_code_link_for_appstore.png",
                              width: 100, height: 100),
                          SizedBox(height: 5),
                          Icon(Icons.apple, color: Colors.white, size: 30),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Invite a Friend Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Invite a Friend", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 5),
                  Text(
                    "Invite a friend to ORUphones application.\nTap to copy the respective download link to the clipboard",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => _copyToClipboard("https://play.google.com/store/apps/details?id=com.oruphones", context),
                    child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg",
                        width: 150),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () => _copyToClipboard("https://apps.apple.com/us/app/oruphones/id123456789", context),
                    child: Image.network(
                        "https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg",
                        width: 150),
                  ),
                ],
              ),
            ),

            // Social Share Section
            Text("Or Share", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () => _launchURL("https://facebook.com"),
                ),
                IconButton(
                  icon: Icon(Icons.telegram, color: Colors.blueAccent),
                  onPressed: () => _launchURL("https://t.me"),
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.black),
                  onPressed: () => _launchURL("https://twitter.com"),
                ),
                IconButton(
                  icon: Icon(Icons.whatshot, color: Colors.green),
                  onPressed: () => _launchURL("https://wa.me"),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

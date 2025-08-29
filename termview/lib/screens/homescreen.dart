import 'package:flutter/material.dart';
import 'package:termview/screens/createsession.dart';
import 'package:termview/screens/settings.dart';
import 'package:termview/widgets/page_transition.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Map<String, dynamic>> sessions = [
    {
      "title": "Flutter Basics",
      "author": "Umaan",
      "isLive": true,
      "thumbnail":
          "https://res.cloudinary.com/dtuxl8mui/image/upload/v1756449484/thumbnail_muhoa3jl.jpg.jpg"
    },
    {
      "title": "Python 101",
      "author": "Alice",
      "isLive": false,
      "thumbnail":
          "https://res.cloudinary.com/dtuxl8mui/image/upload/v1756449484/thumbnail_muhoa3jl.jpg.jpg"
    },
    {
      "title": "The winds began to stir. The oceans rose in gentle anticipation. Stars shifted in the sky, aligning in a pattern that no one had seen for millennia. Something monumental was about to awaken, and the universe itself seemed to hold its breath.",
      "author": "Alice",
      "isLive": false,
      "thumbnail":
          "https://res.cloudinary.com/dtuxl8mui/image/upload/v1756449484/thumbnail_muhoa3jl.jpg.jpg"
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: Text("TermView", style: text.bodyLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                navigate(context, Createsession());
              },
              style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
              child: const Text('Create Session +'),
            ),
          ),
          IconButton(
            onPressed: () {
              navigate(context, Settings());
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  session["thumbnail"],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(session["title"], style: text.bodyMedium),
              subtitle: Text("Author: ${session["author"]}"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: session["isLive"] ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  session["isLive"] ? "LIVE" : "OFFLINE",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                // Navigate to session details if needed
              },
            ),
          );
        },
      ),
    );
  }
}

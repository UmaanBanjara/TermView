import 'package:flutter/material.dart';

class Livequizpage extends StatefulWidget {
  final bool? host;
  final bool? user;

  const Livequizpage({
    this.host,
    this.user,
    super.key,
  });

  @override
  State<Livequizpage> createState() => _LivequizpageState();
}

class _LivequizpageState extends State<Livequizpage> {
  int? _selectedOption;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Live Quiz Monitor", style: text.bodyLarge),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // ----------------- USER VIEW -----------------
            if (widget.user == true) ...[
              Text("Question", style: text.bodyLarge),
              const SizedBox(height: 5),
              Text(
                "(Waiting for quiz...)",
                style: text.bodyMedium,
              ),
              const SizedBox(height: 10),
              Text("Options", style: text.bodyLarge),
              const SizedBox(height: 5),
              ...List.generate(4, (index) {
                return ListTile(
                  title: Text(
                    "(waiting...)",
                    style: text.bodyMedium,
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _selectedOption,
                    onChanged: (val) {
                      setState(() => _selectedOption = val);
                    },
                  ),
                );
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => setState(() => _selectedOption = null),
                      child: Text("Cancel", style: text.bodyMedium),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for "Send" goes here
                      },
                      child: Text("Send", style: text.bodyMedium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ----------------- HOST VIEW -----------------
            if (widget.host == true) ...[
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.black87,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: 10, // Just a placeholder count
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Hello World",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Action for "Reveal Answer" goes here
                },
                child: Text("Reveal Answer", style: text.bodyMedium),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

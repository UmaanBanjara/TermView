import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:termview/helpers/imagepicker_web_helper.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/livesession.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Createsession extends StatefulWidget {
  const Createsession({super.key});

  @override
  State<Createsession> createState() => _CreatesessionState();
}

class _CreatesessionState extends State<Createsession> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  bool _chatenabled = false;
  Uint8List? _selectedImage;
  
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: BackButton(),
        title:Text('Create New Session', style: text.bodyLarge),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _title,
                maxLines: 1,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter the title for this session",
                ),
                validator: (value) => validateNotEmpty(value, "Title"),
              ),
              SizedBox(height: 10),
              TextFormField(
                cursorHeight: 22,
                maxLines: null,
                controller: _desc,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter the description for this session",
                ),
                validator: (value) => validateNotEmpty(value, "Description"),
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                value: _chatenabled,
                title: Text("Enable Chat", style: text.bodyMedium),
                onChanged: (bool? value) {
                  setState(() {
                    _chatenabled = value ?? false;
                  });
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final imageBytes =
                      await ImagepickerWebHelper.pickImageFromGallery();
                  if (imageBytes != null) {
                    setState(() {
                      _selectedImage = imageBytes;
                    });
                  } else {
                    showTerminalSnackbar(
                        context, "Failed to pick image",
                        isError: true);
                  }
                },
                child: Center(
                  child: SizedBox(
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(8),
                              image: _selectedImage != null
                                  ? DecorationImage(
                                      image: MemoryImage(_selectedImage!),
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                            child: _selectedImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 50,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : null,
                          ),
                          if (_selectedImage != null)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showTerminalSnackbar(context, 'Session created successfully' , isError: false);
                          navigate(context, Livesession());
                        }
                        else{
                          showTerminalSnackbar(context, 'Failed to create session. Please try again' , isError: true);
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: text.bodyMedium,
                        minimumSize: Size(0, 50),
                      ),
                      child: Text('Start Session'),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: text.bodyMedium,
                        minimumSize: Size(0, 50),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

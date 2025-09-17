import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:termview/data/notifiers/post_notifier.dart';
import 'package:termview/data/providers/login_provider.dart';
import 'package:termview/data/providers/post_provider.dart';
import 'package:termview/helpers/imagepicker_web_helper.dart';
import 'package:termview/helpers/randomfilename.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/livesession.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Createsession extends ConsumerStatefulWidget {
  const Createsession({super.key});

  @override
  ConsumerState<Createsession> createState() => _CreatesessionState();
}

class _CreatesessionState extends ConsumerState<Createsession> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  bool _chatenabled = false;
  Uint8List? _selectedImage;
  bool islive = true;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final poststate = ref.watch(PostnotiferProvider);

    ref.listen<PostState>(PostnotiferProvider, (previous, next) {
      if (next.message != null && next.message != previous?.message) {
        showTerminalSnackbar(context, next.message!, isError: false);
        navigate(
            context,
            Livesession(
              postId: next.postId!,
              title: next.title!,
              description: next.description!,
              link: next.link!,
              ses_id: next.ses_id,
              chat: next.chat,
            ));
      } else if (next.error != null && next.error != previous?.error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showTerminalSnackbar(context, next.error!, isError: true);
          return;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: BackButton(),
        title: Text('Create New Session', style: text.bodyLarge),
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
                    child: poststate.loading
                        ? Center(
                            child:
                                SpinKitFadingFour(color: Colors.white),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                showTerminalSnackbar(context,
                                    'Failed to create session. Please try again',
                                    isError: true);
                                return;
                              }
                              if (_selectedImage == null) {
                                showTerminalSnackbar(context,
                                    "No thumbnail selected", isError: true);
                                return;
                              }

                              final token = await ref
                                  .read(LoginnotifierProvider.notifier)
                                  .getToken();
                              if (token == null) {
                                showTerminalSnackbar(context,
                                    "User not logged in", isError: true);
                                return;
                              }

                              String fileName = generateRandomFileName();
                              ref.read(PostnotiferProvider.notifier).post(
                                    title: _title.text,
                                    desc: _desc.text,
                                    enableChat: _chatenabled,
                                    fileBytes: _selectedImage!,
                                    fileName: fileName,
                                    token: token,
                                    islive: islive,
                                  );
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

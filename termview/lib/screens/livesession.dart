  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import 'package:termview/data/notifiers/endsession_notifier.dart';
  import 'package:termview/data/providers/endsession_provider.dart';
  import 'package:termview/data/providers/sessionControllerProvider.dart';
  import 'package:termview/data/providers/session_state_provider.dart';
  import 'package:termview/helpers/end.dart';
  import 'package:termview/helpers/sharesession.dart';
  import 'package:termview/screens/createquiz.dart';
  import 'package:termview/screens/homescreen.dart';
  import 'package:termview/screens/showlivechat.dart';
  import 'package:termview/widgets/page_transition.dart';
  import 'package:termview/widgets/snackbar.dart';

  class Livesession extends ConsumerStatefulWidget {
    final String? postId;
    final String? title;
    final String? description;
    final String? link;
    final String? ses_id;
    final bool? chat;

    Livesession({
      this.postId,
      this.title,
      this.description,
      this.link,
      this.ses_id,
      this.chat,
      super.key,
    });

    @override
    ConsumerState<Livesession> createState() => _LivesessionState();
  }

  class _LivesessionState extends ConsumerState<Livesession> {
    final TextEditingController _command = TextEditingController();
    final FocusNode _terminalfocus = FocusNode();
    final ScrollController _scrollController = ScrollController();
    final _storage = const FlutterSecureStorage();

    @override   
    void initState(){
      super.initState();
      Future.microtask(()async{
        final token =await _storage.read(key: 'access_token');
        
        if(widget.ses_id != null && token != null){
          ref.read(Sessioncontrollerprovider).connect('wss://termview-backend.onrender.com/ws/${widget.ses_id}?token=$token');
        }
        else{
          showTerminalSnackbar(context, "Either sessionId or token is null. Please try again",isError: true);
          return;
        }
      });
    }

    @override   
    void dispose(){
      ref.read(Sessioncontrollerprovider).disconnect();
      _command.dispose();
      _terminalfocus.dispose();
      _scrollController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final text = Theme.of(context).textTheme;
      final sessionstate = ref.watch(sessionnotifierProvider);
      ref.listen<EndState>(endsessionnotifierProvider, (previous, next) {
        if (next.message != null && next.message != previous?.message) {
          showTerminalSnackbar(context, next.message!, isError: false);
          navigate(context, Homescreen());
        } else if (next.error != null && next.error != previous?.error) {
          showTerminalSnackbar(context, next.error!, isError: true);
        }
      });

      ref.listen<SessionState>(sessionnotifierProvider, (previous, next) {
        if ((previous?.commands.length ?? 0) != next.commands.length) {
          if (_scrollController.hasClients) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            });
          }
        }
      });


      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          toolbarHeight: 70,
          titleSpacing: 0,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title ?? "Can't get title",
                style: text.bodyLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                widget.description ?? "Can't get description",
                style: text.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                    child: Text((sessionstate.joined ?? 0).toString())
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.link != null) {
                        sharesession(context, link: widget.link!);
                      } else {
                        showTerminalSnackbar(context, "No link available",
                            isError: false);
                      }
                    },
                    style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                    child: const Text("Share Session"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigate(context, Createquiz());
                    },
                    style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                    child: const Text("Create Quiz"),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if(widget.chat ?? false) 
                      ElevatedButton(
                        onPressed: () {
                          navigate(context, Showlivechat());
                          ref.read(sessionnotifierProvider.notifier).resetChatIndicator();
                        },
                        style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                        child: const Text("Chats"),
                      ),

                      if(sessionstate.haschat)
                      Positioned(
                        right: -2,
                        top : -2,
                        child: Container(
                          width: 10,
                          height: 10 ,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle
                          ),
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      endsession(context, ref , widget.postId!);
                    },
                    style: ElevatedButton.styleFrom(
                        textStyle: text.bodyMedium,
                        backgroundColor: Colors.red),
                    child: const Text("End Session"),
                  ),
                ],
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                flex: 3,  
                child: Container(
                  width: double.infinity,
                  color: Colors.black87,
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: sessionstate.commands.length,
                    itemBuilder: (context, index) {
                      final command = sessionstate.commands[index];
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${command['command'] ?? ''} ',
                              style: text.bodyMedium!.copyWith(color: Colors.orangeAccent), // command color
                            ),
                            TextSpan(
                              text: '>>>>>> ',
                              style: text.bodyMedium!.copyWith(color: Colors.white), // separator color
                            ),
                            TextSpan(
                              text: '${command['result']?['output'] ?? ''}',
                              style: text.bodyMedium!.copyWith(color: Colors.greenAccent), // result color
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _command,
                      cursorHeight: 22,
                      style: text.bodyMedium,
                      focusNode: _terminalfocus,
                      decoration: const InputDecoration(
                        hintText: "Enter commands",
                      ),
                      onSubmitted: (_) {
                        final commandText = _command.text.trim();
                      if(commandText.isNotEmpty){
                        ref.read(Sessioncontrollerprovider).sendCommand(commandText);
                        _command.clear();
                        _terminalfocus.requestFocus();
                      }
                      
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final commandText = _command.text.trim();
                      if(commandText.isNotEmpty){
                        ref.read(Sessioncontrollerprovider).sendCommand(commandText);
                        _command.clear();
                        _terminalfocus.requestFocus();
                      }
                      
                    },
                    style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                    child: const Text('Send'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }

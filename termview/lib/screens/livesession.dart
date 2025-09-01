import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:termview/data/notifiers/endsession_notifier.dart';
import 'package:termview/data/providers/endsession_provider.dart';
import 'package:termview/helpers/endsession.dart';
import 'package:termview/helpers/sharesession.dart';
import 'package:termview/screens/createquiz.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/showlivechat.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Livesession extends ConsumerStatefulWidget {
  String? postId;
  String? title;
  String? description;
  String? link;
  Livesession({this.postId,this.title,this.description,this.link,super.key});

  @override
  ConsumerState<Livesession> createState() => _LivesessionState();
}

class _LivesessionState extends ConsumerState<Livesession> {
  final TextEditingController _command = TextEditingController();
  final FocusNode _terminalfocus = FocusNode();
  final List<String> _terminalLines = [];
  final ScrollController _scrollController = ScrollController();


  void _sendCommand() {
    if (_command.text.isNotEmpty) {
      setState(() {
        _terminalLines.add("> ${_command.text}");
        _command.clear();
        _terminalfocus.requestFocus();
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final endstate = ref.watch(endsessionnotifierProvider);
    ref.listen<EndState>(endsessionnotifierProvider , (previous , next){
      if(next.message != null && next.message != previous?.message){
        showTerminalSnackbar(context, next.message! , isError: false);
        navigate(context, Homescreen());
      }
      else if(next.error != null && next.error != previous?.error){
        showTerminalSnackbar(context, next.error! , isError: true);
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
            padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
            ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
            child: const Text("10 Joined"),
                      ),
                      ElevatedButton(
            onPressed: () {
              if(widget.link != null){
              sharesession(context, link: widget.link!);
            }
            else{
              showTerminalSnackbar(context, "No link available" , isError: false);
            }},
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
                      ElevatedButton(
            onPressed: () {
              navigate(context, Showlivechat());
            },
            style: ElevatedButton.styleFrom(textStyle: text.bodyMedium),
            child: const Text("Chats"),
                      ),
                      ElevatedButton(
            onPressed: () {
              if(widget.postId != null){
              endsession(context, ref, widget.postId!);
                      
              }
            },
            style: ElevatedButton.styleFrom(
                textStyle: text.bodyMedium, backgroundColor: Colors.red),
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
                  itemCount: _terminalLines.length,
                  itemBuilder: (context, index) {
                    return Text(
                      _terminalLines[index],
                      style: text.bodyMedium!
                          .copyWith(color: Colors.greenAccent),
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
                    onSubmitted: (_) => _sendCommand(), // <-- Enter key
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendCommand, // <-- Send button
                  style:
                      ElevatedButton.styleFrom(textStyle: text.bodyMedium),
                  child: const Text('Send'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
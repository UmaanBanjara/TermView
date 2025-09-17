import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:termview/data/providers/fetchall_provider.dart';
import 'package:termview/helpers/join.dart';
import 'package:termview/screens/createsession.dart';
import 'package:termview/screens/settings.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fetchallnotifierProvider.notifier).fetchall();
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final fetchstate = ref.watch(fetchallnotifierProvider);
    final sessions = fetchstate.sessions ?? [];

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
      body: fetchstate.loading
          ? const Center(
              child: SpinKitFadingFour(color: Colors.white),
            )
          : fetchstate.error != null
              ? Center(child: Text(fetchstate.error!))
              : sessions.where((s) => s.is_live).isEmpty
                  ?  Center(
                      child: Text(
                        "NO LIVE SESSIONS CURRENTLY",
                        style: text.bodyMedium,
                      ),
                    )
                  : ListView.builder(
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
                                session.thumbnail,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(session.title, style: text.bodyMedium),
                            subtitle: Text("Author: ${session.username}"),
                            trailing: SizedBox(
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: session.is_live
                                            ? Colors.green
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          session.is_live ? "LIVE" : "OFFLINE",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: session.is_chat
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          session.is_chat
                                              ? "CHAT ENABLED"
                                              : "CHAT OFF",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: ()async {
                              // if connection is meade then navigate to joined sessoin page or else thrown an error
                              if(session.session_id.isEmpty){
                                showTerminalSnackbar(context, "SessionID not found. Please try again" , isError: true);

                              }
                              else{
                                joinsession(context, ref, session.session_id , session.title , session.desc , session.is_chat);
                              }
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}

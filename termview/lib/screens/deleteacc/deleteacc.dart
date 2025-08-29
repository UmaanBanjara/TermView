import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:termview/data/notifiers/delacc_notifier.dart';
import 'package:termview/data/providers/delacc_provider.dart';
import 'package:termview/data/providers/login_provider.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Deleteacc extends ConsumerStatefulWidget {
  const Deleteacc({super.key});

  @override
  ConsumerState<Deleteacc> createState() => _DeleteaccState();
}

class _DeleteaccState extends ConsumerState<Deleteacc> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final delstate = ref.watch(delaccnotifierProvider);
   ref.listen<DelaccState>(delaccnotifierProvider, (previous, next) {
    if (next.message != null && next.message != previous?.message) {
        showTerminalSnackbar(context, next.message!, isError: false);
        navigate(context, Loginscreen());
    } else if (next.error != null && next.error != previous?.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showTerminalSnackbar(context, next.error!, isError: true);
      });
    }
  });

    return Scaffold(
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delete Account' , style: text.bodyLarge,),
              SizedBox(height: 10,),
              TextFormField(
                controller: _pass,
                cursorHeight: 22,
                obscureText: true,
                style : text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                ),
                validator: (value) => validatePassword(value),
              ),
              
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: 
                    delstate.loading ? Center(child: SpinKitFadingFour(color : Colors.white),)
                    :
                    ElevatedButton(onPressed: ()async{
                      if(_formkey.currentState!.validate()){
                        final token = await ref.read(LoginnotifierProvider.notifier).getToken();
                        if(token == null){
                          showTerminalSnackbar(context, "Invalid Token" , isError: true);
                          return;
                        }
                        ref.read(delaccnotifierProvider.notifier).delacc(old_p: _pass.text , token: token);
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50),
                    )
                    ,child: Text('Delete account')),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50)
                    )
                    ,child: Text('Cancel')),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
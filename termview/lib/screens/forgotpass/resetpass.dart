import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:termview/data/notifiers/forpass_notifier.dart';
import 'package:termview/data/providers/forpass_provider.dart';
import 'package:termview/data/providers/login_provider.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/widgets/snackbar.dart';

class Resetpass extends ConsumerStatefulWidget {
  const Resetpass({super.key});

  @override
  ConsumerState<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends ConsumerState<Resetpass> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _old = TextEditingController();
  final TextEditingController _new = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final forstate = ref.watch(ForpassnotifierProvider);
    ref.listen<ForpassState>(ForpassnotifierProvider, (previous , next){
      if(next.message != null && next.message != previous?.message){
        showTerminalSnackbar(context, next.message! , isError: false);
        Navigator.pop(context);
      }
      else if (next.error != null && next.error != previous?.error){
        WidgetsBinding.instance.addPostFrameCallback((_){
        showTerminalSnackbar(context, next.error! , isError: true);
        return;
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
              Text('Change Password' , style: text.bodyLarge,),
              SizedBox(height: 10,),
              TextFormField(
                controller: _old,
                cursorHeight: 22,
                obscureText: true,
                style : text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter old password",
                ),
                validator: (value) => validatePassword(value),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _new,
                cursorHeight: 22,
                style: text.bodyMedium,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter new password",
                ),
                validator: (value) => validatePassword(value),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: 
                    forstate.loading ? Center(child: SpinKitFadingFour(color: Colors.white,),)
                    :
                    ElevatedButton(onPressed: ()async{
                      if(_formkey.currentState!.validate()){
                        final token = await ref.read(LoginnotifierProvider.notifier).getToken();
                        if(token == null){
                          showTerminalSnackbar(context, "User not logged in " , isError: true);
                          return;
                        }
                        await ref.read(ForpassnotifierProvider.notifier).forpass(old_p: _old.text, new_p: _new.text, token: token);

                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50),
                    )
                    ,child: Text('Update')),
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
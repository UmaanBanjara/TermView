import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:termview/data/notifiers/login_notifier.dart';
import 'package:termview/data/providers/login_provider.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/forgotpass/sendemail.dart';
import 'package:termview/screens/homescreen.dart';
import 'package:termview/screens/signupscreen.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Loginscreen extends ConsumerStatefulWidget {
  const Loginscreen({super.key});

  @override
  ConsumerState<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
      final loginstate = ref.watch(LoginnotifierProvider);

      ref.listen<LoginState>(LoginnotifierProvider , (previous , next){
        
        if(next.message != null && next.message != previous?.message){
          showTerminalSnackbar(context, next.message! , isError: false);
          navigate(context, Homescreen());
        } else if(next.error != null && next.error != previous?.error){
          WidgetsBinding.instance.addPostFrameCallback((_){
            showTerminalSnackbar(context, next.error! , isError: true);
            return;
          });
        }
      });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        leading: BackButton(),
        title: Text('Login to continue to TermView' , style: text.bodyLarge,),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _email,
                  cursorHeight: 22,
                  style: text.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    
                  ),
                  validator: (value) => validateEmail(value),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: _password,
                  cursorHeight: 22,
                  obscureText: true,
                  style: text.bodyMedium,
                  decoration: InputDecoration(
                    hintText: "Enter your password"
                  ),
                  validator: (value) => validatePassword(value),
                ),
            
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:
                      loginstate.loading ? Center(child: SpinKitFadingFour(color: Colors.white,))
                      :
                      ElevatedButton(onPressed: ()async{
                      if(_formkey.currentState!.validate()){
                       await ref.read(LoginnotifierProvider.notifier).login(_email.text, _password.text);
                      }
                      }, 
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 50),
                        textStyle: text.bodyMedium
                      )
                      ,child: Text("Login")),
                    ), 
            
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      navigate(context, Signupscreen());
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50)
                    )
                    ,child: Text('Signup?')),
                  ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(onPressed: (){
                      navigate(context, Sendemail());
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                    )
                    ,child: Text('Forgot Password?'))
                  ],
                )
              ],
            ),
          ),
        
        ),
      ),
    );
  }
}
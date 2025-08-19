import 'package:flutter/material.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/signupscreen.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Login to continue to TermView' , style: text.bodyLarge,),
              SizedBox(height: 10,),
              TextFormField(
                controller: _login,
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
                    child: ElevatedButton(onPressed: (){
                    if(_formkey.currentState!.validate()){
                      showTerminalSnackbar(context, "Login successful" , isError: true);
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
              )
            ],
          ),
        ),

      ),
    );
  }
}
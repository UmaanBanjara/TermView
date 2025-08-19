import 'package:flutter/material.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _first = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
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
              Text('SignUp to continue to TermView' , style: text.bodyLarge,),
              SizedBox(height: 10,),
              TextFormField(
                controller: _first,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter your first name",
                  
                ),
                validator: (value) =>  validateName(value, 'First Name'),
                
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _lname,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter your last name"
                ),
                validator: (value) => validateName(value, 'Last Name'),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _username,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter your username"
                ),
                validator: (value) => validateUsername(value),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _email,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter your email "
                ),
                validator: (value) => validateEmail(value),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _pass,
                cursorHeight: 22,
                
                obscureText: true,
                style: text.bodyMedium,
                
                decoration: InputDecoration(
                  hintText: "Enter your password ",
                  
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
                        showTerminalSnackbar(context, "SignUp successful" , isError: false);
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(0, 50),
                      textStyle: text.bodyMedium
                    )
                    ,child: Text("Signup")),
                  ), 
          
                SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(onPressed: (){
                    navigate(context, Loginscreen());
                  }, 
                  style: ElevatedButton.styleFrom(
                    textStyle: text.bodyMedium,
                    minimumSize: Size(0, 50)
                  )
                  ,child: Text('Login?')),
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
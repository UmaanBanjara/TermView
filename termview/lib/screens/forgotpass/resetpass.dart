import 'package:flutter/material.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/loginscreen.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _new = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
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
              Text('Enter new and confirm your password' , style: text.bodyLarge,),
              SizedBox(height: 10,),
              TextFormField(
                controller: _new,
                cursorHeight: 22,
                obscureText: true,
                style : text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter new password",
                ),
                validator: (value) => validatePassword(value),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _confirm,
                cursorHeight: 22,
                style: text.bodyMedium,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm your password",
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
                        showTerminalSnackbar(context, 'Update Clicked' , isError: false);
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
                      navigate(context, Loginscreen());
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
import 'package:flutter/material.dart';
import 'package:termview/helpers/validators.dart';
import 'package:termview/screens/forgotpass/resetpass.dart';
import 'package:termview/widgets/page_transition.dart';
import 'package:termview/widgets/snackbar.dart';

class Sendemail extends StatefulWidget {
  const Sendemail({super.key});

  @override
  State<Sendemail> createState() => _SendemailState();
}

class _SendemailState extends State<Sendemail> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your email associated with your account' , style: text.bodyLarge,),
              SizedBox(height: 10,),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      if(_formkey.currentState!.validate()){
                      showTerminalSnackbar(context, 'Send email clicked' , isError: false);
                      navigate(context, Resetpass());
                      }
                      
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium
                    )
                    ,child: Text('Send email')),
                  ),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium
                    )
                    ,child: Text('Back')),
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
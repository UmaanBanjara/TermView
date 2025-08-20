  import 'package:flutter/material.dart';

  class Createsession extends StatefulWidget {
    const Createsession({super.key});

    @override
    State<Createsession> createState() => _CreatesessionState();
  }

  class _CreatesessionState extends State<Createsession> {
    final TextEditingController _title = TextEditingController();
    final TextEditingController _desc = TextEditingController();
    @override
    Widget build(BuildContext context) {
      final text = Theme.of(context).textTheme;
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create New Session' , style: text.bodyLarge,),
              SizedBox(height: 10,),
              TextField(
                controller: _title,
                maxLines: 1,
                cursorHeight: 22,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter the title of this session"
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                cursorHeight: 22,
                maxLines: null,
                controller: _desc,
                style: text.bodyMedium,
                decoration: InputDecoration(
                  hintText: "Enter the description of this session"
                ),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    
                    child: ElevatedButton(onPressed: (){

                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50)
                    )
                    ,child: Text('Start Session')),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, 
                    style: ElevatedButton.styleFrom(
                      textStyle: text.bodyMedium,
                      minimumSize: Size(0, 50),
                    )
                    ,child: Text('Cancel')),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
  }
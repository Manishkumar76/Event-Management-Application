import 'package:flutter/material.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(

                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.title_rounded),
                    hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color:Colors.purple
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "Description ",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                   decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderSide: const BorderSide(width: 1,color: Colors.purple),
                       borderRadius: BorderRadius.circular(11)
                     )
                   ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

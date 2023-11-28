// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AddPhoto extends StatelessWidget {
  const AddPhoto({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 150,
              width: 150,
              child: FittedBox(
                child: FloatingActionButton(
                child: const Center(child: Icon(Icons.add_a_photo_outlined,size: 50,)),
                onPressed: (){},),
              ),
            ),
            const Text('Add Clicks',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),)

          ]
        ),
      ),
    );
  }
}

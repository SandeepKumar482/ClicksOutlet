// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';


class MySearchBar extends StatelessWidget {
  MySearchBar({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color:const Color.fromARGB(66, 192, 192, 192),
            border: Border.all(color:const Color.fromARGB(33, 13, 5, 5)),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search Photos",
                  hintStyle: TextStyle(color: Colors.black87),
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             SearchScreen(query: _searchController.text)));
                },
                child:const Icon(Icons.search))
          ],
        ));
  }
}

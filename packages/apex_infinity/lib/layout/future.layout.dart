import 'package:apex_infinity/apex_infinity.dart';
import 'package:apex_infinity/http/response.dart';
import 'package:flutter/material.dart';

class AxFutureBuilder extends StatefulWidget {

  final Future Function()? future;
  final Future Function()? onRetry;
  final Widget Function(dynamic data) childBuilder;

  const AxFutureBuilder({
    required this.childBuilder,
    this.future,
    this.onRetry,
});

  @override
  State<AxFutureBuilder> createState() => _AxFutureBuilderState();
}

class _AxFutureBuilderState extends State<AxFutureBuilder> {

  Future? _future;

  @override
  void initState() {
    _callFuture();
    super.initState();
  }

  void _callFuture() {
    if(widget.future != null) {
      _future = widget.future!();
    } else {
      _future = Future.delayed(Duration.zero);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _future ,
      builder: (BuildContext ctx,AsyncSnapshot snapShot) {
        if(snapShot.hasData) {
          final dynamic data = snapShot.data;

          if(data is AxHttpResponse) {
            if(data.status) {
              return RefreshIndicator(
                child:widget.childBuilder(data.data) ,
                onRefresh: () async {
                  _callFuture();
                }
              );
            } else {
              return Text( data.msg ?? "Something Went Wrong");
            }
          } else {
            return widget.childBuilder(snapShot.data);
          }
        } else if(snapShot.hasError) {
          return const Text("Error");
        } else {
          return const Column(
            children: [
              SizedBox(height: 150.0,),
              CircularProgressIndicator(),
            ],
          );
        }
      }
    );
  }
}

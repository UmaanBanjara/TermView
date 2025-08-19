import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Future<T?> navigate<T>(
  BuildContext context ,
  Widget page,
  {
    PageTransitionType type = PageTransitionType.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    Duration reverseDuration = const Duration(milliseconds: 300)


  }
){
    return Navigator.push(context, PageTransition(
      type: type,
      duration: duration,
      reverseDuration: reverseDuration,
      child: page,
    ));
}
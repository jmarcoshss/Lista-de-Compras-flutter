import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void transition (BuildContext context, Widget page){
  Navigator.push(context, PageTransition(child: page, type: PageTransitionType.bottomToTop));
}
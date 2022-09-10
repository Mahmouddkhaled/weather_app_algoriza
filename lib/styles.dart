import 'package:flutter/material.dart';

TextStyle buildTextStyle ({ double? size , Color? color , FontWeight?  fontWeight }){
  return TextStyle(fontSize: size ?? 16, color:color ?? Colors.white , fontWeight:  fontWeight ?? FontWeight.normal);
}
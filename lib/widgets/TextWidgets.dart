import 'package:flutter/material.dart';

///
/// Created by  on 11/25/2020.
/// TextWidgets.dart : 
///
 Widget singleLineInputFormField(){
   final _minimumPadding = 5.0;
  return Padding(
      padding: EdgeInsets.only(
          top: _minimumPadding, bottom: _minimumPadding),
      child: TextFormField(
       // style: textStyle,
       // controller: _roiController,
       validator: (String value) {
        if (value.isEmpty || double.tryParse(value) == null)
         return 'Please Enter the Rate Of Interest';
        return null;
       },
       keyboardType: TextInputType.number,
       decoration: InputDecoration(
           hintText: 'Please Enter Rate of interest',
           errorStyle: TextStyle(
               color: Colors.yellowAccent, fontSize: 15.0),
           labelText: 'Rate of Interest',
           border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(5))),
      ));
 }
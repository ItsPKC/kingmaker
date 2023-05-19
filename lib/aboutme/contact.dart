// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PhoneNumberField extends StatefulWidget {
//   const PhoneNumberField({Key? key}) : super(key: key);

//   @override
//   PhoneNumberFieldState createState() => PhoneNumberFieldState();
// }

// class PhoneNumberFieldState extends State<PhoneNumberField> {
//   setUpCountryCode() async {
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     var temp = _prefs.getString('countryCode') ?? '91';
//     setState(() {
//       _countryCode = temp;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     setUpCountryCode();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: (MediaQuery.of(context).size.width - 45) * 0.3,
//           alignment: Alignment.center,
//           // color: Color.fromRGBO(0, 0, 0, 0.5),
//           margin: EdgeInsets.fromLTRB(15, 0, 7.5, 0),
//           child: GestureDetector(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Color.fromRGBO(255, 255, 255, 1),
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(
//                   color: Color.fromRGBO(255, 0, 0, 1),
//                   width: 1.25,
//                 ),
//               ),
//               height: 55,
//               width: (MediaQuery.of(context).size.width - 45) * 0.3,
//               alignment: Alignment.center,
//               child: Text(
//                 '+ $_countryCode',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontFamily: 'Signika',
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//             ),
//             onTap: () {
//               showCountryPicker(
//                 context: context,
//                 //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
//                 // exclude: <String>['KN', 'MF'],
//                 //Optional. Shows phone code before the country name.
//                 showPhoneCode: true,
//                 onSelect: (Country country) async {
//                   print('Select country: ${country.displayName}');
//                   _countryCode = country.phoneCode;
//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   await prefs.setString('countryCode', _countryCode);
//                   setState(() {});
//                 },
//               );
//             },
//           ),
//         ),
//         Container(
//           width: (MediaQuery.of(context).size.width - 45) * 0.7,
//           height: 55,
//           decoration: BoxDecoration(
//             // color: Colors.tealAccent,
//             color: Color.fromRGBO(255, 255, 255, 1),
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(
//               color: Color.fromRGBO(255, 0, 0, 1),
//               width: 1.25,
//             ),
//           ),
//           margin: EdgeInsets.fromLTRB(7.5, 0, 15, 0),
//           padding: EdgeInsets.all(10),
//           child: Center(
//             child: TextFormField(
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'\d')),
//               ],
//               onChanged: (value) {
//                 contactNumber = value;
//               },
//               // maxLength: 15,
//               style: TextStyle(
//                 fontSize: 28,
//                 fontFamily: 'Signika',
//                 fontWeight: FontWeight.w700,
//                 letterSpacing: 2,
//               ),
//               textAlign: TextAlign.left,
//               cursorColor: Colors.red,
//               decoration: InputDecoration(
//                 hintText: 'Any Contact',
//                 hintStyle: TextStyle(
//                   fontFamily: 'Signika',
//                   fontSize: 28,
//                   fontWeight: FontWeight.w700,
//                   color: Color.fromRGBO(0, 0, 0, 0.15),
//                 ),
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 // contentPadding: EdgeInsets.fromLTRB(15, 20, 11, 0),
//                 isCollapsed: true,
//                 isDense: false,
//               ),
//               keyboardType: TextInputType.number,
//               toolbarOptions: ToolbarOptions(
//                 copy: true,
//                 cut: true,
//                 paste: true,
//                 selectAll: true,
//               ),
//               cursorWidth: 3,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

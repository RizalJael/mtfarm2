// // FILEPATH: /d:/flutter_pro/mtfarm/mtfarm/lib/app_shell.dart

// import 'package:flutter/material.dart';
// import 'widgets/views/home.dart';
// import 'widgets/views/populasi/populasi_view.dart';
// import 'widgets/views/mortal/mortal_view.dart';
// import 'widgets/views/potong/potong_view.dart';

// class AppShell extends StatefulWidget {
//   const AppShell({Key? key}) : super(key: key);

//   @override
//   _AppShellState createState() => _AppShellState();
// }

// class _AppShellState extends State<AppShell> {
//   int _selectedIndex = 0;
//   static const List<Widget> _widgetOptions = <Widget>[
//     Home(),
//     PopulasiView(),
//     MortalView(),
//     PotongView(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.pets),
//             label: 'Populasi',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.warning),
//             label: 'Mortalitas',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.cut),
//             label: 'Potong',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Color(0xFF0961F6),
//         unselectedItemColor: Colors.grey,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

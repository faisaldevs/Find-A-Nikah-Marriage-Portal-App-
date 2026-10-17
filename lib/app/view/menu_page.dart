// Replaced by features/menu (Figma "menu" flow): MenuPage now lives in
// lib/features/menu/presentation/view/menu_page.dart, and Sign out moved to
// Settings → Manage account. Kept for reference.
//
// import 'package:find_a_nikah/core/ui/ui.dart';
// import 'package:find_a_nikah/features/auth/presentation/presentation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
//
// /// Menu tab. Settings, account and support land here later; for now it
// /// holds Sign out (the session now survives app restarts).
// class MenuPage extends StatelessWidget {
//   const MenuPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Menu')),
//       body: ListView(
//         padding: EdgeInsets.symmetric(vertical: 8.h),
//         children: [
//           ListTile(
//             leading: const Icon(Icons.logout_rounded),
//             title: Text(
//               'Sign out',
//               style: TextFontStyle.headline16w600textDarkStyleSatoshi,
//             ),
//             onTap: () =>
//                 context.read<AuthBloc>().add(const AuthSignOutRequested()),
//           ),
//         ],
//       ),
//     );
//   }
// }

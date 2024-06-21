import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error_screen.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/features/group/screens/create_group_screen.dart';
import 'package:whatsapp/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/features/status/screens/add_status_screen.dart';
import 'package:whatsapp/features/status/screens/status_view_screen.dart';
import 'package:whatsapp/mobile_layout_screen.dart';
import 'package:whatsapp/models/status.dart';

Route<dynamic> generateRoute(RouteSettings setttings) {
  switch (setttings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case OTPScreen.routeName:
      final verificationId = setttings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );

    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );

    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );

    case MobileChatScreen.routeName:
      final arguments = setttings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
        ),
      );

    case AddStatusScreen.routeName:
      final file = setttings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => AddStatusScreen(
          file: file,
        ),
      );

    case StatusViewScreen.routeName:
      final status = setttings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusViewScreen(
          status: status,
        ),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist!'),
        ),
      );
  }
}

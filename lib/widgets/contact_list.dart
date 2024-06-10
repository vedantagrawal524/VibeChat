import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/screens/mobile_chat_screen.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MobileChatScreen.routeName,
                    arguments: {
                      'name': 'N',
                      'uid': 'U',
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: ListTile(
                    title: Text(
                      info[index]['name'].toString(),
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        info[index]['message'].toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        info[index]['profilePic'].toString(),
                      ),
                    ),
                    trailing: Text(
                      info[index]['time'].toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: dividerColor,
                indent: 85,
                height: 9.5,
                thickness: 0.8,
              )
            ],
          );
        },
      ),
    );
  }
}

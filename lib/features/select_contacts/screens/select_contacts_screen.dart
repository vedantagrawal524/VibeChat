import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/data.dart';
import 'package:whatsapp/common/widgets/error_screen.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});
  static const routeName = '/select-contact-screen';

  void selectContact(
      BuildContext context, WidgetRef ref, Contact selectedContact) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(context, ref, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.5, bottom: 3),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 16),
                      ),
                      leading: contact.photo == null
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage(
                                defaultImage,
                              ),
                              radius: 23,
                            )
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 23,
                            ),
                    ),
                  ),
                );
              },
            ),
            error: (e, stackTrace) => ErrorScreen(error: e.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

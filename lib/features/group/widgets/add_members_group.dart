import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/data.dart';
import 'package:whatsapp/common/widgets/error_screen.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupMembers = StateProvider<List<Contact>>(
  (ref) => [],
);

class AddMembersGroup extends ConsumerStatefulWidget {
  const AddMembersGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddMembersGroupState();
}

class _AddMembersGroupState extends ConsumerState<AddMembersGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact selectedContact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref.read(selectedGroupMembers.notifier).update(
          (state) => [...state, selectedContact],
        );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(index, contact),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.5, bottom: 3),
                    child: ListTile(
                      selected: selectedContactsIndex.contains(index),
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
                      trailing: selectedContactsIndex.contains(index)
                          ? const Icon(Icons.done)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          error: (e, stackTrace) => ErrorScreen(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}

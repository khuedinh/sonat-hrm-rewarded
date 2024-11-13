import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';

class SelectMoreRecipient extends StatefulWidget {
  const SelectMoreRecipient({
    super.key,
    required this.isLoading,
    required this.listEmployees,
    required this.initSelectedRecipients,
  });

  final bool isLoading;
  final List<Employee> listEmployees;
  final List<Employee> initSelectedRecipients;

  @override
  State<SelectMoreRecipient> createState() => _SelectMoreRecipientState();
}

class _SelectMoreRecipientState extends State<SelectMoreRecipient> {
  String _search = "";
  final List<Employee> _selectedRecipient = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedRecipient.addAll(widget.initSelectedRecipients);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredListEmployees = widget.listEmployees.where((employee) {
      final name = employee.name.toLowerCase();
      final email = employee.email.toLowerCase();
      final search = _search.toLowerCase();
      return name.contains(search) || email.contains(search);
    }).toList();

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 560,
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Enter name or email",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                prefixIcon: Icon(Icons.search, size: 28),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
              onChanged: (value) => {
                setState(() {
                  _search = value;
                })
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList.builder(
                    itemCount: filteredListEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredListEmployees[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: employee.picture,
                              fit: BoxFit.cover,
                              width: 42,
                              height: 42,
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/default_avatar.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          employee.name,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Checkbox(
                          value: _selectedRecipient
                              .map((item) => item.id)
                              .contains(employee.id),
                          onChanged: (value) {
                            setState(() {
                              if (_selectedRecipient.contains(employee)) {
                                _selectedRecipient.remove(employee);
                                return;
                              }
                              _selectedRecipient.add(employee);
                            });
                          },
                        ),
                        subtitle: Text(employee.email),
                        onTap: () {
                          setState(() {
                            if (_selectedRecipient.contains(employee)) {
                              _selectedRecipient.remove(employee);
                              return;
                            }
                            _selectedRecipient.add(employee);
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(_selectedRecipient);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

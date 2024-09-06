import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/bloc/recognition_bloc.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';

class TeamFilters extends StatefulWidget {
  final List<Group> groups;
  final List<MemberGroup> selectedRecipients;
  final Function(List<MemberGroup>) onSelectedRecipientChanged;

  const TeamFilters({
    super.key,
    required this.groups,
    required this.selectedRecipients,
    required this.onSelectedRecipientChanged,
  });

  @override
  State<TeamFilters> createState() => _TeamFiltersState();
}

class _TeamFiltersState extends State<TeamFilters> {
  SortBy? _sortByFilter;
  TimeRange? _timeFilter;
  RecognitionType? _typeFilter;
  double _sliderValue = 50;
  int _selectedChipValue = 50;
  String _selectedRecognitionValue = 'Core values';
  dynamic _selectedRecipient;
  dynamic _searchedRecipient;
  bool isLoadingMembers = true;
  List<MemberGroup> detailedGroups = [];
  List<MemberGroup> _localSelectedRecipients = [];

  @override
  void initState() {
    super.initState();
    _localSelectedRecipients = List.from(widget.selectedRecipients);
  }

  Future<void> fetchDetailedGroup(String id) async {
    try {
      final groupResponse = await RecognitionApi.getGroupMembers(id);
      if (groupResponse != null && groupResponse['memberGroups'] is List) {
        final List<MemberGroup> memberGroups =
            (groupResponse['memberGroups'] as List).map((item) {
          return MemberGroup.fromJson(item as Map<String, dynamic>);
        }).toList();
        if (mounted) {
          setState(() {
            detailedGroups = memberGroups;
            isLoadingMembers = false;
          });
        }
        _updateSelectedRecipients(memberGroups);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingMembers = false;
        });
      }
    }
  }

  void _updateSelectedRecipients(List<MemberGroup> newRecipients) {
    setState(() {
      _localSelectedRecipients = newRecipients;
    });
    widget.onSelectedRecipientChanged(_localSelectedRecipients);
  }

  void _handleResetFilters() {
    setState(() {
      _timeFilter = null;
      _sortByFilter = null;
      _typeFilter = null;
    });
  }

  List<TextSpan> splitText(String text, int maxLength) {
    List<String> words = text.split(' ');
    List<TextSpan> spans = [];
    StringBuffer currentLine = StringBuffer();
    int currentLineCount = 0;

    for (String word in words) {
      if (currentLine.length + word.length + 1 > maxLength) {
        spans.add(TextSpan(text: '$currentLine\n'));
        currentLine.clear();
        currentLineCount++;
        if (currentLineCount >= 2) break;
      }
      if (currentLine.isNotEmpty) {
        currentLine.write(' ');
      }
      currentLine.write(word);
    }

    if (currentLine.isNotEmpty) {
      spans.add(TextSpan(text: currentLine.toString()));
    }

    if (currentLineCount >= 2) {
      String truncatedText = spans[1].text!.trim();
      if (truncatedText.length > maxLength - 3) {
        truncatedText = '${truncatedText.substring(0, maxLength - 3)}...';
      } else {
        truncatedText += '...';
      }
      spans[1] = TextSpan(text: truncatedText);
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Enter a member or group",
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
              onChanged: (text) {
                setState(() {
                  _searchedRecipient = text;
                });
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          _searchedRecipient == null
              ? const SliverToBoxAdapter(
                  child: Text("Recent recipients",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              : const SliverToBoxAdapter(
                  child: Text("Founded recipients",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(
              child: _searchedRecipient == null
                  ? Row(
                      children: widget.groups.map((user) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRecipient = user;
                                fetchDetailedGroup(user.id);
                              });
                            },
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  child: Icon(Icons.groups),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: splitText(user.name, 6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Row(
                      children: widget.groups
                          .where((user) => user.name.toLowerCase().contains(
                                  _searchedRecipient.toLowerCase()) //||
                              // user.email
                              //     .toLowerCase()
                              //     .contains(_searchedRecipient.toLowerCase())
                              )
                          .map((user) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRecipient = user;
                              });
                            },
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  child: Icon(Icons.person),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: splitText(user.name, 6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    )),
          SliverToBoxAdapter(
              child: _selectedRecipient != null
                  ? const SizedBox(height: 8)
                  : const SizedBox.shrink()),
          SliverToBoxAdapter(
              child: _selectedRecipient != null
                  ? ScreenTitle(
                      title: "Recipient",
                      color: theme.colorScheme.onSurface,
                    )
                  : const SizedBox.shrink()),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(
              child: _selectedRecipient == null
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.group),
                        ),
                        Text.rich(
                          TextSpan(
                            children: splitText(_selectedRecipient.name, 6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
              child: _selectedRecipient != null
                  ? const SizedBox.shrink()
                  : const Text("Members",
                      style: TextStyle(fontWeight: FontWeight.bold))),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          _localSelectedRecipients.isNotEmpty
              ? SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: _localSelectedRecipients.length,
                        itemBuilder: (context, index) {
                          final recognition = _localSelectedRecipients
                              .elementAt(index)
                              .employees;

                          return ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                radius: 24,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: (recognition.picture != null)
                                        ? recognition.picture
                                        : "",
                                    fit: BoxFit.cover,
                                    width: 48,
                                    height: 48,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/images/default_avatar.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(recognition.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                _updateSelectedRecipients(
                                    _localSelectedRecipients
                                        .where((element) =>
                                            element.employees.id !=
                                            recognition.id)
                                        .toList());
                              },
                            ),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                  ),
                )
              : const SliverToBoxAdapter(
                  child: SizedBox(),
                ),
        ],
      ),
    );
  }
}

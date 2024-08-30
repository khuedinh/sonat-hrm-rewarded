import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';

enum SortByFilter { latest, earliest }

enum TimeFilter { allTime, last7Days, last30Days, last60Days }

enum TypeFilter { all, p2p, team, eCard, award }

class TeamFilters extends StatefulWidget {
  const TeamFilters({super.key});

  @override
  State<TeamFilters> createState() => _TeamFiltersState();
}

class _TeamFiltersState extends State<TeamFilters> {
  SortByFilter? _sortByFilter;
  TimeFilter? _timeFilter;
  TypeFilter? _typeFilter;
  double _sliderValue = 50;
  int _selectedChipValue = 50;
  String _selectedRecognitionValue = 'Core values';
  dynamic _selectedRecipient;
  dynamic _searchedRecipient;

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
        child: CustomScrollView(shrinkWrap: true, slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Enter email or name',
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
                      children: listLeaderboard.sublist(1, 5).map((user) {
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
                    )
                  : Row(
                      children: listLeaderboard
                          .where((user) =>
                              user.name
                                  .toLowerCase()
                                  .contains(_searchedRecipient.toLowerCase()) ||
                              user.email
                                  .toLowerCase()
                                  .contains(_searchedRecipient.toLowerCase()))
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
                          child: Icon(Icons.person),
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
        ]));
  }
}

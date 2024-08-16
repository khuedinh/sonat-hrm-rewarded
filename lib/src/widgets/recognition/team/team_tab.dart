import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/recognition.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/widgets/recognition/team/team_filters.dart';

class TeamTab extends StatefulWidget {
  const TeamTab({super.key});

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  double _sliderValue = 50;
  int _selectedChipValue = 50;
  dynamic _selectedRecognitionValue = 'Core values';
  dynamic _selectedRecipient;
  dynamic _searchedRecipient;
  dynamic _isSavePresets = false;
  dynamic _isAllocateCustom = false;

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

    void handleOpenFilter() {
      showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) => const TeamFilters(),
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          title: const ScreenTitle(title: "Team recognition"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          height: 64,
          color: theme.colorScheme.surface,
          child: FilledButton(
            onPressed: () {},
            child: Text(
              'Send now',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 16,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                  child: ScreenTitle(
                title: "Recipients",
                color: theme.colorScheme.onSurface,
              )),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   // _selectedRecipient = user;
                        // });
                        handleOpenFilter();
                      },
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.add),
                          ),
                          Text.rich(
                            TextSpan(
                              children: splitText("Add recipient", 9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...listLeaderboard.sublist(1, 3).map((user) {
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
                  })
                ],
              )),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Text("Save this team's recipient preset"),
                    Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: _isSavePresets,
                        onChanged: (bool value) {
                          setState(() {
                            _isSavePresets = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenTitle(
                      title: 'Recognition Points',
                      color: theme.colorScheme.onSurface,
                    ),
                    //const SizedBox(height: 8),
                    Padding(
                        padding: EdgeInsets.zero,
                        child: Row(
                          children: [
                            Checkbox(
                              //tristate: true,
                              value: _isAllocateCustom,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAllocateCustom = value;
                                });
                              },
                            ),
                            const Text("Allocate custom for each team member"),
                          ],
                        )),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Points balanced: ",
                            style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        DisplayAmount(
                          amount: 100,
                          icon: Icons.currency_bitcoin_rounded,
                          suffix: "Points",
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${_sliderValue.toInt().toString()} Points",
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                          ),
                          child: Slider(
                            mouseCursor: WidgetStateMouseCursor.textable,
                            value: _sliderValue,
                            min: 5,
                            max: 150,
                            onChanged: (double value) {
                              setState(() {
                                _sliderValue = value;
                                if (_sliderValue != 50 &&
                                    _sliderValue != 100 &&
                                    _sliderValue != 150) {
                                  _selectedChipValue = -1;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Use slider to select the amount"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ChoiceChip(
                              label: const Text("50 Points"),
                              selected: _selectedChipValue == 50,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedChipValue = 50;
                                    _sliderValue = 50.toDouble();
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text("100 Points"),
                              selected: _selectedChipValue == 100,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedChipValue = 100;
                                    _sliderValue = 100.toDouble();
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text("150 Points"),
                              selected: _selectedChipValue == 150,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedChipValue = 150;
                                  _sliderValue = 150.toDouble();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200, // Set a fixed height for the ListView
                          child: ListView.builder(
                            itemCount: historyList.length,
                            itemBuilder: (context, index) {
                              final notification = historyList[index];
                              print(notification);
                              return ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
                                leading: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                                title: Text(
                                  notification.name,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "${50} points",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      iconSize: 16,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenTitle(
                        title: 'Recognition Value',
                        color: theme.colorScheme.onSurface,
                      ),
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          children: recognitionValue.map((v) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRecognitionValue = v;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<dynamic>(
                                    value: v,
                                    groupValue: _selectedRecognitionValue,
                                    onChanged: (dynamic value) {
                                      setState(() {
                                        _selectedRecognitionValue = value;
                                      });
                                    },
                                  ),
                                  Icon(v.icon),
                                  const SizedBox(width: 8),
                                  Text(v.name),
                                ],
                              ),
                            );
                          }).toList()),
                    ]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ));
  }
}

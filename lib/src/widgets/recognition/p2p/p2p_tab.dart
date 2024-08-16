import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/recognition.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/user.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';

class P2pTab extends StatefulWidget {
  const P2pTab({super.key});

  @override
  State<P2pTab> createState() => _P2pTabState();
}

class _P2pTabState extends State<P2pTab> {
  double _sliderValue = 50;
  int _selectedChipValue = 50;
  dynamic _selectedRecognitionValue = 'Core values';
  dynamic _selectedRecipient;
  dynamic _searchedRecipient;

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

      // Add ellipsis if text exceeds 2 lines
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

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          title: const ScreenTitle(title: "P2P recognition"),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                  user.name.toLowerCase().contains(
                                      _searchedRecipient.toLowerCase()) ||
                                  user.email.toLowerCase().contains(
                                      _searchedRecipient.toLowerCase()))
                              .map((user) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScreenTitle(
                      title: 'Recognition Points',
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(height: 8),
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
                      ],
                    ),
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
                            ;
                          }).toList()),
                    ]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(
                child: Text(
                  "Recognition Message",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              const SliverToBoxAdapter(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type message',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],
          ),
        ));
  }
}

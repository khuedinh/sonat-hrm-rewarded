import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';

class P2pTab extends StatefulWidget {
  const P2pTab({super.key});

  @override
  State<P2pTab> createState() => _P2pTabState();
}

class _P2pTabState extends State<P2pTab> {
  double _selectedPoints = 100;

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
          if (currentLineCount >= 2) break; // Allow up to 2 lines
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
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {
                // Add your filter action here
              },
            ),
          ],
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
              const SliverToBoxAdapter(
                child: TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(
                child: Text("Recent recipients",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        ),
                        Text.rich(
                          TextSpan(
                            children: splitText('Nguyen Thi Khanh Huyen', 10),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        ),
                        Text.rich(
                          TextSpan(
                            children: splitText('Do Duc Long', 10),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person),
                        ),
                        Text.rich(
                          TextSpan(
                            children: splitText('Nguyen Duc Vuong', 10),
                          ),
                          textAlign: TextAlign.center,
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
                          "${_selectedPoints.toInt().toString()} Points",
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
                            value: _selectedPoints,
                            min: 5,
                            max: 150,
                            //divisions: 15,
                            onChanged: (double value) {
                              setState(() {
                                _selectedPoints = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text("Use slider to select the amount"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              label: const Text("50 Points"),
                              selected: _selectedPoints == 50,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedPoints =
                                      selected ? 50 : _selectedPoints;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text("100 Points"),
                              selected: _selectedPoints == 100,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedPoints == selected
                                      ? 100
                                      : _selectedPoints;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text("200 Points"),
                              selected: _selectedPoints == 200,
                              onSelected: (bool selected) {
                                setState(() {
                                  _selectedPoints == selected
                                      ? 200
                                      : _selectedPoints;
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
                    //const SizedBox(height: 8),
                    Row(
                      children: [
                        Radio<dynamic>(
                          value: true,
                          groupValue: true,
                          onChanged: (dynamic value) {
                            setState(() {
                              //_character = value;
                            });
                          },
                        ),
                        const Text('Core values'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<dynamic>(
                          value: true,
                          groupValue: true,
                          onChanged: (dynamic value) {
                            setState(() {
                              //_character = value;
                            });
                          },
                        ),
                        const Text('Performance'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<dynamic>(
                          value: true,
                          groupValue: true,
                          onChanged: (dynamic value) {
                            setState(() {
                              //_character = value;
                            });
                          },
                        ),
                        const Text('Others'),
                      ],
                    ),
                  ],
                ),
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

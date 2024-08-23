import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/recognition.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';
import 'dart:math';
import 'failure_screen.dart';
import 'loading_screen.dart';
import 'success_screen.dart';

class P2pTab extends StatefulWidget {
  const P2pTab({super.key});

  @override
  State<P2pTab> createState() => _P2pTabState();
}

class _P2pTabState extends State<P2pTab> {
  double _sliderValue = 200;
  int _selectedChipValue = 200;
  dynamic _selectedRecognitionValue = 'Core values';
  dynamic _selectedRecipient;
  dynamic _searchedRecipient;
  List<Employee> employeeList = [];
  List<RecognitionValue> recognitionValueList = [];
  bool isLoading = true;
  bool isLoadingBalance = true;
  List<int> points = [100, 200, 300, 500];
  int balance = 0;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchBalance() async {
    final balanceResponse = await RecognitionApi.getBalance();
    setState(() {
      balance = Balance.fromJson(balanceResponse as Map<String, dynamic>)
          .currentPoint;
      isLoadingBalance = false;
    });
  }

  Future<void> fetchEmployees() async {
    final response = await RecognitionApi.getEmployees();
    final recognitionValueResponse =
        await RecognitionApi.getRecognitionValues();
    final balanceResponse = await RecognitionApi.getBalance();
    setState(() {
      employeeList = (response as List)
          .map((item) => Employee.fromJson(item as Map<String, dynamic>))
          .toList();
      recognitionValueList = (recognitionValueResponse as List).map((item) {
        return RecognitionValue.fromJson(item as Map<String, dynamic>);
      }).toList();

      balance = Balance.fromJson(balanceResponse as Map<String, dynamic>)
          .currentPoint;
      isLoading = false;
      isLoadingBalance = false;
    });
  }

  void navigate(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> sendRecognition(BuildContext context) async {
    final data = {
      "recognitionValueId": _selectedRecognitionValue.id,
      "detailRecognitions": [
        {"recipientEmail": _selectedRecipient.email, "point": _sliderValue}
      ],
      "message": _textFieldController.text,
      "type": "peer_to_peer"
    };
    print(data);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingScreen();
      },
    );

    try {
      await RecognitionApi.sendRecognition(data);
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SuccessScreen();
        },
      );
      setState(() {
        isLoadingBalance = true;
      });
      await fetchBalance();
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const FailureScreen();
        },
      );
    }
  }

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
        bottomNavigationBar: isLoading
            ? const SizedBox()
            : BottomAppBar(
                elevation: 2,
                height: 64,
                color: theme.colorScheme.surface,
                child: FilledButton(
                  onPressed: () {
                    sendRecognition(context);
                  },
                  child: Text(
                    'Send now',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
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
                                children: employeeList
                                    .sublist(0, min(employeeList.length, 5))
                                    .map((user) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedRecipient = user;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 24,
                                            child: ClipOval(
                                              child: Image.network(
                                                user.picture,
                                                fit: BoxFit.cover,
                                                width: 48,
                                                height: 48,
                                              ),
                                            ),
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
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: employeeList
                                      .where((user) =>
                                          user.name.toLowerCase().contains(
                                              _searchedRecipient
                                                  .toLowerCase()) ||
                                          user.email.toLowerCase().contains(
                                              _searchedRecipient.toLowerCase()))
                                      .map((user) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedRecipient = user;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              child: ClipOval(
                                                child: Image.network(
                                                  user.picture,
                                                  fit: BoxFit.cover,
                                                  width: 48,
                                                  height: 48,
                                                ),
                                              ),
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children:
                                                    splitText(user.name, 6),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
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
                                  CircleAvatar(
                                    radius: 24,
                                    child: ClipOval(
                                      child: Image.network(
                                        _selectedRecipient.picture,
                                        fit: BoxFit.cover,
                                        width: 48,
                                        height: 48,
                                      ),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: splitText(
                                          _selectedRecipient.name, 12),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Points balanced: ",
                                  style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              isLoadingBalance
                                  ? const SizedBox(
                                      width: 14.0,
                                      height: 14.0,
                                      child: CircularProgressIndicator(),
                                    )
                                  : DisplayAmount(
                                      amount: balance,
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
                                  max: 500,
                                  onChanged: (double value) {
                                    setState(() {
                                      _sliderValue = value;
                                      if (!points.contains(_sliderValue)) {
                                        _selectedChipValue = -1;
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text("Use slider to select the amount"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: points.map((point) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text("${point}p"),
                                      selected: _selectedChipValue == point,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            _selectedChipValue = point;
                                            _sliderValue = point.toDouble();
                                          }
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
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
                              children: recognitionValueList
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                var recognitionValue = entry.value;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recognitionValue.name,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: recognitionValueColors[index %
                                            recognitionValueColors.length],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...recognitionValue.recognitionValues
                                        .map((v) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedRecognitionValue = v;
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Radio<dynamic>(
                                                value: v,
                                                groupValue:
                                                    _selectedRecognitionValue,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    _selectedRecognitionValue =
                                                        value;
                                                  });
                                                },
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: recognitionValueColors[
                                                    index %
                                                        recognitionValueColors
                                                            .length],
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                v.name,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                );
                              }).toList(),
                            ),
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
                    SliverToBoxAdapter(
                      child: TextField(
                        controller: _textFieldController,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 3,
                        decoration: const InputDecoration(
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

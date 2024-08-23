import 'package:flutter/material.dart';
import 'package:sonat_hrm_rewarded/src/common_widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/mock_data/recognition.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';
import 'package:sonat_hrm_rewarded/src/widgets/home/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/widgets/recognition/team/team_filters.dart';

class TeamTab extends StatefulWidget {
  const TeamTab({super.key});

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  double _sliderValue = 200;
  int _selectedChipValue = 200;
  dynamic _selectedRecognitionValue = 'Core values';
  dynamic _selectedRecipient;
  dynamic _searchedRecipient;
  dynamic _isSavePresets = false;
  dynamic _isAllocateCustom = false;
  List<RecognitionValue> recognitionValueList = [];
  bool isLoading = true;
  List<Employee> employeeList = [];
  List<int> points = [100, 200, 300, 500];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    final employeeResponse = await RecognitionApi.getEmployees();
    final recognitionValueResponse =
        await RecognitionApi.getRecognitionValues();

    setState(() {
      employeeList = (employeeResponse as List).map((item) {
        return Employee.fromJson(item as Map<String, dynamic>);
      }).toList();
      recognitionValueList = (recognitionValueResponse as List).map((item) {
        return RecognitionValue.fromJson(item as Map<String, dynamic>);
      }).toList();
      isLoading = false;
    });
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
        bottomNavigationBar: isLoading
            ? const SizedBox()
            : BottomAppBar(
                elevation: 2,
                color: theme.colorScheme.surface,
                child: SizedBox(
                  height: 64,
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
                        ...employeeList.sublist(0, 0).map((user) {
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
                                  const Text(
                                      "Allocate custom for each team member"),
                                  Transform.scale(
                                    scale: 0.75,
                                    child: Switch(
                                      value: _isAllocateCustom,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _isAllocateCustom = value;
                                        });
                                      },
                                    ),
                                  ),
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
                  ],
                ),
              ));
  }
}

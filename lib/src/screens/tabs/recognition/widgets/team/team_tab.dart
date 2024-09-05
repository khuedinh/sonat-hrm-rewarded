import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/display_amount/display_amount.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/balance.dart';
import 'package:sonat_hrm_rewarded/src/models/employee.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/recognition-values/recognition_values.dart';
import 'package:sonat_hrm_rewarded/src/screens/tabs/recognition/widgets/team/team_filters.dart';
import 'package:sonat_hrm_rewarded/src/service/api/balance_api.dart';
import 'package:sonat_hrm_rewarded/src/service/api/recognition_api.dart';
import 'package:sonat_hrm_rewarded/src/utils/number.dart';

final recognitionValueColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.amber,
  Colors.deepPurple,
  Colors.indigo,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.lime,
  Colors.deepOrange,
  Colors.cyan,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.yellow,
];

class TeamTab extends StatefulWidget {
  const TeamTab({super.key});

  @override
  State<TeamTab> createState() => _TeamTabState();
}

class _TeamTabState extends State<TeamTab> {
  double _sliderValue = 200;
  int _selectedChipValue = 200;
  dynamic _selectedRecognitionValue = 'Core values';
  //dynamic _selectedRecipient;
  //dynamic _searchedRecipient;
  dynamic _isSavePresets = false;
  dynamic _isAllocateCustom = false;
  List<RecognitionValue> recognitionValueList = [];
  bool isLoading = true;
  bool isLoadingBalance = true;
  bool isLoadingGroups = true;
  List<Employee> employeeList = [];
  List<int> points = [100, 200, 300, 500];
  int balance = 0;
  List<Group> groups = [];
  List<MemberGroup> _selectedRecipients = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
    fetchBalance();
    fetchGroups();
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

  Future<void> fetchBalance() async {
    final balanceResponse = await BalanceApi.getCurrentBalance();
    setState(() {
      balance = CurrentBalance.fromJson(balanceResponse as Map<String, dynamic>)
          .currentPoint;
      isLoadingBalance = false;
    });
  }

  Future<void> fetchGroups() async {
    final groupsResponse = await RecognitionApi.getGroups();
    setState(() {
      groups = (groupsResponse as List).map((item) {
        return Group.fromJson(item as Map<String, dynamic>);
      }).toList();
      isLoadingGroups = false;
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: TeamFilters(
                groups: groups,
                selectedRecipients: _selectedRecipients,
                onSelectedRecipientChanged: (selectedRecipients) {
                  setState(() {
                    _selectedRecipients = selectedRecipients;
                  });
                }),
          );
        },
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
                  ..._selectedRecipients.map((user) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            // _selectedRecipient = user;
                          });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user.employees.picture,
                                  fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: splitText(user.employees.name, 6),
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
                            const Text("Allocate custom for each team member"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Points balanced: ",
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        isLoadingBalance
                            ? const Skeletonizer(child: Bone.text(words: 1))
                            : DisplayAmount(
                                amount: formatNumber(balance),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              RecognitionValueWidget(
                  isLoading: isLoading,
                  recognitionValueList: recognitionValueList,
                  selectedRecognitionValue: _selectedRecognitionValue,
                  onRecognitionValueChanged: (value) {
                    setState(() {
                      _selectedRecognitionValue = value;
                    });
                  },
                  recognitionValueColors: recognitionValueColors),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ));
  }
}

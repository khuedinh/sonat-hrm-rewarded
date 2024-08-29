import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';

class RecognitionValueWidget extends StatefulWidget {
  final bool isLoading;
  final List<dynamic> recognitionValueList;
  final dynamic selectedRecognitionValue;
  final Function(dynamic) onRecognitionValueChanged;
  final List<Color> recognitionValueColors;

  const RecognitionValueWidget({
    super.key,
    required this.isLoading,
    required this.recognitionValueList,
    required this.selectedRecognitionValue,
    required this.onRecognitionValueChanged,
    required this.recognitionValueColors,
  });

  @override
  _RecognitionValueWidgetState createState() => _RecognitionValueWidgetState();
}

class _RecognitionValueWidgetState extends State<RecognitionValueWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: 'Recognition Value',
            color: theme.colorScheme.onSurface,
          ),
          widget.isLoading
              ? Skeletonizer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [1, 2].map((entry) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Business Performance",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...[1, 2].map((v) {
                            return SizedBox(
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Radio(
                                      value: "a",
                                      groupValue: "",
                                      onChanged: (String? value) {},
                                    ),
                                    const Icon(
                                      Icons.star,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "High Performance",
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
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      widget.recognitionValueList.asMap().entries.map((entry) {
                    int index = entry.key;
                    var recognitionValue = entry.value;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recognitionValue.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: widget.recognitionValueColors[
                                index % widget.recognitionValueColors.length],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...recognitionValue.recognitionValues.map((v) {
                          return SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                widget.onRecognitionValueChanged(v);
                              },
                              child: Row(
                                children: [
                                  Radio<dynamic>(
                                    value: v,
                                    groupValue: widget.selectedRecognitionValue,
                                    onChanged: (dynamic value) {
                                      widget.onRecognitionValueChanged(value);
                                    },
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: widget.recognitionValueColors[index %
                                        widget.recognitionValueColors.length],
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
        ],
      ),
    );
  }
}

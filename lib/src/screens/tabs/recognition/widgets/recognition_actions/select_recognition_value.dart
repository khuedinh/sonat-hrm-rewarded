import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sonat_hrm_rewarded/src/common/widgets/screen_title/screen_title.dart';
import 'package:sonat_hrm_rewarded/src/models/recognition.dart';

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

class SelectRecognitionValue extends StatelessWidget {
  final bool isLoading;
  final List<RecognitionValue> listRecognitionValues;
  final dynamic selectedRecognitionValue;
  final void Function(String? value) onRecognitionValueChanged;

  const SelectRecognitionValue({
    super.key,
    required this.isLoading,
    required this.listRecognitionValues,
    required this.selectedRecognitionValue,
    required this.onRecognitionValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenTitle(
            title: 'Recognition value',
            fontSize: 16,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 4),
          isLoading
              ? Skeletonizer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [1, 2].map((entry) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Bone.text(words: 2),
                          ...[1, 2].map((v) {
                            return SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Radio(
                                    value: "a",
                                    groupValue: "",
                                    onChanged: (String? value) {},
                                  ),
                                  const SizedBox(width: 8),
                                  const Bone.text(words: 2),
                                ],
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
                  children: [
                    for (int i = 0; i < listRecognitionValues.length; i++)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listRecognitionValues[i].name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: recognitionValueColors[
                                  i % recognitionValueColors.length],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          ...listRecognitionValues[i]
                              .recognitionValues
                              .map((item) {
                            return SizedBox(
                              width: double.infinity,
                              child: InkWell(
                                onTap: () {
                                  onRecognitionValueChanged(item.id);
                                },
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: item.id,
                                      groupValue: selectedRecognitionValue,
                                      onChanged: onRecognitionValueChanged,
                                    ),
                                    CachedNetworkImage(
                                      imageUrl: item.iconUrl ?? "",
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.star,
                                        color: recognitionValueColors[
                                            i % recognitionValueColors.length],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(item.name),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                  ],
                ),
        ],
      ),
    );
  }
}

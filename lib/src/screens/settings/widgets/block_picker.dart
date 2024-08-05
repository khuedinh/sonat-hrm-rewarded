import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BlockColorPicker extends StatefulWidget {
  const BlockColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    required this.colorHistory,
  });

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> colorHistory;

  @override
  State<BlockColorPicker> createState() => _BlockColorPickerState();
}

class _BlockColorPickerState extends State<BlockColorPicker> {
  final double _borderRadius = 10;
  final double _iconSize = 24;

  Widget pickerLayoutBuilder(
    BuildContext context,
    List<Color> colors,
    PickerItem child,
  ) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [for (Color color in colors) child(color)],
    );
  }

  Widget pickerItemBuilder(
    Color color,
    bool isCurrentColor,
    void Function() changeColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlockPicker(
      pickerColor: widget.pickerColor,
      onColorChanged: widget.onColorChanged,
      layoutBuilder: pickerLayoutBuilder,
      itemBuilder: pickerItemBuilder,
    );
  }
}

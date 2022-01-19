import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';

enum Delta { Plus, Minus, Half }

class PlusMinusButton extends StatelessWidget {
  final widget;
  final index;
  final Delta delta;
  const PlusMinusButton(
      {Key? key,
      required this.widget,
      required this.index,
      required this.delta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _delta = 0.0;
    var icon;
    final count = widget.snapshot.data[index]['count'] as num;
    final countDouble;
    final iconColors = <String, Color>{};
    bool isDouble = false;
    bool isInteger(num value) => (value % 1) == 0;

    if (isInteger(count) == true) {
      countDouble = count.toDouble().toStringAsFixed(0);
    } else {
      isDouble = true;
      countDouble = count.toDouble();
    }

    switch (delta) {
      case Delta.Plus:
        _delta = 1;
        icon = const Icon(Icons.add);
        iconColors.addAll({
          'primary': Colors.blueGrey[500] as Color,
          'onPrimary': Colors.blueGrey[100] as Color
        });
        break;
      case Delta.Minus:
        _delta = -1;
        icon = const Icon(Icons.remove);
        iconColors.addAll({
          'primary': Colors.blueGrey[100] as Color,
          'onPrimary': Colors.blueGrey[500] as Color
        });
        break;
      case Delta.Half:
        if (isDouble == false) {
          _delta = 0.5;
          icon = const Text(
            '+½',
            style: TextStyle(fontSize: 20),
          );
          iconColors.addAll({
            'primary': Colors.blueGrey[500] as Color,
            'onPrimary': Colors.blueGrey[100] as Color
          });
        } else {
          _delta = -0.5;
          icon = const Text(
            '-½',
            style: TextStyle(fontSize: 20),
          );
          iconColors.addAll({
            'primary': Colors.blueGrey[100] as Color,
            'onPrimary': Colors.blueGrey[500] as Color
          });
        }
        break;
    }

    return ElevatedButton(
      onPressed: () {
        if (widget.snapshot.data[index]["count"] == 0.5 &&
            delta == Delta.Minus) {
          widget.snapshot.data[index]["count"] = 0;
          writeJson(widget.snapshot.data);
          widget.refresh();
        } else if (widget.snapshot.data[index]["count"] >= 1 &&
            delta == Delta.Minus) {
          widget.snapshot.data[index]["count"] += _delta;
          writeJson(widget.snapshot.data);
          widget.refresh();
        } else if (widget.snapshot.data[index]["count"] >= 0 &&
            delta == Delta.Plus) {
          widget.snapshot.data[index]["count"] += _delta;
          writeJson(widget.snapshot.data);
          widget.refresh();
        } else if (widget.snapshot.data[index]["count"] >= 0 &&
            delta == Delta.Half) {
          widget.snapshot.data[index]["count"] += _delta;
          writeJson(widget.snapshot.data);
          widget.refresh();
        }
      },
      child: icon,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(side: BorderSide(color: Colors.blueGrey.shade700)),

        padding: const EdgeInsets.fromLTRB(4, 5, 5, 4),
        primary: iconColors['primary'], // <-- Button color
        onPrimary: iconColors['onPrimary'], // <-- Splash color
      ),
    );
  }
}

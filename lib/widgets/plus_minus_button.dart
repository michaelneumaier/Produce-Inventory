import 'package:flutter/material.dart';
import 'package:orderguide/models/inventory_controller.dart';

enum Delta { plus, minus, half }

class PlusMinusButton extends StatelessWidget {
  final dynamic widget;
  final int index;
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
    late dynamic icon;
    final count = widget.snapshot.data[index]['count'] as num;
    final iconColors = <String, Color>{};
    bool isDouble = false;
    bool isInteger(num value) => (value % 1) == 0;

    if (isInteger(count) == true) {
    } else {
      isDouble = true;
    }

    switch (delta) {
      case Delta.plus:
        _delta = 1;
        icon = const Icon(Icons.add);
        iconColors.addAll({
          'primary': Colors.blueGrey[500] as Color,
          'onPrimary': Colors.blueGrey[100] as Color
        });
        break;
      case Delta.minus:
        _delta = -1;
        icon = const Icon(Icons.remove);
        iconColors.addAll({
          'primary': Colors.blueGrey[100] as Color,
          'onPrimary': Colors.blueGrey[500] as Color
        });
        break;
      case Delta.half:
        if (isDouble == false) {
          _delta = 0.5;
          icon = const Text(
            '+½',
            textScaleFactor: 1,
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
            textScaleFactor: 1,
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
            delta == Delta.minus) {
          widget.snapshot.data[index]["count"] = 0;
          writeJson(widget.snapshot.data);
          widget.refresh();
        } else if (widget.snapshot.data[index]["count"] >= 1 &&
            delta == Delta.minus) {
          widget.snapshot.data[index]["count"] += _delta;
          writeJson(widget.snapshot.data);
          widget.refresh();
        } else if (widget.snapshot.data[index]["count"] >= 0 &&
            delta == Delta.plus) {
          widget.snapshot.data[index]["count"] += _delta;
          writeJson(widget.snapshot.data);
          widget.refresh();
        } else if (widget.snapshot.data[index]["count"] >= 0 &&
            delta == Delta.half) {
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

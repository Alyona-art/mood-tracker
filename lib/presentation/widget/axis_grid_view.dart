import 'package:flutter/material.dart';

import '../shared/assets/l10n.dart';

class AxisGridView extends StatelessWidget {
  const AxisGridView({
    super.key,
    required this.grid,
    required this.size,
    required this.topLeftColor,
    required this.bottomLeftColor,
    required this.bottomRightColor,
  });

  final Widget grid;
  final double size;
  final Color topLeftColor;
  final Color bottomLeftColor;
  final Color bottomRightColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: size,
          child: RotatedBox(
            quarterTurns: -1,
            child: _AxisRow(
              name: S.of(context).energy,
              leading: S.of(context).low,
              trailing: S.of(context).high,
              leadingColor: bottomLeftColor,
              trailingColor: topLeftColor,
            ),
          ),
        ),
        const SizedBox(width: 2),

        Column(
          children: <Widget>[
            SizedBox(width: size, height: size, child: grid),

            const SizedBox(height: 2),
            SizedBox(
              width: size,
              child: _AxisRow(
                name: S.of(context).feeling,
                leading: S.of(context).unpleasant,
                trailing: S.of(context).pleasant,
                leadingColor: bottomLeftColor,
                trailingColor: bottomRightColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AxisRow extends StatelessWidget {
  const _AxisRow({
    required this.name,
    required this.leading,
    required this.trailing,
    required this.leadingColor,
    required this.trailingColor,
  });

  final String name;
  final String leading;
  final String trailing;
  final Color leadingColor;
  final Color trailingColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          leading,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: leadingColor),
        ),
        const _Line(),
        Text(name, style: Theme.of(context).textTheme.bodySmall),
        const _Line(),
        Text(
          trailing,
          style: Theme.of(
            context,
          ).textTheme.bodySmall!.copyWith(color: trailingColor),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(height: 1, color: Colors.black),
      ),
    );
  }
}

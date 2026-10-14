import 'package:flutter/material.dart';

class ExpandableNoteCard extends StatefulWidget {
  const ExpandableNoteCard({super.key, required this.text, this.maxLines = 3});

  final String text;
  final int maxLines;

  @override
  State<ExpandableNoteCard> createState() => _ExpandableNoteCardState();
}

class _ExpandableNoteCardState extends State<ExpandableNoteCard> {
  bool _expanded = false;
  bool _overflows = false;

  void _toggle() {
    if (!_overflows) {
      return;
    }
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color cardColor = scheme.surfaceContainerHighest;
    final TextStyle? bodyStyle = Theme.of(context).textTheme.bodyMedium;

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _overflows ? _toggle : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Text(
                'Заметка',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final TextPainter painter = TextPainter(
                    text: TextSpan(text: widget.text, style: bodyStyle),
                    maxLines: widget.maxLines,
                    textDirection: Directionality.of(context),
                  )..layout(maxWidth: constraints.maxWidth);
                  final bool overflows = painter.didExceedMaxLines;
                  if (overflows != _overflows) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() => _overflows = overflows);
                      }
                    });
                  }

                  if (_expanded || !overflows) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.text, style: bodyStyle),
                        if (_overflows && _expanded) ...<Widget>[
                          const SizedBox(height: 8),
                          Text(
                            'свернуть',
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ],
                    );
                  }

                  return Stack(
                    children: <Widget>[
                      Text(
                        widget.text,
                        style: bodyStyle,
                        maxLines: widget.maxLines,
                        overflow: TextOverflow.clip,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: (bodyStyle?.fontSize ?? 14) * 1.4,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                cardColor.withValues(alpha: 0),
                                cardColor.withValues(alpha: 0.55),
                                cardColor,
                              ],
                              stops: const <double>[0.0, 0.45, 0.75],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: -2,
                        child: Text(
                          'ещё',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

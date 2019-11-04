import 'package:flutter/material.dart';

class SkillsSelector extends StatelessWidget {
  final List<String> skills;
  final int crossAxisCount;
  final bool Function(String) onSelected;
  final bool Function(String) onDeselected;
  final bool Function(String) selectedPredicate;

  const SkillsSelector({
    Key key,
    this.skills,
    this.crossAxisCount,
    this.onSelected,
    this.onDeselected,
    this.selectedPredicate,
  });

  @override
  Widget build(BuildContext context) {
    final c = skills.fold(0, (sum, skill) => sum + skill.length);
    final pr = c ~/ crossAxisCount;
    final rows = List<List<String>>(crossAxisCount);
    int current = 0;
    for (var i = 0; i < crossAxisCount; i++) {
      var sum = 0;
      rows[i] = skills.sublist(current, skills.length).takeWhile(
        (skill) {
          sum += skill.length;
          return sum < pr;
        },
      ).toList();
      print('${rows[i].fold<int>(0, (s, e) => s + e.length)} / $pr');
      current += rows[i].length;
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: rows
            .map(
              (row) => Row(
                children: row
                    .map(
                      (skill) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _MultichoiceChip(
                          label: skill,
                          onSelected: (state) =>
                              state ? onSelected(skill) : onDeselected(skill),
                          selected: selectedPredicate?.call(skill) ?? false,
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MultichoiceChip extends StatefulWidget {
  final String label;
  final Function(bool) onSelected;
  final bool selected;

  const _MultichoiceChip({
    Key key,
    this.label,
    this.onSelected,
    this.selected,
  }) : super(key: key);

  @override
  _MultichoiceChipState createState() => _MultichoiceChipState(selected);
}

class _MultichoiceChipState extends State<_MultichoiceChip> {
  bool selected;

  _MultichoiceChipState(this.selected);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      backgroundColor: const Color(0xFFEDEAF9),
      selectedColor: const Color(0xB3FF9595),
      label: Text(widget.label),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onSelected: (state) {
        final canSelect = widget.onSelected(state);
        if (!canSelect) return;
        setState(() {
          selected = state;
        });
      },
    );
  }
}

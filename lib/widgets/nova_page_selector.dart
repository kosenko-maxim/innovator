import 'package:flutter/material.dart';

/// виджет, отображающий текущую вкладку при горизонтальной прокрутке
class NovaPageSelector extends StatelessWidget {
  final TabController controller;
  final double indicatorSize;
  final Color color;
  final Color selectedColor;

  NovaPageSelector({
    Key key,
    this.controller,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
  }) : super(key: key);

  Widget _buildTabIndicator(
    int tabIndex,
    TabController tabController,
    ColorTween selectedColorTween,
    ColorTween previousColorTween,
  ) {
    Color background;
    if (tabController.indexIsChanging) {
      // The selection's animation is animating from previousValue to value.
      final double t = 1.0 - _indexChangeProgress(tabController);
      if ((tabController.index % 5).toInt() == tabIndex) {
        background = selectedColorTween.lerp(t);
      } else if (tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t);
      else
        background = selectedColorTween.begin;
    } else {
      // The selection's offset reflects how far the TabBarView has / been dragged
      // to the previous page (-1.0 to 0.0) or the next page (0.0 to 1.0).
      final double offset = tabController.offset;
      if ((tabController.index % 5).toInt() == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs());
      } else if ((tabController.index % 5).toInt() == tabIndex - 1 &&
          offset > 0.0) {
        background = selectedColorTween.lerp(offset);
      } else if ((tabController.index % 5).toInt() == tabIndex + 1 &&
          offset < 0.0) {
        background = selectedColorTween.lerp(-offset);
      } else {
        background = selectedColorTween.begin;
      }
    }
    return _TabPageSelectorIndicator(
      backgroundColor: background,
      width: indicatorSize,
      height: indicatorSize,
    );
  }

  double _indexChangeProgress(TabController controller) {
    final double controllerValue = controller.animation.value;
    final double previousIndex = controller.previousIndex.toDouble();
    final double currentIndex = controller.index.toDouble();

    // The controller's offset is changing because the user is dragging the
    // TabBarView's PageView to the left or right.
    if (!controller.indexIsChanging)
      return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

    // The TabController animation's value is changing from previousIndex to currentIndex.
    return (controllerValue - currentIndex).abs() /
        (currentIndex - previousIndex).abs();
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = color ?? Colors.transparent;
    final Color fixSelectedColor =
        selectedColor ?? Theme.of(context).accentColor;
    final ColorTween selectedColorTween =
        ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween =
        ColorTween(begin: fixSelectedColor, end: fixColor);
    final TabController tabController =
        controller ?? DefaultTabController.of(context);
    assert(() {
      if (tabController == null) {
        throw FlutterError('No TabController for $runtimeType.\n'
            'When creating a $runtimeType, you must either provide an explicit TabController '
            'using the "controller" property, or you must ensure that there is a '
            'DefaultTabController above the $runtimeType.\n'
            'In this case, there was neither an explicit controller nor a default controller.');
      }
      return true;
    }());
    final Animation<double> animation = CurvedAnimation(
      parent: tabController.animation,
      curve: Curves.fastOutSlowIn,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Semantics(
          label: 'Page ${tabController.index + 1} of ${tabController.length}',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(
              ((tabController.length ~/ 5) * 5 >= (tabController.index + 1)
                  ? 5
                  : tabController.length % 5),
              (int tabIndex) {
                return _buildTabIndicator(
                  (tabIndex % 5.0).toInt(),
                  tabController,
                  selectedColorTween,
                  previousColorTween,
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

class _TabPageSelectorIndicator extends StatelessWidget {
  /// Creates an indicator used by [TabPageSelector].
  ///
  /// The [backgroundColor], [borderColor], and [size] parameters must not be null.
  const _TabPageSelectorIndicator({
    Key key,
    @required this.backgroundColor,
    @required this.height,
    this.width,
  })  : assert(backgroundColor != null),
        super(key: key);

  /// The indicator circle's background color.
  final Color backgroundColor;

  /// The indicator circle's diameter.
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

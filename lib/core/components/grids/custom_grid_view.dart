import 'package:flutter/material.dart';

class CustomGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int, bool) itemBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<int>? selectedIndices;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final bool showLoading;
  final Widget? loadingIndicator;
  final Function(int)? onItemTap;
  final Function(int)? onItemLongPress;

  const CustomGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.8,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.selectedIndices,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.showLoading = false,
    this.loadingIndicator,
    this.onItemTap,
    this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return loadingIndicator ??
          const Center(child: CircularProgressIndicator());
    }

    return CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      slivers: [
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final isSelected = selectedIndices?.contains(index) ?? false;
              return GestureDetector(
                onTap: () => onItemTap?.call(index),
                onLongPress: () => onItemLongPress?.call(index),
                child: itemBuilder(context, items[index], index, isSelected),
              );
            }, childCount: items.length),
          ),
        ),
      ],
    );
  }
}

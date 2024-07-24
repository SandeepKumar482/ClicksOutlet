import 'package:apex_infinity/apex_infinity.dart';
import 'package:flutter/material.dart';

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class AxShimmer extends StatefulWidget {

  static AxShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<AxShimmerState>();
  }

  const AxShimmer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  AxShimmerState createState() => AxShimmerState();
}

class AxShimmerState extends State<AxShimmer> with SingleTickerProviderStateMixin {

  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
    colors: themeData.shimmerThemeData.linearGradient.colors,
    stops: themeData.shimmerThemeData.linearGradient.stops,
    begin: themeData.shimmerThemeData.linearGradient.begin,
    end: themeData.shimmerThemeData.linearGradient.end,
    transform:
    _SlidingGradientTransform(slidePercent: _shimmerController.value),
  );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox?;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class AxShimmerLoader extends StatefulWidget {

  final bool isLoading;
  final Widget child;

  const AxShimmerLoader({
    super.key,
    this.isLoading = true,
    required this.child,
  });

  @override
  State<AxShimmerLoader> createState() => _AxShimmerLoaderState();
}

class _AxShimmerLoaderState extends State<AxShimmerLoader> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = AxShimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // Update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (!widget.isLoading) {
      return widget.child;
    }

    // Collect ancestor shimmer info.
    final AxShimmerState? shimmer = AxShimmer.of(context);

    if (shimmer?.isSized ?? false) {

      final Size? shimmerSize = shimmer?.size;
      final Gradient? gradient = shimmer?.gradient;
      final Offset? offsetWithinShimmer = shimmer?.getDescendantOffset(
        descendant: context.findRenderObject() as RenderBox,
      );

      if(shimmerSize != null && gradient != null && offsetWithinShimmer != null) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return gradient.createShader(
              Rect.fromLTWH(
                -offsetWithinShimmer.dx,
                -offsetWithinShimmer.dy,
                shimmerSize.width,
                shimmerSize.height,
              ),
            );
          },
          child: widget.child,
        );
      } else {
        return widget.child;
      }

    } else {
      return widget.child;
    }

  }
}

class AxShimmerBox extends StatelessWidget {

  final double width;
  final double height;

  final double borderRadius;

  const AxShimmerBox({
    this.width = double.infinity,
    this.height = 24.0,
    this.borderRadius = 16.0,
    super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: themeData.shimmerThemeData.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

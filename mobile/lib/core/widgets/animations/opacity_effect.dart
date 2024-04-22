import 'package:flutter/material.dart';

class OpacityEffect extends StatefulWidget {
  final VoidCallback onClick;
  final Widget child;
  final double opacity;
  final Duration duration;

  const OpacityEffect({
    super.key,
    required this.onClick,
    required this.child,
    this.opacity = 0.5,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  OpacityEffectState createState() => OpacityEffectState();
}

class OpacityEffectState extends State<OpacityEffect>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;

  bool _isPlaying = false;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _anim = Tween<double>(
      begin: 1.0,
      end: widget.opacity,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    ));

    super.initState();

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.reverse().then((_) => _isPlaying = false);
      }
    });
  }

  @override
  dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isPlaying) {
      _isPlaying = true;
      _animController.forward();
    }

    widget.onClick.call();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: GestureDetector(
        onTap: _handleTap,
        child: widget.child,
      ),
    );
  }
}

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

part 'components/op_arrow_clipper.dart';
part 'components/op_controller.dart';
part 'components/op_menu_layout.dart';

Rect _menuRect = Rect.zero;

class OverlayPopup extends StatefulWidget {
  const OverlayPopup({
    super.key,
    required this.child,
    required this.menu,
    required this.controller,
    this.arrowColor = const Color(0xFF4C4C4C),
    this.showArrow = true,
    this.barrierColor = Colors.black12,
    this.arrowSize = 10.0,
    this.horizontalMargin = 1.0,
    this.verticalMargin = 1.0,
    this.position,
    this.menuOnChange,
  });

  final Widget child;
  final Widget menu;

  final bool showArrow;
  final Color arrowColor;
  final double arrowSize;

  /// Margin menu, only working at edge of screen
  final double horizontalMargin;
  final double verticalMargin;

  final PopupPosition? position;

  final OverlayPopupController controller;
  final void Function(bool)? menuOnChange;

  /// Background color outside
  final Color barrierColor;

  @override
  State<OverlayPopup> createState() => OverlayPopupState();
}

class OverlayPopupState extends State<OverlayPopup> {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  OverlayPopupController? _controller;

  _showMenu() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        Widget menu = Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: _parentBox!.size.width - 2 * widget.horizontalMargin,
              minWidth: 0,
            ),
            child: CustomMultiChildLayout(
              delegate: MenuLayoutDelegate(
                anchorSize: _childBox!.size,
                anchorOffset: _childBox!.localToGlobal(
                  Offset(-widget.horizontalMargin, 0),
                ),
                verticalMargin: widget.verticalMargin,
                position: widget.position,
              ),
              children: <Widget>[
                if (widget.showArrow)
                  LayoutId(
                    id: MenuLayoutId.arrow,
                    child: ClipPath(
                      clipper: ArrowClipper(),
                      child: Container(
                        width: widget.arrowSize,
                        height: widget.arrowSize,
                        color: widget.arrowColor,
                      ),
                    ),
                  ),
                if (widget.showArrow)
                  LayoutId(
                    id: MenuLayoutId.downArrow,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: ClipPath(
                        clipper: ArrowClipper(),
                        child: Container(
                          width: widget.arrowSize,
                          height: widget.arrowSize,
                          color: widget.arrowColor,
                        ),
                      ),
                    ),
                  ),
                LayoutId(
                  id: MenuLayoutId.content,
                  child: Material(
                    elevation: 8,
                    type: MaterialType.transparency,
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.transparent,
                    child: widget.menu,
                  ),
                ),
              ],
            ),
          ),
        );

        return Listener(
          onPointerDown: (PointerDownEvent event) {
            Offset offset = event.localPosition;

            // Tap in menu
            if (_menuRect.contains(
              Offset(offset.dx - widget.horizontalMargin, offset.dy),
            )) {
              return;
            }

            _controller?.hideMenu();
          },
          child: widget.barrierColor == Colors.transparent
              ? menu
              : Container(
                  color: widget.barrierColor,
                  child: menu,
                ),
        );
      },
    );

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;

    _controller?.addListener(() {
      bool menuIsShowing = _controller?.showing ?? false;
      widget.menuOnChange?.call(menuIsShowing);

      if (menuIsShowing) {
        _showMenu();
      } else {
        _hideMenu();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        _childBox = context.findRenderObject() as RenderBox?;
        _parentBox =
            Overlay.of(context).context.findRenderObject() as RenderBox?;
      }
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? widget.child
        : PopScope(
            onPopInvoked: (_) => _hideMenu(),
            // canPop: false,
            child: widget.child,
          );
  }
}

enum PopupPosition {
  top,
  bottom,
}

enum MenuLayoutId {
  arrow,
  downArrow,
  content,
}

enum MenuPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
}

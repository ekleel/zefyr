// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:notus/notus.dart';
import 'theme.dart';
import 'editable_box.dart';

class ZefyrHorizontalRule extends LeafRenderObjectWidget {
  ZefyrHorizontalRule({@required this.node, @required this.theme}) : assert(node != null);

  final EmbedNode node;
  final ZefyrThemeData theme;

  @override
  RenderHorizontalRule createRenderObject(BuildContext context) {
    return RenderHorizontalRule(node: node, theme: theme);
  }

  @override
  void updateRenderObject(BuildContext context, RenderHorizontalRule renderObject) {
    renderObject..node = node;
  }
}

class RenderHorizontalRule extends RenderEditableBox {
  static const _kPaddingTop = 22.0;
  static const _kPaddingBottom = 22.0;
  static const _kHeight = _kPaddingTop + _kPaddingBottom;

  RenderHorizontalRule({
    @required EmbedNode node,
    @required ZefyrThemeData theme,
  })  : _node = node,
        _theme = theme;

  @override
  EmbedNode get node => _node;
  EmbedNode _node;
  final ZefyrThemeData _theme;
  set node(EmbedNode value) {
    if (_node == value) return;
    _node = value;
    markNeedsPaint();
  }

  @override
  double get preferredLineHeight => size.height;

  @override
  SelectionOrder get selectionOrder => SelectionOrder.background;

  @override
  List<ui.TextBox> getEndpointsForSelection(TextSelection selection) {
    final local = getLocalSelection(selection);
    if (local.isCollapsed) {
      final dx = local.extentOffset == 0 ? 0.0 : size.width;
      return [
        ui.TextBox.fromLTRBD(dx, 0.0, dx, size.height, TextDirection.ltr),
      ];
    }

    return [
      ui.TextBox.fromLTRBD(0.0, 0.0, 0.0, size.height, TextDirection.ltr),
      ui.TextBox.fromLTRBD(size.width, 0.0, size.width, size.height, TextDirection.ltr),
    ];
  }

  @override
  void performLayout() {
    assert(constraints.hasBoundedWidth);
    size = Size(constraints.maxWidth, _kHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var paint = Paint()..color = _theme.dividerColor;

    final dims = 4;
    final spacer = 14;

    final startY = size.width / 2 - (2 * (spacer));
    var offsetY = 0;

    for (var i = 0; i < 3; i++) {
      offsetY += (spacer + dims);

      context.canvas.drawCircle(
        Offset(startY + offsetY, _kPaddingTop + offset.dy),
        dims / 2,
        paint,
      );
    }
  }

  @override
  TextPosition getPositionForOffset(Offset offset) {
    var position = _node.documentOffset;

    if (offset.dx > size.width / 2) {
      position++;
    }
    return TextPosition(offset: position);
  }

  @override
  TextRange getWordBoundary(TextPosition position) {
    final start = _node.documentOffset;
    return TextRange(start: start, end: start + 1);
  }

  @override
  void paintSelection(PaintingContext context, Offset offset, TextSelection selection, Color selectionColor) {
    final localSelection = getLocalSelection(selection);
    assert(localSelection != null);
    if (!localSelection.isCollapsed) {
      final paint = Paint()..color = selectionColor;
      final rect = Rect.fromLTWH(0.0, 0.0, size.width, _kHeight);
      context.canvas.drawRect(rect.shift(offset), paint);
    }
  }

  @override
  Offset getOffsetForCaret(ui.TextPosition position, ui.Rect caretPrototype) {
    final pos = position.offset - node.documentOffset;
    var caretOffset = Offset.zero;
    if (pos == 1) {
      caretOffset = caretOffset + Offset(size.width - 1.0, 0.0);
    }
    return caretOffset;
  }
}

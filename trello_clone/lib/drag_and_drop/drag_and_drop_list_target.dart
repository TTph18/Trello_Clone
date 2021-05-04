import 'package:trello_clone/drag_and_drop/drag_and_drop_builder_parameters.dart';
import 'package:trello_clone/drag_and_drop/drag_and_drop_list_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnDropOnLastTarget(
  DragAndDropListInterface newOrReordered,
  DragAndDropListTarget receiver,
);

class DragAndDropListTarget extends StatefulWidget {
  final Widget? child;
  final DragAndDropBuilderParameters parameters;
  final OnDropOnLastTarget onDropOnLastTarget;
  final double lastListTargetSize;

  DragAndDropListTarget(
      {this.child,
      required this.parameters,
      required this.onDropOnLastTarget,
      this.lastListTargetSize = 0,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DragAndDropListTarget();
}

class _DragAndDropListTarget extends State<DragAndDropListTarget>
    with TickerProviderStateMixin {
  DragAndDropListInterface? _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    Widget visibleContents = Column(
      children: <Widget>[
        AnimatedSize(
          duration: Duration(
              milliseconds: widget.parameters.listSizeAnimationDuration),
          vsync: this,
          alignment: widget.parameters.axis == Axis.vertical
              ? Alignment.bottomCenter
              : Alignment.centerLeft,
          child: _hoveredDraggable != null
              ? Opacity(
                  opacity: widget.parameters.listGhostOpacity,
                  child: widget.parameters.listGhost ??
                      _hoveredDraggable!.generateWidget(widget.parameters),
                )
              : Container(),
        ),
        widget.child ??
            Container(
              height: 1,
              //widget.parameters.axis == Axis.vertical
              //    ? widget.lastListTargetSize
              //    : 0,
              width: 1,
              //widget.parameters.axis == Axis.horizontal
              //    ? 0
              //    : widget.lastListTargetSize,
            ),
      ],
    );

    if (widget.parameters.listPadding != null) {
      visibleContents = Padding(
        padding: widget.parameters.listPadding!,
        child: visibleContents,
      );
    }

    if (widget.parameters.axis == Axis.horizontal) {
      visibleContents = SingleChildScrollView(child: visibleContents);
    }

    return Stack(
      children: <Widget>[
        visibleContents,
        Positioned.fill(
          child: DragTarget<DragAndDropListInterface>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAccept: (incoming) {
              bool accept = true;
              if (widget.parameters.listTargetOnWillAccept != null) {
                accept =
                    widget.parameters.listTargetOnWillAccept!(incoming, widget);
              }
              if (accept && mounted) {
                setState(() {
                  _hoveredDraggable = incoming;
                });
              }
              return accept;
            },
            onLeave: (incoming) {
              if (mounted) {
                setState(() {
                  _hoveredDraggable = null;
                });
              }
            },
            onAccept: (incoming) {
              if (mounted) {
                setState(() {
                  widget.onDropOnLastTarget(incoming, widget);
                  _hoveredDraggable = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

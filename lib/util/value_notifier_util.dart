import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class BaseTuple<T> {
  List<R> toTypeList<R>({
    bool growable = false,
  });
}

class Tuple2<T1, T2> extends BaseTuple {
  T1 item1;
  T2 item2;

  Tuple2(this.item1, this.item2);

  @override
  List<R> toTypeList<R>({bool growable = false}) {
    return List<R>.from(
      [item1, item2],
      growable: growable,
    );
  }

  factory Tuple2.fromList(List list) {
    return Tuple2(list[0], list[1]);
  }
}

class Tuple3<T1, T2, T3> extends BaseTuple {
  T1 item1;
  T2 item2;
  T3 item3;

  Tuple3(this.item1, this.item2, this.item3);

  @override
  List<R> toTypeList<R>({bool growable = false}) {
    return List<R>.from(
      [item1, item2, item3],
      growable: growable,
    );
  }

  factory Tuple3.fromList(List list) {
    return Tuple3(list[0], list[1], list[2]);
  }
}

class Tuple4<T1, T2, T3, T4> extends BaseTuple {
  T1 item1;
  T2 item2;
  T3 item3;
  T4 item4;

  Tuple4(this.item1, this.item2, this.item3, this.item4);

  @override
  List<R> toTypeList<R>({bool growable = false}) {
    return List<R>.from(
      [item1, item2, item3, item4],
      growable: growable,
    );
  }

  factory Tuple4.fromList(List list) {
    return Tuple4(list[0], list[1], list[2], list[3]);
  }
}

class Tuple5<T1, T2, T3, T4, T5> extends BaseTuple {
  T1 item1;
  T2 item2;
  T3 item3;
  T4 item4;
  T5 item5;

  Tuple5(this.item1, this.item2, this.item3, this.item4, this.item5);

  @override
  List<R> toTypeList<R>({bool growable = false}) {
    return List<R>.from(
      [item1, item2, item3, item4, item5],
      growable: growable,
    );
  }

  factory Tuple5.fromList(List list) {
    return Tuple5(list[0], list[1], list[2], list[3], list[4]);
  }
}

class Tuple6<T1, T2, T3, T4, T5, T6> extends BaseTuple {
  T1 item1;
  T2 item2;
  T3 item3;
  T4 item4;
  T5 item5;
  T6 item6;

  Tuple6(this.item1, this.item2, this.item3, this.item4, this.item5, this.item6);

  @override
  List<R> toTypeList<R>({bool growable = false}) {
    return List<R>.from(
      [item1, item2, item3, item4, item5, item6],
      growable: growable,
    );
  }

  factory Tuple6.fromList(List list) {
    return Tuple6(list[0], list[1], list[2], list[3], list[4], list[5]);
  }
}

class Tuple7<T1, T2, T3, T4, T5, T6, T7> extends BaseTuple {
  T1 item1;
  T2 item2;
  T3 item3;
  T4 item4;
  T5 item5;
  T6 item6;
  T7 item7;

  Tuple7(this.item1, this.item2, this.item3, this.item4, this.item5, this.item6, this.item7);

  @override
  List<R> toTypeList<R>({bool growable = false}) {
    return List<R>.from(
      [item1, item2, item3, item4, item5, item6, item7],
      growable: growable,
    );
  }

  factory Tuple7.fromList(List list) {
    return Tuple7(list[0], list[1], list[2], list[3], list[4], list[5], list[6]);
  }
}

typedef ValueTuple2WidgetBuilder<T, T2> = Widget Function(
    BuildContext context, Tuple2<T, T2> value, Widget? child);

typedef ValueTuple3WidgetBuilder<T, T2, T3> = Widget Function(
    BuildContext context, Tuple3<T, T2, T3> value, Widget? child);

typedef ValueTuple4WidgetBuilder<T, T2, T3, T4> = Widget Function(
    BuildContext context, Tuple4<T, T2, T3, T4> value, Widget? child);

typedef ValueTuple5WidgetBuilder<T, T2, T3, T4, T5> = Widget Function(
    BuildContext context, Tuple5<T, T2, T3, T4, T5> value, Widget? child);

typedef ValueTuple6WidgetBuilder<T, T2, T3, T4, T5, T6> = Widget Function(
    BuildContext context, Tuple6<T, T2, T3, T4, T5, T6> value, Widget? child);

typedef ValueTuple7WidgetBuilder<T, T2, T3, T4, T5, T6, T7> = Widget Function(
    BuildContext context,
    Tuple7<T, T2, T3, T4, T5, T6, T7> value,
    Widget? child);

typedef ValueListWidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> value, Widget? child);

class ValueListenableTuple2Builder<T1, T2> extends ValueListenableListBuilder {
  ValueListenableTuple2Builder({
    super.key,
    required Tuple2<ValueListenable<T1>, ValueListenable<T2>> valueListenables,
    required ValueTuple2WidgetBuilder<T1, T2> builder,
    super.child,
  }) : super(
    valueListenables:
    valueListenables.toTypeList<ValueListenable<dynamic>>(),
    builder: (context, value, child) =>
        builder(context, Tuple2.fromList(value), child),
  );
}

class ValueListenableTuple3Builder<T1, T2, T3>
    extends ValueListenableListBuilder {
  ValueListenableTuple3Builder({
    super.key,
    required Tuple3<ValueListenable<T1>, ValueListenable<T2>,
        ValueListenable<T3>>
    valueListenables,
    required ValueTuple3WidgetBuilder<T1, T2, T3> builder,
    super.child,
  }) : super(
    valueListenables:
    valueListenables.toTypeList<ValueListenable<dynamic>>(),
    builder: (context, value, child) =>
        builder(context, Tuple3.fromList(value), child),
  );
}

class ValueListenableTuple4Builder<T1, T2, T3, T4>
    extends ValueListenableListBuilder {
  ValueListenableTuple4Builder({
    super.key,
    required Tuple4<ValueListenable<T1>, ValueListenable<T2>,
        ValueListenable<T3>, ValueListenable<T4>>
    valueListenables,
    required ValueTuple4WidgetBuilder<T1, T2, T3, T4> builder,
    super.child,
  }) : super(
    valueListenables:
    valueListenables.toTypeList<ValueListenable<dynamic>>(),
    builder: (context, value, child) =>
        builder(context, Tuple4.fromList(value), child),
  );
}

class ValueListenableTuple5Builder<T1, T2, T3, T4, T5>
    extends ValueListenableListBuilder {
  ValueListenableTuple5Builder({
    super.key,
    required Tuple5<ValueListenable<T1>, ValueListenable<T2>,
        ValueListenable<T3>, ValueListenable<T4>, ValueListenable<T5>>
    valueListenables,
    required ValueTuple5WidgetBuilder<T1, T2, T3, T4, T5> builder,
    super.child,
  }) : super(
    valueListenables:
    valueListenables.toTypeList<ValueListenable<dynamic>>(),
    builder: (context, value, child) =>
        builder(context, Tuple5.fromList(value), child),
  );
}

class ValueListenableTuple6Builder<T1, T2, T3, T4, T5, T6>
    extends ValueListenableListBuilder {
  ValueListenableTuple6Builder({
    super.key,
    required Tuple6<
        ValueListenable<T1>,
        ValueListenable<T2>,
        ValueListenable<T3>,
        ValueListenable<T4>,
        ValueListenable<T5>,
        ValueListenable<T6>>
    valueListenables,
    required ValueTuple6WidgetBuilder<T1, T2, T3, T4, T5, T6> builder,
    super.child,
  }) : super(
    valueListenables:
    valueListenables.toTypeList<ValueListenable<dynamic>>(),
    builder: (context, value, child) =>
        builder(context, Tuple6.fromList(value), child),
  );
}

class ValueListenableTuple7Builder<T1, T2, T3, T4, T5, T6, T7> extends ValueListenableListBuilder {
  ValueListenableTuple7Builder({
    super.key,
    required Tuple7<
        ValueListenable<T1>,
        ValueListenable<T2>,
        ValueListenable<T3>,
        ValueListenable<T4>,
        ValueListenable<T5>,
        ValueListenable<T6>,
        ValueListenable<T7>>
    valueListenables,
    required ValueTuple7WidgetBuilder<T1, T2, T3, T4, T5, T6, T7> builder,
    super.child,
  }) : super(
    valueListenables: valueListenables.toTypeList<ValueListenable<dynamic>>(),
    builder: (context, value, child) =>
        builder(context, Tuple7.fromList(value), child),
  );
}

class ValueListenableListBuilder<T> extends StatefulWidget {
  const ValueListenableListBuilder({
    super.key,
    required this.valueListenables,
    required this.builder,
    this.child,
  });

  final List<ValueListenable<T>> valueListenables;

  final ValueListWidgetBuilder<T> builder;

  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ValueListenableListBuilderState<T>();
}

class _ValueListenableListBuilderState<T>
    extends State<ValueListenableListBuilder<T>> {
  late List<ValueListenable<T>> value;

  @override
  void initState() {
    super.initState();
    value = widget.valueListenables;
    for (var element in widget.valueListenables) {
      element.addListener(_valueChanged);
    }
  }

  @override
  void didUpdateWidget(ValueListenableListBuilder<T> oldWidget) {
    if (!const DeepCollectionEquality()
        .equals(oldWidget.valueListenables, widget.valueListenables)) {
      _removeListener(oldWidget);
      value = widget.valueListenables;
      _removeListener(widget);
    }
    super.didUpdateWidget(oldWidget);
  }

  _removeListener(ValueListenableListBuilder widget) {
    for (var element in widget.valueListenables) {
      element.removeListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    _removeListener(widget);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      value = List.of(widget.valueListenables);
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = value.map((e) => e.value).toList();
    return widget.builder(context, result, widget.child);
  }
}

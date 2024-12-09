import 'package:flutter/material.dart';

class TGRouteObserver<R extends Route<dynamic>?> extends NavigatorObserver {
  static const String tag = "TGRouteObserver";
  String? previousPage;
  String? currentPage;

  final Map<R, Set<TGRouteAware>> _listeners = <R, Set<TGRouteAware>>{};

  /// Whether this observer is managing changes for the specified route.
  ///
  /// If asserts are disabled, this method will throw an exception.
  @visibleForTesting
  bool? debugObservingRoute(R route) {
    bool? contained;
    assert(() {
      contained = _listeners.containsKey(route);
      return true;
    }());
    return contained;
  }

  /// Subscribe [routeAware] to be informed about changes to [route].
  ///
  /// Going forward, [routeAware] will be informed about qualifying changes
  /// to [route], e.g. when [route] is covered by another route or when [route]
  /// is popped off the [Navigator] stack.
  void subscribe(TGRouteAware routeAware, R route) {
    assert(route != null);
    final Set<TGRouteAware> subscribers = _listeners.putIfAbsent(route, () => <TGRouteAware>{});
    if (subscribers.add(routeAware)) {
      routeAware.didPush();
    }
  }

  /// Unsubscribe [routeAware].
  ///
  /// [routeAware] is no longer informed about changes to its route. If the given argument was
  /// subscribed to multiple types, this will unregister it (once) from each type.
  void unsubscribe(TGRouteAware routeAware) {
    final List<R> routes = _listeners.keys.toList();
    for (final R route in routes) {
      final Set<TGRouteAware>? subscribers = _listeners[route];
      if (subscribers != null) {
        subscribers.remove(routeAware);
        if (subscribers.isEmpty) {
          _listeners.remove(route);
        }
      }
    }
  }

  /// 从[route] pop 到 [previousRoute]
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is R && previousRoute is R) {
      final List<TGRouteAware>? previousSubscribers = _listeners[previousRoute]?.toList();

      if (previousSubscribers != null) {
        for (final TGRouteAware routeAware in previousSubscribers) {
          routeAware.didPopNext();
        }
      }

      final List<TGRouteAware>? subscribers = _listeners[route as R]?.toList();

      if (subscribers != null) {
        for (final TGRouteAware routeAware in subscribers) {
          routeAware.didPop();
        }
      }
      currentPage = previousRoute?.settings.name;
      previousPage = route.settings.name;
    }
  }

  /// 从[previousRoute] push 到 [route]
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is R && previousRoute is R) {
      final Set<TGRouteAware>? previousSubscribers = _listeners[previousRoute];

      if (previousSubscribers != null) {
        for (final TGRouteAware routeAware in previousSubscribers) {
          routeAware.didPushNext();
        }
      }
    }
    previousPage = previousRoute?.settings.name;
    currentPage = route.settings.name;
  }
}

mixin TGRouteAware {
  /// Called when the top route has been popped off, and the current route
  /// shows up.
  void didPopNext() {}

  /// Called when the current route has been pushed.
  void didPush() {}

  /// Called when the current route has been popped off.
  void didPop() {}

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  void didPushNext() {}
}

TGRouteObserver pageRouter = TGRouteObserver();
import 'package:flutter/material.dart';

class TGRouteObserver<R extends Route<dynamic>?> extends NavigatorObserver {
  static const String tag = "TGRouteObserver";
  // String? previousPage;
  // String? currentPage;

  final Map<R, Set<TGRouteAware>> _listeners = <R, Set<TGRouteAware>>{};

  void subscribe(TGRouteAware routeAware, R route) {
    assert(route != null);
    final Set<TGRouteAware> subscribers = _listeners.putIfAbsent(route, () => <TGRouteAware>{});
    subscribers.add(routeAware);
  }

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
    hasDidPop = true;
    if (route is R && previousRoute is R) {
      final List<TGRouteAware>? previousSubscribers = _listeners[previousRoute]?.toList();

      if (previousSubscribers != null) {
        for (final TGRouteAware routeAware in previousSubscribers) {
          routeAware.didPopNext();
        }
      }
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
  }

  Route? targetRoute;
  bool hasDidPop = false;

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    targetRoute = previousRoute;
    if (route is R && previousRoute is R) {
      final Set<TGRouteAware>? previousSubscribers = _listeners[previousRoute];
      if (previousSubscribers != null) {
        for (final TGRouteAware routeAware in previousSubscribers) {
          routeAware.willPopFromNext();
        }
      }
    }
  }

  @override
  void didStopUserGesture() {
    print('didStopUserGesture');
    final t = hasDidPop;
    hasDidPop = false;
    if (!t) {
      if (targetRoute is R) {
        print(targetRoute);
        print(_listeners);
        final Set<TGRouteAware>? previousSubscribers = _listeners[targetRoute];
        if (previousSubscribers != null) {
          print('cancelPopFromNext');
          for (final TGRouteAware routeAware in previousSubscribers) {
            routeAware.cancelPopFromNext();
          }
        }
      }
    }
    targetRoute = null;
  }
}

mixin TGRouteAware {
  void didPopNext() {}

  void didPushNext() {}

  void willPopFromNext() {}

  void cancelPopFromNext() {}
}
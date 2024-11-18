import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:persistent_bottom_nav_go_router/api/api.dart';

import 'api/api_service.dart';


final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();


final _router = GoRouter(
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return PersistentBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MyHomePage(title: 'Home'),
        ),
        GoRoute(
          path: '/second',
          builder: (context, state) => const MySecondPage(),
        ),
        GoRoute(
          path: '/third',
          builder: (context, state) => const MyThirdPage(),
        ),
      ],
    ),
  ],
);

class PersistentBottomNavBar extends StatefulWidget {
  final Widget child;

  const PersistentBottomNavBar({required this.child, super.key});

  @override
  State<PersistentBottomNavBar> createState() => _PersistentBottomNavBarState();
}

class _PersistentBottomNavBarState extends State<PersistentBottomNavBar> {
  int _selectedIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update selected index based on current route
    final String location = GoRouterState.of(context).uri.path;
    _updateIndex(location);  }

  void _updateIndex(String location) {
    setState(() {
      switch (location) {
        case '/':
          _selectedIndex = 0;
          break;
        case '/second':
          _selectedIndex = 1;
          break;
        case '/third':
          _selectedIndex = 2;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/second');
              break;
            case 2:
              context.go('/third');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Second',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Third',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/second');
              },
              child: const Text('Go to second page'),
            ),
            ElevatedButton(
              onPressed: () {
                ApiService().get();
              },
              child: const Text('Make request'),
            ),
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MySecondPage extends StatelessWidget {
  const MySecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the second page',
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/third');
              },
              child: const Text('Go to third page'),
            ),
          ],
        ),
      ),
    );
  }
}


class MyThirdPage extends StatelessWidget {
  const MyThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the third page',
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Go to home page'),
            ),
          ],
        ),
      ),
    );
  }
}
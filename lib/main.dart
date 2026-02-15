import 'package:flutter/material.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatelessWidget {
  const CounterImageToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _isDark = false;
  bool _isFirstImage = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: 1.0, // start visible
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // -------- Counter --------
  void _incrementCounter() => setState(() => _counter++);

  void plusfive() => setState(() => _counter += 5);

  void plusten() => setState(() => _counter += 10);

  void minusone() =>
      setState(() => _counter = (_counter - 1).clamp(0, 1 << 30));

  void minusfive() =>
      setState(() => _counter = (_counter - 5).clamp(0, 1 << 30));

  void minusten() =>
      setState(() => _counter = (_counter - 10).clamp(0, 1 << 30));

  void reset() => setState(() => _counter = 0);

  // -------- Theme --------
  void _toggleTheme() => setState(() => _isDark = !_isDark);

  // -------- Image Toggle + Animation --------
  Future<void> _toggleImage() async {
    await _controller.reverse(); // fade out
    setState(() => _isFirstImage = !_isFirstImage); // swap image
    await _controller.forward(); // fade in
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CW1 Counter & Toggle'),
          actions: [
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _incrementCounter,
                child: const Text('+1'),
              ),
              ElevatedButton(
                onPressed: plusfive,
                child: const Text('+5'),
              ),
              ElevatedButton(
                onPressed: plusten,
                child: const Text('+10'),
              ),

              ElevatedButton(
                onPressed: _counter == 0 ? null : minusone,
                child: const Text('-1'),
              ),
              ElevatedButton(
                onPressed: _counter == 0 ? null : minusfive,
                child: const Text('-5'),
              ),
              ElevatedButton(
                onPressed: _counter == 0 ? null : minusten,
                child: const Text('-10'),
              ),

              ElevatedButton(
                onPressed: reset,
                child: const Text('Set to zero'),
              ),

              const SizedBox(height: 24),

              FadeTransition(
                opacity: _fade,
                child: Image.asset(
                  _isFirstImage
                      ? 'assets/images/image1.png'
                      : 'assets/images/images2.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

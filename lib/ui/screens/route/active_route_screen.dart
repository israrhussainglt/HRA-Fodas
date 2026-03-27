import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveRouteScreen extends ConsumerStatefulWidget {
  final String routeId;

  const ActiveRouteScreen({
    super.key,
    required this.routeId,
  });

  @override
  ConsumerState<ActiveRouteScreen> createState() => _ActiveRouteScreenState();
}

class _ActiveRouteScreenState extends ConsumerState<ActiveRouteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Route'),
      ),
      body: Center(
        child: Text('Route ID: ${widget.routeId}'),
      ),
    );
  }
}

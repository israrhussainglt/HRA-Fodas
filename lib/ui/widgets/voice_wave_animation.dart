import 'package:flutter/material.dart';
import 'dart:math' as math;

class VoiceWaveAnimation extends StatefulWidget {
  final double soundLevel;
  final Color color;
  final int barCount;

  const VoiceWaveAnimation({
    super.key,
    required this.soundLevel,
    this.color = Colors.green,
    this.barCount = 5,
  });

  @override
  State<VoiceWaveAnimation> createState() => _VoiceWaveAnimationState();
}

class _VoiceWaveAnimationState extends State<VoiceWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            return _buildBar(index);
          }),
        );
      },
    );
  }

  Widget _buildBar(int index) {
    // Calculate height based on sound level and animation
    final baseHeight = 8.0;
    final maxHeight = 40.0;

    // Create wave effect by offsetting each bar's animation
    final offset = (index / widget.barCount) * 2 * math.pi;
    final animValue = math.sin(_controller.value * 2 * math.pi + offset);

    // Combine sound level with animation
    final soundMultiplier = (widget.soundLevel * 2).clamp(0.3, 1.0);
    final height =
        baseHeight +
        (maxHeight - baseHeight) * soundMultiplier * (animValue * 0.5 + 0.5);

    return Container(
      width: 4,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class VoiceInputDialog extends StatefulWidget {
  final String language;
  final Function(String text) onResult;
  final VoidCallback onCancel;

  const VoiceInputDialog({
    super.key,
    required this.language,
    required this.onResult,
    required this.onCancel,
  });

  @override
  VoiceInputDialogState createState() => VoiceInputDialogState();
}

class VoiceInputDialogState extends State<VoiceInputDialog> {
  double _soundLevel = 0.0;
  String _recognizedText = '';
  bool _isListening = false;
  String _statusMessage = 'Initializing...';

  void updateSoundLevel(double level) {
    if (mounted) {
      setState(() {
        _soundLevel = level;
      });
    }
  }

  void updateRecognizedText(String text) {
    if (mounted) {
      setState(() {
        _recognizedText = text;
        if (text.isNotEmpty) {
          _statusMessage = 'Listening...';
        }
      });
    }
  }

  void setListening(bool listening) {
    if (mounted) {
      setState(() {
        _isListening = listening;
        _statusMessage = listening ? 'Listening...' : 'Tap mic to start';
      });
    }
  }

  void setStatus(String status) {
    if (mounted) {
      setState(() {
        _statusMessage = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.mic,
                  color: _isListening ? Colors.green : Colors.grey,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Voice Input',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancel,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Wave animation or loading
            if (_isListening) ...[
              SizedBox(
                height: 60,
                child: Center(
                  child: VoiceWaveAnimation(
                    soundLevel: _soundLevel,
                    color: Colors.green,
                    barCount: 7,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],

            const SizedBox(height: 24),

            // Recognized text
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 100, maxHeight: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _recognizedText.isNotEmpty
                      ? Colors.green.shade300
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _recognizedText.isEmpty
                      ? 'Speak now...\n\nYour speech will appear here in real-time.'
                      : _recognizedText,
                  style: TextStyle(
                    fontSize: 16,
                    color: _recognizedText.isEmpty
                        ? Colors.grey.shade500
                        : Colors.black87,
                    fontStyle: _recognizedText.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _recognizedText.isEmpty
                        ? null
                        : () {
                            widget.onResult(_recognizedText);
                            Navigator.pop(context);
                          },
                    icon: const Icon(Icons.check),
                    label: const Text('Use Text'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

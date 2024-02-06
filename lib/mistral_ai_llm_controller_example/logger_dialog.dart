import 'package:flutter/material.dart';

class LoggerDialog extends StatelessWidget {
  const LoggerDialog({
    required this.logger,
    required this.errorMessage,
    super.key,
  });

  final String logger;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (logger.isNotEmpty)
                    SelectableText(
                      'Logger: $logger',
                      style: const TextStyle(color: Colors.green),
                    ),
                  if (errorMessage.isNotEmpty)
                    SelectableText(
                      'Error message: $errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

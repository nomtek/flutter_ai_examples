import 'package:flutter/material.dart';

class MistralAiLlmControllerPage extends StatefulWidget {
  const MistralAiLlmControllerPage({super.key});

  @override
  State<MistralAiLlmControllerPage> createState() =>
      _MistralAiLlmControllerPageState();
}

class _MistralAiLlmControllerPageState
    extends State<MistralAiLlmControllerPage> {
  final TextEditingController commandInputController = TextEditingController();
  int sound = 50;
  int temperature = 20;
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MistralAI LLM Controller'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Color'),
                      subtitle: Container(
                        color: Colors.red,
                        height: 50,
                      ),
                    ),
                    ListTile(
                      title: Text('Sound: $sound '),
                      subtitle: Slider(
                        min: 0,
                        max: 100,
                        value: sound.toDouble(),
                        onChanged: (value) => setState(
                          () => sound = value.toInt(),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Temperature (Celsius): $temperature'),
                      subtitle: Slider(
                        min: 15,
                        max: 25,
                        value: temperature.toDouble(),
                        onChanged: (value) => setState(
                          () => temperature = value.toInt(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: commandInputController,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  suffixIcon: showLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {},
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

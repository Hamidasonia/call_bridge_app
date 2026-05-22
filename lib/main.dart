import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const platform = MethodChannel('call_bridge');

  final TextEditingController phoneController =
      TextEditingController();

  Future<void> makeCall() async {

    final phoneNumber = phoneController.text;

    if (phoneNumber.isEmpty) {
      return;
    }

    try {
      await platform.invokeMethod(
        'makeCall',
        {
          'phoneNumber': phoneNumber,
        },
      );
    } on PlatformException catch (e) {
      debugPrint(
        'Failed to open dialer: ${e.message}',
      );
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Bridge'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextFormField(
              controller: phoneController,

              keyboardType: TextInputType.phone,

              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: '+628123456789',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: makeCall,
                child: const Text('Open Dialer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
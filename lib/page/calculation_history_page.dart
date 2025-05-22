import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/calculator_controller.dart';

class CalculationHistoryPage extends StatefulWidget {
  const CalculationHistoryPage({super.key});

  @override
  State<CalculationHistoryPage> createState() => _CalculationHistoryPageState();
}

class _CalculationHistoryPageState extends State<CalculationHistoryPage> {
  final CalculatorController controller = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: BackButton(color: Colors.white),
        title: const Text("History"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      body: Obx(() => ListView.builder(
          itemCount: controller.history.length,
          itemBuilder: (context, index) {
            final entry = controller.history[index];
            final parts = entry.split(", "); // Split into "Output" and "Result"
            final output = parts[0].replaceFirst("Output: ", "");
            final result = parts[1].replaceFirst("Result: ", "");

            return Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      output,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "= $result",
                      style: const TextStyle(color: Colors.grey, fontSize: 24),
                    ),
                  ),
                  const Divider()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
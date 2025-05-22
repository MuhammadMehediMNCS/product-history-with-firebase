import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class CalculatorController extends GetxController {
  var output = "0".obs;
  var result = 0.0.obs;
  var memory = 0.0.obs;
  var resultList = <double>[].obs;
  var showGT = false.obs;

  final box = GetStorage();
  var history = <String>[].obs;
  final int historyLimit = 5;

  @override
  void onInit() {
    super.onInit();
    // Load history from storage
    List<String>? savedHistory = box.read<List<dynamic>>('history')?.cast<String>();
    if (savedHistory != null) {
      history.assignAll(savedHistory);
    }
  }

  void addToHistory(String output, String result) {
    final entry = "Output: $output, Result: $result";

    // Add to history with limit
    if (history.length >= historyLimit) {
      history.removeAt(0); // Remove the oldest item
    }
    history.add(entry);

    // Save to storage
    box.write('history', history);
  }

  void buttonPressed(String buttonText) {
    if (buttonText == "C") {
      output.value = "0";
      result.value = 0.0;
    } else if (buttonText == "AC") {
      output.value = "0";
      result.value = 0.0;
      resultList.clear();
      showGT.value = false;
    } else if (buttonText == "⌫") {
      if (output.value.length > 1) {
        output.value = output.value.substring(0, output.value.length - 1);
        evaluateCurrentExpression();
      } else {
        output.value = "0";
        result.value = 0.0;
      }
    } else if (["+", "-", "x", "÷"].contains(buttonText)) {
    if (!output.value.endsWith(" ")) {
      output.value += buttonText;  // If I want space every value " $buttonText ";
    }
  } else if (buttonText == "=") {
    evaluateCurrentExpression();

    // Format the output value
    String formattedOutput = output.value.trim();
    output.value = result.value % 1 == 0
        ? result.value.toInt().toString()
        : result.value.toString();

    addToHistory(formattedOutput, result.value.toString());
    resultList.add(result.value);
    result.value = 0;
    showGT.value = true;
    } else if (buttonText == "M+") {
      memory.value += double.tryParse(output.value) ?? 0.0;
      output.value = "0";
      result.value = 0;
    } else if (buttonText == "M-") {
      memory.value -= double.tryParse(output.value) ?? 0.0;
      output.value = "0";
      result.value = 0;
    } else if (buttonText == "MRC") {
      output.value = memory.toString();
      memory.value = 0;
    } else if (buttonText == "GT") {
      double sum = resultList.fold(0.0, (acc, val) => acc + val);
      output.value = sum.toString();
      result.value = 0;
    } else if (buttonText == "√") {
      result.value = sqrt(double.tryParse(output.value) ?? 0.0);
      output.value = result.toString();
    } else if (buttonText == "%") {
      try {
        String expression = output.value.trim();

        // If the expression contains an operator, process the percentage
        if (expression.contains(RegExp(r'[+\-x÷]'))) {
          // Split the expression into parts
          List<String> parts = expression.split(RegExp(r'[\s+\-x÷]')).where((s) => s.isNotEmpty).toList();

          if (parts.isNotEmpty) {
            double lastValue = double.tryParse(parts.last) ?? 0.0;
            double percentage = lastValue / 100;

            // Replace the last value with its percentage equivalent in the expression
            output.value = expression.replaceFirst(RegExp(r'[\d.]+$'), percentage.toString());
            evaluateCurrentExpression(); // Recalculate the result
          }
        } else {
          // Single number: Convert to percentage of 1
          double currentValue = double.tryParse(expression) ?? 0.0;
          result.value = currentValue / 100;

          output.value = result.value % 1 == 0
              ? result.value.toInt().toString()
              : result.value.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
        }
      } catch (e) {
        output.value = "Error";
      }
    } else {
      if (output.value == "0") {
        output.value = buttonText;
      } else if (output.value.length < 100) {
        output.value += buttonText;
      }
      evaluateCurrentExpression();
    }
  }

  void evaluateCurrentExpression() {
    String expression = output.value;

    // Replace symbols for math_expressions
    expression = expression.replaceAll('x', '*').replaceAll('÷', '/');

    try {
      // ignore: deprecated_member_use
      Parser parser = Parser();
      Expression exp = parser.parse(expression);

      ContextModel cm = ContextModel();
      double evaluatedResult = exp.evaluate(EvaluationType.REAL, cm);

      // Format result as integer or fractional
      if (evaluatedResult % 1 == 0) {
        result.value = evaluatedResult.toInt().toDouble(); // Ensure it remains double for consistency
      } else {
        result.value = evaluatedResult;
      }
    } catch (e) {
      result.value = 0.0; // Reset to 0 on invalid expression
    }
  }
}
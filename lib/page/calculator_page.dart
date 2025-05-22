import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_product/controller/calculator_controller.dart';
import 'package:my_product/page/calculation_history_page.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorController controller = Get.put(CalculatorController());

  double _getFontSize(String output) {
    return output.length > 24 ? 22.0 : 28.0;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 16),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Obx(() => Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            controller.output.value,
                            style: TextStyle(
                              fontSize: _getFontSize(controller.output.value),
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Obx(() => Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.showGT.value ? "GT" : "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                controller.result.value.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: IconButton(
                          onPressed: () {
                            Get.to(() => const CalculationHistoryPage());
                          }, 
                          icon: const Icon(Icons.history, size: 32,)
                        )
                      ),
                      Obx(() => Flexible(
                        child: buildButton(
                            buttonColor: Colors.white,
                            size: const Size(80, 60),
                            borderColor: controller.output.value == "0" ? Colors.grey : Colors.pink,
                            textColor: controller.output.value == "0" ? Colors.grey :  Colors.pink,
                            fontSize: 28,
                            buttonText: '⌫',
                            isInitial: false
                          ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 18,
                              buttonText: 'AC'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 10,
                              buttonText: 'MRC'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 16,
                              buttonText: 'M+'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 16,
                              buttonText: 'M-'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 16,
                              buttonText: 'GT'
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.red,
                              fontSize: 28,
                              buttonText: 'C'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '7'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '8'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '9'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 24,
                              buttonText: '÷'
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '√'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '4'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '5'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '6'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 22,
                              buttonText: 'x'
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '%'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '1'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '2'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 20,
                              buttonText: '3'
                            ),
                          ),
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.pink,
                              textColor: Colors.pink,
                              fontSize: 24,
                              buttonText: '-'
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: buildButton(
                              buttonColor: Colors.white,
                              borderColor: Colors.black45,
                              textColor: Colors.black,
                              fontSize: 24,
                              buttonText: '.'
                            ),
                          ),
                          buildButton(
                            buttonColor: Colors.white,
                            borderColor: Colors.black45,
                            textColor: Colors.black,
                            fontSize: 20,
                            buttonText: '0'
                          ),
                          buildButton(
                            buttonColor: Colors.white,
                            borderColor: Colors.black45,
                            textColor: Colors.black,
                            fontSize: 20,
                            buttonText: '00'
                          ),
                          buildButton(
                            buttonColor: Colors.pink,
                            textColor: Colors.white,
                            fontSize: 24,
                            buttonText: '='
                          ),
                          buildButton(
                            buttonColor: Colors.white,
                            borderColor: Colors.pink,
                            textColor: Colors.pink,
                            fontSize: 24,
                            buttonText: '+'
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton({
  required Color buttonColor,
  Size? size,
  Color? borderColor,
  required Color textColor,
  required double fontSize,
  required String buttonText,
  bool isInitial = true
}) {
    return ElevatedButton(
      onPressed: () => controller.buttonPressed(buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        elevation: 0,
        minimumSize: size ?? const Size(48, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: BorderSide(color: borderColor ?? Colors.transparent)
      ),
      child: Text(
          buttonText,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        )
    );
  }
}
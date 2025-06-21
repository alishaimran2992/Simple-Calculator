import 'package:flutter/material.dart';
import 'package:simple_calculator/constants.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApplication());
}

class CalculatorApplication extends StatefulWidget {
  const CalculatorApplication({super.key});

  @override
  State<CalculatorApplication> createState() => _CalculatorApplicationState();
}

class _CalculatorApplicationState extends State<CalculatorApplication> {
  var result = '0';
  var inputUser = '';

  void buttonPressed(String text) {
    if (isOperator(text) && inputUser.isNotEmpty) {
      String lastChar = inputUser[inputUser.length - 1];
      if (isOperator(lastChar)) return; // Prevent duplicate operators
    }

    if (text == '%') {
      setState(() {
        inputUser += '/100';
      });
    } else {
      setState(() {
        inputUser += text;
      });
    }
  }

  Widget getRow(String text1, String text2, String text3, String text4) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(text1),
        buildButton(text2),
        buildButton(text3),
        buildButton(text4),
      ],
    );
  }

  Widget buildButton(String text) {
    return RawMaterialButton(
      onPressed: () {
        if (text == 'AC') {
          setState(() {
            inputUser = '';
            result = '0';
          });
        } else if (text == 'CE') {
          setState(() {
            if (inputUser.isNotEmpty) {
              inputUser = inputUser.substring(0, inputUser.length - 1);
            }
          });
        } else if (text == '=') {
          try {
            final parser = Parser();
            Expression expression = parser.parse(inputUser);
            ContextModel contextModel = ContextModel();
            double eval = expression.evaluate(EvaluationType.REAL, contextModel);

            setState(() {
              result = eval.toString().endsWith('.0')
                  ? eval.toStringAsFixed(0)
                  : eval.toString();
            });
          } catch (e) {
            setState(() {
              result = 'Error';
            });
          }
        } else {
          buttonPressed(text);
        }
      },
      elevation: 2.0,
      fillColor: text == '=' ? kAmber : getBackgroundColor(text),
      child: Text(
        text,
        style: TextStyle(
          color: text == '=' ? kWhite : getTextColor(text),
          fontSize: text == '=' ? 40 : 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: EdgeInsets.all(20.0),
      shape: CircleBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBlack,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            inputUser,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '=',
                            style: TextStyle(
                              color: kLightGray,
                              fontSize: 80,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              result,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 65,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 5),
                      getRow('AC', 'CE', '%', '/'),
                      getRow('1', '2', '3', '*'),
                      getRow('4', '5', '6', '-'),
                      getRow('7', '8', '9', '+'),
                      getRow('00', '0', '.', '='),
                      Padding(padding: EdgeInsets.only(top: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isOperator(String text) {
    var list = ['+', '-', '*', '/', '%', '.'];
    return list.contains(text);
  }

  Color getBackgroundColor(String text) {
    if (text == 'AC' || text == 'CE' || text == '%') {
      return kLightGray;
    } else {
      return kDarkGray;
    }
  }

  Color getTextColor(String text) {
    if (text == 'AC' || text == 'CE' || text == '%') {
      return Colors.black;
    } else {
      return kWhite;
    }
  }
}

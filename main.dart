import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Flutter',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
      } else if (value == '=') {
        _calculateResult();
      } else {
        _expression += value;
      }
    });
  }

  void _calculateResult() {
    try {
      double eval = _evaluateExpression(_expression);
      _result = eval.toString();
    } catch (e) {
      _result = 'Błąd';
    }
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = _tokenize(expression);

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double left = double.parse(tokens[i - 1]);
        double right = double.parse(tokens[i + 1]);
        double result = tokens[i] == '*' ? left * right : left / right;
        tokens[i - 1] = result.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i--;
      }
    }

    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      double num = double.parse(tokens[i + 1]);
      if (tokens[i] == '+') {
        result += num;
      } else if (tokens[i] == '-') {
        result -= num;
      }
    }

    return result;
  }

  List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String temp = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char == ' ' || char == '') continue;

      if ('+-*/'.contains(char)) {
        if (temp.isNotEmpty) {
          tokens.add(temp);
          temp = '';
        }
        tokens.add(char);
      } else {
        temp += char;
      }
    }

    if (temp.isNotEmpty) {
      tokens.add(temp);
    }

    return tokens;
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.black87,
            padding: EdgeInsets.symmetric(vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 45, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calculator')),
      body: Column(
        children: [

          Expanded(
            child: Container(
              color: Colors.black12,
              padding: EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_expression, style: TextStyle(fontSize: 26, color: Colors.black87)),
                  SizedBox(height: 35),
                  Text(_result, style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          Column(
            children: [
              Row(
                children: [
                  _buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/')
                ],
              ),
              Row(
                children: [
                  _buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*')
                ],
              ),
              Row(
                children: [
                  _buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')
                ],
              ),
              Row(
                children: [
                  _buildButton('C', color: Colors.red), _buildButton('0'), _buildButton('=', color: Colors.green), _buildButton('+')
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:collection';
import 'dart:math';

enum Operator {
  Addition,
  Subtraction,
  Multiplication,
  Division,
  Modulo,
  Exponent,
  Null
}

class Evaluator {
  static bool _wasDigit;
  static String _number = '';
  static String _e = "2.71828182";
  static String _pi = "3.14159265";

  static double Evaluate(String expression) {
    Queue<double> Operators = new Queue<double>();
    Queue<String> Operands = new Queue<String>();

    // Format the expression so that its calculatable
    expression = expression.replaceAll("e", _e);
    expression = expression.replaceAll("π", _pi);

    // Do the calculations and return the result
    for (int i = 0; i < expression.length; i++) {
      String c = expression[i];

      if (_isDigit(c)) {
        _wasDigit = true;

        print('_number is $_number and c is $c');

        _number += c;
        if (i == expression.length - 1) // last iteration
        {
          double num = double.parse(_number);
          Operators.add(num);
          _wasDigit = false;
          _number = "";
        }
      } else {
        if (_wasDigit) // Add the previous number to our stack
        {
          double num = double.parse(_number);
          Operators.add(num);
          _wasDigit = false;
          _number = "";
        }

        if (_isLeftPar(c)) {
          Operands.add(c);
        } else if (_isRightPar(c)) {
          while (!_isLeftPar(c)) {
            double num1 = Operators.removeLast();
            double num2 = Operators.removeLast();
            String op = Operands.removeLast();
            double endResult = _calculateTwo(num1, num2, op);
            Operators.add(endResult);
            c = Operands.removeLast();
          }
        } else if (_isOperator(c)) {
          if (_wasDigit) // Add the previous number to our stack
          {
            double num = double.parse(_number);
            Operators.add(num);
            _wasDigit = false;
            _number = "";
          }

          bool empty = Operands.length == 0;
          if (!empty) {
            String c2 = Operands.last;
            if (_operatorNum(_operatorPower(c2)) >=
                _operatorNum(_operatorPower(c))) {
              double num1 = Operators.removeLast();
              double num2 = Operators.removeLast();
              String op = Operands.removeLast();

              double endResult = _calculateTwo(num1, num2, op);

              Operators.add(endResult);
            }
          }
          Operands.add(c);
        }
      }
    }

    while (Operands.length > 0) {
      double num1 = Operators.removeLast();
      double num2 = Operators.removeLast();
      String op = Operands.removeLast();

      double endResult = _calculateTwo(num1, num2, op);
      Operators.add(endResult);
    }

    return double.parse(Operators.removeLast().toStringAsFixed(8));
  }

  static bool _isDigit(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null || s == '.';
  }

  static bool _isOperator(String c) {
    return c == '+' || c == '-' || c == '*' || c == '/' || c == '%' || c == '^';
  }

  static bool _isLeftPar(String c) {
    return c == '(';
  }

  static bool _isRightPar(String c) {
    return c == ')';
  }

  static double _calculateTwo(double num1, double num2, String op) {
    double result = 0.0;
    if (op == '+')
      result = num2 + num1;
    else if (op == '-')
      result = num2 - num1;
    else if (op == '*')
      result = num2 * num1;
    else if (op == '/')
      result = num2 / num1;
    else if (op == '^')
      result = pow(num2, num1);
    else if (op == '%') result = num2 % num1;

    return result;
  }

  static Operator _operatorPower(String c) {
    if (c == '+')
      return Operator.Addition;
    else if (c == '-')
      return Operator.Subtraction;
    else if (c == '*')
      return Operator.Multiplication;
    else if (c == '/')
      return Operator.Division;
    else if (c == '%')
      return Operator.Modulo;
    else if (c == '^')
      return Operator.Exponent;
    else
      return Operator.Null;
  }

  static int _operatorNum(Operator op) {
    if (op == Operator.Addition)
      return 1;
    else if (op == Operator.Subtraction)
      return 1;
    else if (op == Operator.Multiplication)
      return 2;
    else if (op == Operator.Division)
      return 2;
    else if (op == Operator.Modulo)
      return 2;
    else if (op == Operator.Exponent)
      return 3;
    else
      return 0;
  }
}

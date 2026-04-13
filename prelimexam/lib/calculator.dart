import 'package:flutter/material.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // ============================================================
  // STATE VARIABLES (Do not modify these declarations)
  // ============================================================
  String _display = '0'; // Shows current number or result
  String _firstOperand = ''; // Stores first number before operator
  String _operator = ''; // Stores selected operation
  bool _shouldResetDisplay = false; // Flag for display reset
  String _expression = ''; // Shows the full expression

  // ============================================================
  // TASK 1: Complete initState() (10 points)
  //
  // Initialize all state variables to their default values.
  // Hint: Don't forget to call super.initState() first!
  // ============================================================
  @override
  void initState() {
    super.initState(); // Must be called first
    _display = '0';
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = false;
    _expression = '';
  }

  // ============================================================
  // TASK 2: Complete _onNumberPressed() (20 points)
  //
  // Handle when number buttons (0-9) are pressed.
  // ============================================================
  void _onNumberPressed(String number) {
    setState(() {
      // If we just showed a result/error, or display is '0', start fresh
      if (_shouldResetDisplay || _display == '0' || _display == 'Error') {
        _display = number;
        _shouldResetDisplay = false;
      } else if (_display.length < 12) {
        _display += number;
      }
    });
  }

  // ============================================================
  // TASK 3: Complete _onDecimalPressed() (15 points)
  //
  // Handle when the decimal point (.) button is pressed.
  // ============================================================
  void _onDecimalPressed() {
    setState(() {
      if (_shouldResetDisplay || _display == 'Error') {
        _display = '0.';
        _shouldResetDisplay = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  // ============================================================
  // TASK 4: Complete _onOperatorPressed() (20 points)
  //
  // Handle when operator buttons (+, -, ×, ÷, ^, %) are pressed.
  // ============================================================
  void _onOperatorPressed(String operator) {
    setState(() {
      if (_display == 'Error') {
        _resetAfterError();
        return;
      }

      _firstOperand = _display;
      _operator = operator;
      _expression = '$_display $operator';
      _shouldResetDisplay = true;
    });
  }

  // ============================================================
  // TASK 5: Complete _onScientificPressed() (35 points)
  //
  // Handle scientific functions: sin, cos, tan, √, log, ln, x², π, e, ±
  // ============================================================
  void _onScientificPressed(String function) {
    setState(() {
      double num = double.tryParse(_display) ?? 0;
      double result;

      switch (function) {
        case 'sin':
          result = sin(num * pi / 180);
          _display = _formatResult(result);
          _expression = 'sin(${_trimTrailingDot(num) }°)';
          _shouldResetDisplay = true;
          break;

        case 'cos':
          result = cos(num * pi / 180);
          _display = _formatResult(result);
          _expression = 'cos(${_trimTrailingDot(num)}°)';
          _shouldResetDisplay = true;
          break;

        case 'tan':
          // Undefined at 90 + 180k degrees; use tolerance to detect
          double rem = num % 180;
          if ((rem - 90).abs() < 1e-10) {
            _display = 'Error';
            _expression = 'tan(${_trimTrailingDot(num)}°) undefined';
            _resetAfterError();
            return;
          }
          result = tan(num * pi / 180);
          _display = _formatResult(result);
          _expression = 'tan(${_trimTrailingDot(num)}°)';
          _shouldResetDisplay = true;
          break;

        case '√':
          if (num < 0) {
            _display = 'Error';
            _expression = '√(${_trimTrailingDot(num)}) invalid';
            _resetAfterError();
            return;
          }
          result = sqrt(num);
          _display = _formatResult(result);
          _expression = '√(${_trimTrailingDot(num)})';
          _shouldResetDisplay = true;
          break;

        case 'log':
          if (num <= 0) {
            _display = 'Error';
            _expression = 'log10(${_trimTrailingDot(num)}) invalid';
            _resetAfterError();
            return;
          }
          result = log(num) / ln10; // base-10 log
          _display = _formatResult(result);
          _expression = 'log(${_trimTrailingDot(num)})';
          _shouldResetDisplay = true;
          break;

        case 'ln':
          if (num <= 0) {
            _display = 'Error';
            _expression = 'ln(${_trimTrailingDot(num)}) invalid';
            _resetAfterError();
            return;
          }
          result = log(num); // natural log
          _display = _formatResult(result);
          _expression = 'ln(${_trimTrailingDot(num)})';
          _shouldResetDisplay = true;
          break;

        case 'x²':
          result = num * num;
          _display = _formatResult(result);
          _expression = '${_trimTrailingDot(num)}²';
          _shouldResetDisplay = true;
          break;

        case '±':
          result = -num;
          _display = _formatResult(result);
          _expression = 'negate(${_trimTrailingDot(num)})';
          _shouldResetDisplay = true;
          break;

        case 'π':
          _display = _formatResult(pi);
          _expression = 'π';
          _shouldResetDisplay = true;
          break;

        case 'e':
          _display = _formatResult(e);
          _expression = 'e';
          _shouldResetDisplay = true;
          break;

        default:
          break;
      }
    });
  }

  // ============================================================
  // PROVIDED FUNCTIONS (Do not modify below this line)
  // ============================================================

  // Calculate Result - Called when "=" is pressed
  void _calculate() {
    if (_firstOperand.isEmpty || _operator.isEmpty) return;

    double num1 = double.tryParse(_firstOperand) ?? 0;
    double num2 = double.tryParse(_display) ?? 0;
    double result = 0;

    setState(() {
      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '×':
          result = num1 * num2;
          break;
        case '÷':
          if (num2 == 0) {
            _display = 'Error';
            _expression = 'Cannot divide by zero';
            _resetAfterError();
            return;
          }
          result = num1 / num2;
          break;
        case '^':
          result = pow(num1, num2).toDouble();
          break;
        case '%':
          if (num2 == 0) {
            _display = 'Error';
            _expression = 'Cannot modulo by zero';
            _resetAfterError();
            return;
          }
          result = num1 % num2;
          break;
      }

      _expression =
          '$_firstOperand $_operator $_display = ${_formatResult(result)}';
      _display = _formatResult(result);
      _firstOperand = '';
      _operator = '';
      _shouldResetDisplay = true;
    });
  }

  // Clear Everything
  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = '';
      _operator = '';
      _shouldResetDisplay = false;
      _expression = '';
    });
  }

  // Clear Entry (only current display)
  void _clearEntry() {
    setState(() {
      _display = '0';
    });
  }

  // Backspace
  void _backspace() {
    setState(() {
      if (_display.length > 1 && _display != 'Error') {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  // Reset after error
  void _resetAfterError() {
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = true;
  }

  // Format result to remove unnecessary decimals
  String _formatResult(double result) {
    if (result.isNaN || result.isInfinite) {
      return 'Error';
    }
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    String formatted = result.toStringAsFixed(8);
    formatted = formatted.replaceAll(RegExp(r'0+$'), '');
    formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    return formatted;
  }

  // Helper to display clean numbers in expressions (e.g., 2.0 -> 2)
  String _trimTrailingDot(double value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toString();
  }

  // Build Calculator Button
  Widget _buildButton(
    String text, {
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onPressed,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: backgroundColor ?? const Color(0xFF333333),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Container(
              height: 65,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: text.length > 2 ? 18 : 24,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // UI BUILD METHOD (Do not modify)
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Exam'),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expression Display
                    Text(
                      _expression,
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    // Main Display
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Operator Indicator
                    if (_operator.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Operator: $_operator',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[800],
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),

            // Scientific Buttons Row 1
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton(
                    'sin',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('sin'),
                  ),
                  _buildButton(
                    'cos',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('cos'),
                  ),
                  _buildButton(
                    'tan',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('tan'),
                  ),
                  _buildButton(
                    'log',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('log'),
                  ),
                  _buildButton(
                    'ln',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('ln'),
                  ),
                ],
              ),
            ),

            // Scientific Buttons Row 2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton(
                    '√',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('√'),
                  ),
                  _buildButton(
                    'x²',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('x²'),
                  ),
                  _buildButton(
                    '^',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onOperatorPressed('^'),
                  ),
                  _buildButton(
                    'π',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('π'),
                  ),
                  _buildButton(
                    'e',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: () => _onScientificPressed('e'),
                  ),
                ],
              ),
            ),

            // Clear and Utility Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton(
                    'C',
                    backgroundColor: const Color(0xFFFF6B6B),
                    onPressed: _clear,
                  ),
                  _buildButton(
                    'CE',
                    backgroundColor: const Color(0xFFFF8E72),
                    onPressed: _clearEntry,
                  ),
                  _buildButton(
                    '⌫',
                    backgroundColor: const Color(0xFF505050),
                    onPressed: _backspace,
                  ),
                  _buildButton(
                    '%',
                    backgroundColor: const Color(0xFFFF9500),
                    onPressed: () => _onOperatorPressed('%'),
                  ),
                  _buildButton(
                    '÷',
                    backgroundColor: const Color(0xFFFF9500),
                    onPressed: () => _onOperatorPressed('÷'),
                  ),
                ],
              ),
            ),

            // Number Pad Row 1 (7, 8, 9, ×)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('7', onPressed: () => _onNumberPressed('7')),
                  _buildButton('8', onPressed: () => _onNumberPressed('8')),
                  _buildButton('9', onPressed: () => _onNumberPressed('9')),
                  _buildButton(
                    '×',
                    backgroundColor: const Color(0xFFFF9500),
                    onPressed: () => _onOperatorPressed('×'),
                  ),
                ],
              ),
            ),

            // Number Pad Row 2 (4, 5, 6, -)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('4', onPressed: () => _onNumberPressed('4')),
                  _buildButton('5', onPressed: () => _onNumberPressed('5')),
                  _buildButton('6', onPressed: () => _onNumberPressed('6')),
                  _buildButton(
                    '-',
                    backgroundColor: const Color(0xFFFF9500),
                    onPressed: () => _onOperatorPressed('-'),
                  ),
                ],
              ),
            ),

            // Number Pad Row 3 (1, 2, 3, +)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('1', onPressed: () => _onNumberPressed('1')),
                  _buildButton('2', onPressed: () => _onNumberPressed('2')),
                  _buildButton('3', onPressed: () => _onNumberPressed('3')),
                  _buildButton(
                    '+',
                    backgroundColor: const Color(0xFFFF9500),
                    onPressed: () => _onOperatorPressed('+'),
                  ),
                ],
              ),
            ),

            // Number Pad Row 4 (±, 0, ., =)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  _buildButton('±', onPressed: () => _onScientificPressed('±')),
                  _buildButton('0', onPressed: () => _onNumberPressed('0')),
                  _buildButton('.', onPressed: _onDecimalPressed),
                  _buildButton(
                    '=',
                    backgroundColor: const Color(0xFF34C759),
                    onPressed: _calculate,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
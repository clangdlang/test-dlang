module basic.gptcalc;

import std.stdio;
import std.conv;
import std.ascii;
import std.container.array;
import std.range;

void main()
{
	writeln("欢迎使用控制台计算器！");

	while (true)
	{
		string inputStr;
		write("> ");
		inputStr = readln();

		if (inputStr == "quit")
		{
			break;
		}

		try
		{
			double result = eval(inputStr);
			writeln(to!string(result));
		}
		catch (Exception t)
		{
			writeln("计算出错：", t.msg);
		}
	}
}

double eval(string expression)
{
	// 将表达式字符串转换为逆波兰表达式
	auto exprs = splitExpression(expression);
	writeln("exprs:", exprs);

	auto rpn = toRPN(splitExpression(expression));
	writeln("rpn:", rpn);

	// 使用栈来计算逆波兰表达式的值
	double[] stack;
	foreach (token; rpn)
	{
		if (isNumeric(token))
		{
			stack ~= to!double(token);
		}
		else
		{
			auto b = stack.back;
			stack.popBack();
			auto a = stack.back;
			stack.popBack();

			stack ~= calculate(a, b, token);
		}
	}

	// 栈中最后一个元素即为计算结果
	return stack[0];
}

string[] splitExpression(string expression)
{
	// 将表达式字符串拆分为一个个单独的符号
	string[] tokens;
	string currentToken;
	foreach (c; expression)
	{
		if (c.isDigit || c == '.')
		{
			currentToken ~= c;
		}
		else if (c.isAlpha)
		{
			currentToken ~= c.toUpper;
		}
		else if (currentToken.length > 0)
		{
			tokens ~= currentToken;
			currentToken = "";
		}

		if (c.isPunctuation ) {
			tokens ~= to!string(c);
		}
	}

	if (currentToken.length > 0)
	{
		tokens ~= currentToken;
	}

	return tokens;
}

string[] toRPN(string[] tokens)
{
	// 将中缀表达式转换为逆波兰表达式
	string[] rpn;
	string[] stack;

	foreach (token; tokens)
	{
		if (isNumeric(token))
		{
			rpn ~= token;
		}
		else if (token == "(")
		{
			stack ~= token;
		}
		else if (token == ")")
		{
			while (stack.length > 0 && stack[$ - 1] != "(")
			{
				rpn ~= stack.back;
				stack.popBack();
			}
			if (stack.length == 0)
			{
				throw new Exception("表达式中存在不匹配的括号。");
			}
			stack.popBack();
		}
		else
		{
			while (stack.length > 0 && priority(stack[$ - 1]) >= priority(token))
			{
				// rpn ~= stack.popLast();
				rpn ~= stack.back;
				stack.popBack();
			}
			stack ~= token;
		}
	}

	while (stack.length > 0)
	{
		if (stack[$ - 1] == "(")
		{
			throw new Exception("表达式中存在不匹配的括号。");
		}
		rpn ~= stack.back;
		stack.popBack();
	}

	return rpn;
}

double calculate(double a, double b, string op)
{
	// 执行基本的数学运算
	switch (op)
	{
	case "+":
		return a + b;
	case "-":
		return a - b;
	case "*":
		return a * b;
	case "/":
		if (b == 0)
		{
			throw new Exception("除数不能为0。");
		}
		return a / b;
	default:
		throw new Exception("不支持的运算符" ~ op ~ "。");
	}
}

int priority(string op)
{
	// 获取运算符的优先级
	switch (op)
	{
	case "+":
	case "-":
		return 1;
	case "*":
	case "/":
		return 2;
	default:
		return 0;
	}
}

bool isNumeric(string str)
{
	// 判断字符串是否为数字
	foreach (c; str)
	{
		if (!c.isDigit && c != '.')
		{
			return false;
		}
	}
	return true;
}
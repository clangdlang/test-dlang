module main;

import std.file;
import std.json;
import std.stdio;

void main()
{
	// 读取文件内容
	string content = cast(string) read("example.txt");

	// 解析 JSON
	JSONValue json = parseJSON(content);

	// 打印 JSON 内容
	writeln(json.toString());
}

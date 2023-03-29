module basic.filewrite;

import std.stdio;

int main(string[] args) {
	File f = File("test.txt", "w");
	f.writeln("hello world");

	return 0;
}
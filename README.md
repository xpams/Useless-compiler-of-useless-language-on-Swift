# Useless-compiler-of-useless-language-on-Swift
Useless compiler of useless language on Swift


Examples:

i =	3;
Out:
i = 3
 
{ a=3; b=5; }
Out:
a = 3
b = 5

{ a = 1; b = 2; c = a + b; }
Out:
a = 1
b = 2
c = 3

{ a = 5; b = 2; c = a - b; }
Out:
a = 5
b = 2
c = 3

{ a = 5; b = 2; c = b < a; }
Out:
a = 5
b = 2
c = 1

{ a = 5; if (a < 10) a = 33; }
Out:
a = 33

{ a = 5; if (10 < a) a = 33; else { a = 1; b = 2; } }
Out:
a = 1
b = 2

{ a = 10; do { a = a - 2;}  while (3 < a); }
Out:
a = 2

{ a = 1; b = 5; while (a < b) { a = a + 3; }}
Out:
a = 7
b = 5

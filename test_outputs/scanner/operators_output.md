# Lexical Analysis Output

## Recognized Tokens and Errors

```
[line 1] TYPE         : int
[line 1] IDENT        : main
[line 1] PUNCT        : (
[line 1] PUNCT        : {
[line 2] TYPE         : int
[line 2] IDENT        : a
[line 2] OP           : =
[line 2] NUMBER       : 5
[line 2] PUNCT        : ,
[line 2] IDENT        : b
[line 2] OP           : =
[line 2] NUMBER       : 10
[line 2] PUNCT        : ;
[line 3] IDENT        : a
[line 3] OP           : +=
[line 3] IDENT        : b
[line 3] PUNCT        : ;
[line 4] KEYWORD      : if
[line 4] PUNCT        : (
[line 4] IDENT        : a
[line 4] OP           : >=
[line 4] IDENT        : b
[line 4] OP           : &&
[line 4] IDENT        : b
[line 4] OP           : !=
[line 4] NUMBER       : 0
[line 4] PUNCT        : )
[line 4] PUNCT        : {
[line 5] IDENT        : b
[line 5] OP           : --
[line 5] PUNCT        : ;
[line 6] PUNCT        : }
[line 6] KEYWORD      : else
[line 6] PUNCT        : {
[line 7] IDENT        : b
[line 7] OP           : <<
[line 7] OP           : =
[line 7] NUMBER       : 2
[line 7] PUNCT        : ;
[line 8] PUNCT        : }
[line 9] KEYWORD      : return
[line 9] IDENT        : b
[line 9] PUNCT        : ;
[line 10] PUNCT        : }
```

## Symbol Table

| Name            | Type         | Dimensions   | Frequency | Return Type  | Parameters Lists in Function call   |
|-----------------|--------------|--------------|-----------|--------------|-------------------------------------|
| a               | int          | -            | 3         | -            | -                                   |
| b               | int          | -            | 7         | -            | -                                   |
| main            | int          | -            | 1         | int          |                                     |

## Constant Table

| Variable Name   | Line Number | Value                | Type     |
|-----------------|-------------|----------------------|----------|
| -               | 2           | 5                    | int      |
| -               | 2           | 10                   | int      |
| -               | 4           | 0                    | int      |
| -               | 7           | 2                    | int      |

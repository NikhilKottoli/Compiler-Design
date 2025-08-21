# Lexical Analysis Output

## Recognized Tokens and Errors

```
[line 1] TYPE         : int
[line 1] IDENT        : sum
[line 1] PUNCT        : (
[line 1] PUNCT        : {
[line 2] KEYWORD      : return
[line 2] IDENT        : x
[line 2] OP           : +
[line 2] IDENT        : y
[line 2] PUNCT        : ;
[line 3] PUNCT        : }
[line 5] TYPE         : void
[line 5] IDENT        : printMessage
[line 5] PUNCT        : (
[line 5] PUNCT        : {
[line 6] IDENT        : printf
[line 6] PUNCT        : (
[line 6] PUNCT        : ;
[line 7] PUNCT        : }
[line 9] TYPE         : int
[line 9] IDENT        : main
[line 9] PUNCT        : (
[line 9] PUNCT        : {
[line 10] TYPE         : int
[line 10] IDENT        : result
[line 10] OP           : =
[line 10] IDENT        : sum
[line 10] PUNCT        : (
[line 10] PUNCT        : ;
[line 11] IDENT        : printMessage
[line 11] PUNCT        : (
[line 11] PUNCT        : ;
[line 12] KEYWORD      : return
[line 12] IDENT        : result
[line 12] PUNCT        : ;
[line 13] PUNCT        : }
```

## Symbol Table

| Name            | Type         | Dimensions   | Frequency | Return Type  | Parameters Lists in Function call   |
|-----------------|--------------|--------------|-----------|--------------|-------------------------------------|
| sum             | int          | -            | 2         | int          | int x, int y ; 3, 4                 |
| result          | int          | -            | 2         | -            | -                                   |
| x               | -            | -            | 1         | -            | -                                   |
| y               | -            | -            | 1         | -            | -                                   |
| printf          | -            | -            | 1         | -            | "%s", msg                           |
| printMessage    | void         | -            | 2         | void         | char *msg ; "Hello World"           |
| main            | int          | -            | 1         | int          |                                     |

## Constant Table

| Variable Name   | Line Number | Value                | Type     |
|-----------------|-------------|----------------------|----------|

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
[line 2] NUMBER       : 10
[line 2] PUNCT        : ;
[line 3] TYPE         : float
[line 3] IDENT        : b
[line 3] OP           : =
[line 3] NUMBER       : 2.5
[line 3] PUNCT        : ;
[line 4] TYPE         : char
[line 4] IDENT        : c
[line 4] OP           : =
[line 4] CHAR         : 'x'
[line 4] PUNCT        : ;
[line 5] KEYWORD      : return
[line 5] IDENT        : a
[line 5] OP           : +
[line 5] IDENT        : b
[line 5] PUNCT        : ;
[line 6] PUNCT        : }
```

## Symbol Table

| Name            | Type         | Dimensions   | Frequency | Return Type  | Parameters Lists in Function call   |
|-----------------|--------------|--------------|-----------|--------------|-------------------------------------|
| a               | int          | -            | 2         | -            | -                                   |
| b               | float        | -            | 2         | -            | -                                   |
| c               | char         | -            | 1         | -            | -                                   |
| main            | int          | -            | 1         | int          |                                     |

## Constant Table

| Variable Name   | Line Number | Value                | Type     |
|-----------------|-------------|----------------------|----------|
| -               | 2           | 10                   | int      |
| -               | 3           | 2.5                  | float    |
| -               | 4           | 'x'                  | char     |

# Lexical Analysis Output

## Recognized Tokens and Errors

```
[line 1] PREPROC      : #include <stdio.h>
[line 2] PREPROC      : #define SIZE 100
[line 3] PREPROC      : #define PI 3.14159
[line 5] TYPE         : int
[line 5] IDENT        : main
[line 5] PUNCT        : (
[line 5] PUNCT        : {
[line 6] TYPE         : int
[line 6] IDENT        : arr
[line 6] PUNCT        : [
[line 6] IDENT        : SIZE
[line 6] PUNCT        : ]
[line 6] PUNCT        : ;
[line 7] TYPE         : float
[line 7] IDENT        : area
[line 7] OP           : =
[line 7] IDENT        : PI
[line 7] OP           : *
[line 7] IDENT        : arr
[line 7] PUNCT        : [0]
[line 7] OP           : *
[line 7] IDENT        : arr
[line 7] PUNCT        : [0]
[line 7] PUNCT        : ;
[line 8] KEYWORD      : return
[line 8] NUMBER       : 0
[line 8] PUNCT        : ;
[line 9] PUNCT        : }
```

## Symbol Table

| Name            | Type         | Dimensions   | Frequency | Return Type  | Parameters Lists in Function call   |
|-----------------|--------------|--------------|-----------|--------------|-------------------------------------|
| area            | float        | -            | 1         | -            | -                                   |
| SIZE            | int          | -            | 1         | -            | -                                   |
| arr             | int          | [0][0]       | 3         | -            | -                                   |
| main            | int          | -            | 1         | int          |                                     |
| PI              | float        | -            | 1         | -            | -                                   |

## Constant Table

| Variable Name   | Line Number | Value                | Type     |
|-----------------|-------------|----------------------|----------|
| SIZE            | 2           | 100                  | macro    |
| PI              | 3           | 3.14159              | macro    |
| -               | 8           | 0                    | int      |

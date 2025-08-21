# Lexical Analysis Output

## Recognized Tokens and Errors

```
[line 1] TYPE         : int
[line 1] IDENT        : nums
[line 1] PUNCT        : [5]
[line 1] OP           : =
[line 1] PUNCT        : {
[line 1] NUMBER       : 1
[line 1] PUNCT        : ,
[line 1] NUMBER       : 2
[line 1] PUNCT        : ,
[line 1] NUMBER       : 3
[line 1] PUNCT        : ,
[line 1] NUMBER       : 4
[line 1] PUNCT        : ,
[line 1] NUMBER       : 5
[line 1] PUNCT        : }
[line 1] PUNCT        : ;
[line 2] TYPE         : char
[line 2] OP           : *
[line 2] IDENT        : name
[line 2] OP           : =
[line 2] STRING       : "Lexical"
[line 2] PUNCT        : ;
```

## Symbol Table

| Name | Type | Dimensions | Frequency | Return Type | Parameters Lists in Function call |
|------|------|------------|-----------|-------------|-----------------------------------|
| nums | int | [5] | 1 | - | - |
| name | char | - | 1 | - | - |

## Constant Table

| Variable Name | Line Number | Value | Type |
|---------------|-------------|-------|------|
| - | 1 | 1 | int |
| - | 1 | 2 | int |
| - | 1 | 3 | int |
| - | 1 | 4 | int |
| - | 1 | 5 | int |
| - | 2 | "Lexical" | string |

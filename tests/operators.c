int main() {
    int a = 5, b = 10;
    a += b;
    if (a >= b && b != 0) {
        b--;
    } else {
        b <<= 2;
    }
    return b;
}

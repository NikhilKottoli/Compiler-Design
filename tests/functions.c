int sum(int x, int y) {
    return x + y;
}

void printMessage(char *msg) {
    printf("%s", msg);
}

int main() {
    int result = sum(3, 4);
    printMessage("Hello World");
    return result;
}

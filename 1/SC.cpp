#include <iostream.h>
#include <stdlib.h>
#include <conio.h>

signed char aaaS, bbbS, cccS; // Изменено на signed char
int result; // Результат int, так как промежуточные вычисления могут выйти за пределы signed char

extern "C" { void Lab1S(void); }

void F_ASM() {
    Lab1S();
    cout << "ASM result: " << result << endl;
}

void F_CPP() {
    cout << "CPP result: ";
    if (aaaS == 0 || bbbS == -30) {
        cout << "Error (division by zero)" << endl;
        return;
    }
    result = (bbbS * cccS - 8 / aaaS) / (bbbS + 30);
    cout << result << endl;
}

int main() {
    char buffer[10];
    int temp; // Временная переменная для чтения из буфера

    cout << "Enter a: ";
    cin.getline(buffer, 10);
    temp = atoi(buffer);
    aaaS = (signed char)temp; // Преобразование в signed char

    cout << "Enter b: ";
    cin.getline(buffer, 10);
    temp = atoi(buffer);
    bbbS = (signed char)temp; // Преобразование в signed char

    cout << "Enter c: ";
    cin.getline(buffer, 10);
    temp = atoi(buffer);
    cccS = (signed char)temp; // Преобразование в signed char

    F_CPP();
    F_ASM();
    return 0;
}

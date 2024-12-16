#include <iostream.h>

unsigned char aaaS, bbbS, cccS; // Переменные для передачи в ASM
unsigned int result;                 // Переменная для результата

extern "C" { void Lab1S(void); }

// (bbbS * cccS - 8 / aaaS) / (bbbS + 30)
void F_ASM() {
    Lab1S();
    cout << "ASM result: " << result << endl;
}

void F_CPP() {
    cout << "CPP result: ";
    if (aaaS == 0 || bbbS + 30 == 0) { // Проверка на деление на 0
        cout << "Error (division by zero)" << endl;
        return;
    }
    result = (bbbS * cccS - 8 / aaaS) / (bbbS + 30);
    cout << result << endl;
}

int main() {
    cout << "Enter a: ";
    cin >> aaaS;
    cout << "Enter b: ";
    cin >> bbbS;
    cout << "Enter c: ";
    cin >> cccS;

    F_CPP();  // Вычисление на C++
    F_ASM();  // Вычисление на ASM
    return 0;
}

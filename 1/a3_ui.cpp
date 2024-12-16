#include <iostream.h>

// unsigned int (16-bit в Borland C++)
unsigned int aaaS, bbbS, cccS;
unsigned int result;

extern "C" { void Lab1S(void); }

void F_ASM() {
    Lab1S();
    cout << "ASM result: " << result << endl;
}

void F_CPP() {
    cout << "CPP result: ";
    if (aaaS == 0 || bbbS + 30 == 0) {
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

    F_CPP();
    F_ASM();
    return 0;
}

#include <iostream.h>

unsigned int a, b, result;

extern "C" { void calculate_x(); }

int main() {
    cout << "Enter a: ";
    cin >> a;
    cout << "Enter b: ";
    cin >> b;

    if (b == 0) { // Исправлено: убрано лишнее a > b
        cout << "Division by zero error!" << endl;
        return 1;
    }

    calculate_x();

    cout << "Result X: " << result << endl;

    return 0;
}

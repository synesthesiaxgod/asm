#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <locale.h>

int main() {
    setlocale(LC_ALL, "rus");

    // Переменные для ввода и результата
    float a, b, result;

    // Ввод значений
    printf("Введите a: ");
    scanf("%f", &a);
    printf("Введите b (не 0): ");
    scanf("%f", &b);

    // Проверка на деление на ноль
    if (b == 0) {
        printf("Ошибка: деление на ноль!\n");
        return 1;
    }

    // Условное вычисление
    if (a < b) {
        result = (a + 12) / 5;   // (a + 12) делится на 5
    }
    else if (a > b) {
        result = (a / b) - 21;  // a делится на b, потом вычитается 21
    }
    else {
        result = 210;           // Если a == b
    }

    // Вывод результата
    printf("Результат: %.2f\n", result);  // Вывод с 2 знаками после запятой

    return 0;
}

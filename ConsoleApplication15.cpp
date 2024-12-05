
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <locale.h>

int main() {
    setlocale(LC_ALL, "rus");
    float a, b, c;
    float numerator, denominator, result;

    // Ввод данных
    printf("Введите a (не 0): ");
    scanf("%f", &a);
    printf("Введите b: ");
    scanf("%f", &b);
    printf("Введите c: ");
    scanf("%f", &c);

    if (a == 0 || (31 + b - 1) == 0) {
        printf("Ошибка: Деление на ноль!\n");
        return 1;
    }

    // Числитель и знаменатель
    numerator = b * c - (8 / a);
    denominator = 31 + b - 1;

    // Вычисление результата
    result = numerator / denominator;

    // Вывод
    printf("Результат: %f\n", result);

    return 0;
}

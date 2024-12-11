#include <iostream>
#include <limits>
#include <cstdint>

// Объявляем ассемблерную функцию с соглашением cdecl
extern "C" int Make_Any(int b, int c, int a);

int main()
{
    // Используем int32_t для соответствия 32-битной архитектуре
    int32_t b, c, a;

    // Вывод диапазона значений для int32_t
    std::cout << "Введите значения переменных (int32_t):\n";
    std::cout << "Диапазон для int32_t: " << std::numeric_limits<int32_t>::min()
        << " до " << std::numeric_limits<int32_t>::max() << "\n";

    std::cout << "Введите b: ";
    std::cin >> b;
    std::cout << "Введите c: ";
    std::cin >> c;
    std::cout << "Введите a: ";
    std::cin >> a;

    // Проверка деления на ноль для a
    if (a == 0) {
        std::cout << "Ошибка: деление на ноль (a) невозможно!" << std::endl;
        return 1;
    }

    // Проверка деления на ноль для (30 + b)
    if ((30 + b) == 0) {
        std::cout << "Ошибка: деление на ноль (30 + b) невозможно!" << std::endl;
        return 1;
    }

    int32_t result = Make_Any(b, c, a);

    std::cout << "Результат: " << result << std::endl;

    return 0;
}

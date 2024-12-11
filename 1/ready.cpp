#include <iostream>
#include <limits>
#include <cstdint>

// Объявляем функцию с соглашением cdecl
extern "C" int Make_Any(uint16_t b, uint16_t c, uint16_t a);

int main()
{
    // Используем uint16_t для 16-битных беззнаковых целых чисел
    uint16_t b, c, a;

    // Вывод диапазона значений для uint16_t
    std::cout << "Введите значения для uint16_t (беззнаковое 16-битное число):\n";
    std::cout << "Диапазон для uint16_t: " << std::numeric_limits<uint16_t>::min()
        << " до " << std::numeric_limits<uint16_t>::max() << "\n";

    std::cout << "Введите b: ";
    std::cin >> b;
    std::cout << "Введите c: ";
    std::cin >> c;
    std::cout << "Введите a: ";
    std::cin >> a;

    // Проверка деления на 0
    if (a == 0) {
        std::cout << "Ошибка: деление на ноль (a) невозможно!" << std::endl;
        return 1;
    }

    if ((30 + b) == 0) {
        std::cout << "Ошибка: деление на ноль (30 + b) невозможно!" << std::endl;
        return 1;
    }

    uint16_t result = Make_Any(b, c, a);

    std::cout << "Результат: " << result << std::endl;

    return 0;
}

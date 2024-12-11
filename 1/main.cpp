#include <iostream>

extern "C" int Make_Any(int b, int c, int a);

int main()
{
    int b, c, a;

   
    std::cout << "¬ведите b: ";
    std::cin >> b;
    std::cout << "¬ведите c: ";
    std::cin >> c;
    std::cout << "¬ведите a: ";
    std::cin >> a;

    if (a == 0) {
        std::cout << "ќшибка: деление на ноль невозможно!" << std::endl;
        return 1;
    }

    int result = Make_Any(b, c, a);

    std::cout << "–езультат: " << result << std::endl;

    return 0;
}

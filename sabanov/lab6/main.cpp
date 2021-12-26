#include <iostream>
#include <random>

extern "C" void count(int* nums, int numsCount, int* borders, int intervalCount, int* result);

int main() {

    int randNumCount;
    std::cout << "Введите количество целых чисел: ";
    std::cin >> randNumCount;
    while (randNumCount <= 0) {
        std::cout << "Некорректное количество чисел, попробуйте еще раз.\nВведите количество интервалов: ";
        std::cin >> randNumCount;
    }

    int min_x, max_x;
    std::cout << "Введите границы: ";
    std::cin >> min_x >> max_x;
    while (max_x <= min_x) {
        std::cout << "Некорректные границы распределения, попробуйте еще раз.\nВведите количество интервалов: ";
        std::cin >> min_x >> max_x;
    }

    int intervalCount;
    std::cout << "Введите количество интервалов: ";
    std::cin >> intervalCount;
    while (intervalCount <= 0 || max_x - min_x <= intervalCount) {
        std::cout << "Некорректное количество интервалов, попробуйте еще раз.\nВведите количество интервалов: ";
        std::cin >> intervalCount;
    }

    std::cout << "Введите границы в порядке возрастания (левые границы, и в конце правая граница последнего интервала): ";
    int* borders = new int[intervalCount + 1];
    int* result = new int[intervalCount] { 0 };
    for (int i = 0; i < intervalCount + 1; i++)
        std::cin >> borders[i];

    std::random_device rd{};
    std::mt19937 gen(rd());

    float expectation = float(max_x + min_x) / 2; // мат ожидание
    float stddev = float(max_x - min_x) / 6; // мат отклонение
    std::normal_distribution<float> dist(expectation, stddev);

    int* nums = new int[randNumCount];
    for (int i = 0; i < randNumCount; i++)
        nums[i] = (int) round(dist(gen));

    count(nums, randNumCount, borders, intervalCount, result);

    std::cout << '\n';
    for (int i = 0; i < intervalCount; ++i) {
        std::cout << "Интервал номер " << i+1 << " (" << borders[i] << ", " << borders[i+1] << "):\n";
        std::cout << result[i] << " чисел.\n";
    }
}

#include <iostream>
#include <fstream>
#include <random>
#include <ctime>
#include <algorithm>

int cmp(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

extern "C" void FUNC(int NumRanDat, int* Xi, int NInt, int* LGrInt, int* result);

int main() {
    setlocale(LC_ALL, "");
    int NumRanDat;
    std::cout << "Введите количество генерируемых псевдослучайных целых чисел (от 0 по 16000): ";
    std::cin >> NumRanDat;
    if (NumRanDat <= 0 || NumRanDat > 16000) {
        std::cout << "Количество чисел должно быть от 0 по 16000";
        return -1;
    };
    int Xmin, Xmax;
    std::cout << "Введите минимальное значение (левую границу): ";
    std::cin >> Xmin;
    std::cout << "Введите максимальное значение (правую границу): ";
    std::cin >> Xmax;
    if (Xmax < Xmin) {
        std::cout << "Неверно введены максимальное и минимальное значения";
        return -1;
    }
    int NInt;
    std::cout << "Количество интервалов должно быть не меньше диапазона изменения входных чисел" << std::endl;
    std::cout << "Введите количество интервалов, на которые разбивается диапазон изменения массива псевдослучайных целых чисел (от 1 по 24): ";
    std::cin >> NInt;
    if (NInt <= 0 || NInt > 24 || NInt < Xmax - Xmin) {
        std::cout << "Неверно введено количество интервалов";
        return -1;
    }
    int* LGrInt = new int[NInt];
    std::cout << "Предупреждение:" << std::endl;
    std::cout << "Самая маленькая левая границы интервалов разбиения должна быть строго больше минимальное значения" << std::endl;
    std::cout << "Введите левые границы интервалов разбиения: ";
    for (int i = 0; i < NInt; ++i)
        std::cin >> LGrInt[i];

    std::qsort(LGrInt, NInt-1, sizeof(int), cmp);
    //    std::sort(LGrInt, LGrInt+NInt);

    if (LGrInt[0] <= Xmin) {
        std::cout << "Неверно введены левые границы интервалов разбиения";
        return -1;
    }

    std::mt19937 gen(time(nullptr));
    std::uniform_int_distribution<int> dis(Xmin, Xmax);
    int* Xi = new int[NumRanDat];
    for (int i = 0; i < NumRanDat; ++i) Xi[i] = dis(gen);

    int* result = new int[NInt];
    for (int i = 0; i < NInt; ++i) result[i] = 0;

    FUNC(NumRanDat, Xi, NInt, LGrInt, result);

    std::ofstream file("out.txt");
    file << "Сгенерированные числа: ";
    std::cout << "Сгенерированные числа: ";
    for (int i = 0; i < NumRanDat; ++i) {
        file << Xi[i] << ' ';
        std::cout << Xi[i] << ' ';
    }
    std::cout << "\nНомер интервала\tЛевая граница интервала\tКоличество чисел в интервале" << std::endl;
    file << "\nНомер интервала\tЛевая граница интервала\tКоличество чисел в интервале" << std::endl;
    for (int i = 0; i < NInt; ++i) {
        std::cout << "\t\t" << i + 1 << "\t\t\t\t\t" << LGrInt[i] << "\t\t\t\t\t\t" << result[i] << std::endl;
        file << "\t" << i + 1 << "\t\t  " << LGrInt[i] << "\t\t\t\t" << result[i] << std::endl;
    }

    file.close();
    delete[] LGrInt;
    delete[] Xi;
    delete[] result;
    system("pause");
    return 0;
}


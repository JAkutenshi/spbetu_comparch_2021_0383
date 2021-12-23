#include<iostream>
#include<fstream>
#include<random>

const int MAX_N = 16000;
const int MAX_NINT = 24;

extern "C" void first(int* num, int NumRunDat, int* res, int Xmin);
extern "C" void second(int* first_res, int NumRunDat, int Xmin, int* borders, int Nint, int* res);



int main() {
	setlocale(LC_ALL, "rus");

	std::ofstream fout;
	fout.open("output.txt", std::ios_base::out);

	int NumRanDat;
	std::cout << "Введите размер массива: ";
	std::cin >> NumRanDat;
	if (NumRanDat > MAX_N) {
		std::cout << "Размер превышает максимальный допустимый размер " << MAX_N << "\n";
		return 0;
	}

	int Xmin, Xmax;
	std::cout << "Введите диапазон [Xmin, Xmax]: ";
	std::cin >> Xmin >> Xmax;
	int Dx = Xmax - Xmin;

	int Nint;
	std::cout << "Введите количество интервалов: ";
	std::cin >> Nint;
	if ((Nint >= Dx) || (Nint > MAX_NINT) || (Nint < 0)) {
		int min;
		if (MAX_N < Dx) {
			min = MAX_N;
		}
		else {
			min = Dx;
		}
		std::cout << "Количество интервалов должно быть меньше " << min << " и больше 0\n";
		return 0;
	}

	int* left_borders = new int[Nint];
	int* saved_borders = new int[Nint];
	std::cout << "Введите левые границы: ";
	for (int i = 0; i < Nint; i++) {
		std::cin >> left_borders[i];
	}

	for (int i = 0; i < Nint - 1; i++) {
		for (int j = i + 1; j < Nint; j++) {
			if (left_borders[j] < left_borders[i])
				std::swap(left_borders[j], left_borders[i]);
		}
	}

	for (int i = 0; i < Nint; i++) {
		saved_borders[i] = left_borders[i];
		if (left_borders[i] < Xmin) {
			left_borders[i] = Xmin;
		}
	}

	std::mt19937 gen(time(nullptr));
	std::uniform_int_distribution<int> dis(Xmin, Xmax-1);
	int* num = new int[NumRanDat];
	for (int i = 0; i < NumRanDat; i++)
		num[i] = dis(gen);

	std::cout << "Сгенерированные числа: ";
	fout << "Сгенерированные числа: ";
	for (int i = 0; i < NumRanDat; i++) {
		std::cout << num[i] << " ";
		fout << num[i] << " ";
	}
	std::cout << "\n";
	fout << "\n";

	int len1 = abs(Xmax - Xmin);
	int* first_res = new int[len1];
	for (int i = 0; i < len1; i++)
		first_res[i] = 0;

	int len2 = Nint + 1;
	int* final_res = new int[len2];
	for (int i = 0; i < Nint + 1; i++)
		final_res[i] = 0;

	first(num, NumRanDat, first_res, Xmin);

	std::cout << "Промежуточные результаты: ";
	NumRanDat = 0;
	for (int i = 0; i < len1; i++) {
		std::cout << first_res[i] << " ";
		NumRanDat += first_res[i];
	}
	std::cout << "\n";

	second(first_res, NumRanDat, Xmin, left_borders, Nint, final_res);
	
	std::cout << "№\tГраница\tКоличество\n";
	fout << "№\tГраница\tКоличество\n";
	for (int i = 1; i < Nint + 1; i++) {
		std::cout << i << "\t" << saved_borders[i - 1] << "\t" << final_res[i] << "\n";
		fout << i << "\t" << saved_borders[i - 1] << "\t" << final_res[i] << "\n";
	}

	delete[] first_res;
	delete[] final_res;
	delete[] left_borders;
	delete[] num;
	fout.close();
}

#include <iostream>
#include <fstream>
#include <random>

using namespace std;

extern "C" void one(int* numbers, int n_size, int* result, int xmin);
extern "C" void two(int* array, int array_size, int xmin, int* intervals, int inter_size, int* result);


int main() {
	setlocale(0, "Russian");
	srand(time(NULL));
	ofstream result("result.txt");

	int n_size;
	int* numbers;
	int xmin, xmax;
	int inter_size;
	int* intervals;
	int* intervals2;
	int* result1;
	int* result2;

	cout << "Введите количество чисел:\n";
	cin >> n_size;
	if (n_size > 16 * 1024) {
		cout << "Количество чисел должно быть меньше или равно, чем 16*1024\n";
		return 0;
	}
	cout << "Введите xmin и xmax:\n";
	cin >> xmin >> xmax;
	int Dx = xmax - xmin;
	if (Dx > 24) {
		cout << "Xmax и Xmin не дожны отличаться больше чем на 24\n";
		return 0;
	}

	cout << "Введите число границ:\n";
	cin >> inter_size;

	if (inter_size > 24) {
		cout << "Число интервалов должно быть меньше или равно 24\n";
		return 0;
	}
	if (inter_size >= Dx) {
		cout << "Число интервалов должно быть меньше dx\n";
		return 0;
	}
	numbers = new int[n_size];
	intervals = new int[inter_size];
	intervals2 = new int[inter_size];

	int lenmod1 = abs(xmax - xmin) + 1;
	result1 = new int[lenmod1];
	for (int i = 0; i < lenmod1; i++)
		result1[i] = 0;


	result2 = new int[inter_size + 1];
	for (int i = 0; i < inter_size + 1; i++)
		result2[i] = 0;


	cout << "Введите все границы:\n";
	for (int i = 0; i < inter_size; i++) {
		cin >> intervals[i];
		if (intervals[i] < xmin) {
			cout << "Левая граница должна быть больше либо равна Xmin\n";
			return 0;
		}
		intervals2[i] = intervals[i];
		
	}



	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_int_distribution<> dis(xmin, xmax);
	for (int i = 0; i < n_size; i++) numbers[i] = dis(gen);


	cout << "Сгенерированные значения\n";
	result << "Сгенерированные значения\n";
	for (int i = 0; i < n_size; i++) {
		cout << numbers[i] << ' ';
		result << numbers[i] << ' ';
	}
	cout << '\n';
	cout << '\n';
	result << '\n';
	result << '\n';


	one(numbers, n_size, result1, xmin);

	two(result1, n_size, xmin, intervals, inter_size, result2);



	cout << "Результат:\n";
	result << "Результат:\n";
	cout << "№\tГраница\tКоличество чисел" << endl;
	result << "№\tГраница\tКоличество чисел" << endl;

	for (int i = 1; i < inter_size + 1; i++) {
		cout << i << "\t" << intervals2[i - 1] << '\t' << result2[i] << endl;
		result << i << "\t" << intervals2[i - 1] << '\t' << result2[i] << endl;
	}

	delete[] numbers;
	delete[] intervals;
	delete[] intervals2;
	delete[] result1;
	delete[] result2;

	return 0;
}
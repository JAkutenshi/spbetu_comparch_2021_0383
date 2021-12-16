#include <iostream>
#include <fstream>
#include <random>

extern "C" void module_1(int* x, int arr_size, int* result, int xmin);
extern "C" void module_2(int* x, int arr_size, int* left_border, int interval_cnt, int* result);

int main() {
	int arr_size = 0;
	int xmin = 0, xmax = 0;
	int interval_cnt = 0;

	std::ofstream output("output.txt");

	std::cout << "Input amount of the random numbers: ";
	std::cin >> arr_size;

	if (arr_size > 16 * 1000) {
		std::cout << "Error - max amount of numbers must be <= 16K" << std::endl;
		return 0;
	}


	int* x = new int[arr_size];

	std::cout << "Input Xmin and Xmax: ";
	std::cin >> xmin >> xmax;

	if (xmax <= xmin) {
		std::cout << "Error - bad range input, Xmax must be > Xmin" << std::endl;
		return 0;
	}

	std::cout << "Input number of intervals: ";
	std::cin >> interval_cnt;

	if (interval_cnt > 24 || interval_cnt < 0) {
		std::cout << "Error - number of intervals must be < 24 and not a negaitve" << std::endl;
		return 0;
	}

	if (interval_cnt < xmax - xmin) {
		std::cout << "Error - number of intervals must be >= Dx" << std::endl;
		return 0;
	}

	int* left_border = new int[interval_cnt];
	for (int i = 0; i < interval_cnt; i++)
		std::cin >> left_border[i];

	for (int i = 0; i < interval_cnt - 1; i++) {
		for (int j = i + 1; j < interval_cnt; j++) {
			if (left_border[j] < left_border[i]) {
				std::swap(left_border[j], left_border[i]);
			}
		}
	}

	if (left_border[0] > xmin) {
		std::cout << "Error - 1st left border must be < Xmin" << std::endl;
		return 0;
	}

	std::random_device rng;
	std::mt19937 gen(rng()); //to get certin range calculate mean and stddev
	float mean = float(xmax + xmin) / 2; //mean
	float stddev = float(xmax - xmin) / 6; //standart deviation
	std::normal_distribution<> d(mean, stddev);


	for (int i = 0; i < arr_size; i++) {
		x[i] = round(d(rng));
	}

	output << "Generated numbers: ";		//write generated nums for reference into output.txt
	std::cout << "Generated numbers: ";
	for (int i = 0; i < arr_size; i++) {
		output << x[i] << " ";
		std::cout << x[i] << " ";
	} output << std::endl; std::cout << std::endl;

	///////////////////////

	int* m1 = new int[xmax - xmin + 1];
	int* result = new int[interval_cnt];
	for (int i = 0; i < interval_cnt; i++) {
		result[i] = 0;
	}

	for (int i = 0; i < xmax - xmin + 1; i++) {
		m1[i] = 0;
	}

	///////////////////////
	module_1(x, arr_size, m1, xmin);
	//first & second modules
	module_2(x, arr_size, left_border, interval_cnt, result);
	///////////////////////

	std::cout << "\t\t\t1st module\nInterval num \tLeft border \tNums in the interval" << std::endl;
	output << "\t\t\t1st module\nInterval num \tLeft border \tNums in the interval" << std::endl;
	for (int i = 0; i < xmax - xmin + 1; i++) {
		std::cout << "\t" << (i + 1) << "\t" << i << "\t\t" << m1[i] << '\n';
		output << "\t" << (i + 1) << "\t" << i << "\t\t" << m1[i] << '\n';
	}

	std::cout << "\t\t\t2nd module\nInterval num \tLeft border \tNums in the interval" << std::endl;
	output << "\t\t\t2nd module\nInterval num \tLeft border \tNums in the interval" << std::endl;

	for (int i = 0; i < interval_cnt; i++) {
		std::cout << "\t" << i + 1 << "\t" << left_border[i] << "\t\t" << result[i] << '\n';
		output << "\t" << i + 1 << "\t" << left_border[i] << "\t\t" << result[i] << '\n';
	}

	delete[] result;
	delete[] left_border;
	delete[] x;

	return 0;
}

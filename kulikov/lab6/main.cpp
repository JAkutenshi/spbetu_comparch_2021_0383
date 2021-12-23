#include <iostream>
#include <fstream>
#include <random>

extern "C" void FUNC(int* array, int array_size, int* left_boarders, int intervals_size, int* result_array);

int main()
{
	std::ofstream file("out.txt");
	int NumRanDat;

	std::cout << "Enter the amount of numbers" << std::endl;
	std::cin >> NumRanDat;

	int Xmin, Xmax;
	std::cout << "Enter the minimum number" << std::endl;
	std::cin >> Xmin;
	std::cout << "Enter the maximum number" << std::endl;
	std::cin >> Xmax;

	if (Xmax < Xmin)
	{
		std::cout << "Error: wrong minimum or maximum number" << std::endl;
		return 0;
	}

	int interval_amount;
	std::cout << "Enter the amount of intervals" << std::endl;
	std::cin >> interval_amount;

	if (interval_amount <= 0)
	{
		std::cout << "Error: the amount of intervals should be positive" << std::endl;
		return 0;
	}

	int* left_borders = new int[interval_amount];
	std::cout << "Enter left borders" << std::endl;
	for (int i = 0; i < interval_amount; i++)
		std::cin >> left_borders[i];

	for (int i = 0; i < interval_amount - 1; i++)
	{
		for (int j = i + 1; j < interval_amount; j++)
		{
			if (left_borders[j] < left_borders[i])
				std::swap(left_borders[j], left_borders[i]);
		}
	}

	std::random_device rand;
	std::mt19937 gen(rand());
	std::uniform_int_distribution<> dis(Xmin, Xmax);
	int* arr = new int[NumRanDat];

	for (int i = 0; i < NumRanDat; i++)
		arr[i] = dis(gen);

	file << "Generated numbers: ";
	for (int i = 0; i < NumRanDat; i++)
		file << arr[i] << ' ';
	file << '\n';

	int* result_array = new int[interval_amount];
	for (int i = 0; i < interval_amount; i++)
		result_array[i] = 0;

	FUNC(arr, NumRanDat, left_borders, interval_amount, result_array);

	std::cout << "Interval index \tInterval left border \tAmount of numbers in interval" << '\n';
	file << "Interval index \tInterval left border \tAmount of numbers in interval" << '\n';

	for (int i = 0; i < interval_amount; i++)
	{
		std::cout << "\t" << i + 1 << "\t\t" << left_borders[i] << "\t\t\t" << result_array[i] << '\n';
		file << "\t" << i + 1 << "\t\t" << left_borders[i] << "\t\t\t" << result_array[i] << '\n';
	}

	delete[] left_borders;
	delete[] arr;
	delete[] result_array;
}
//
//  QuickSort.swift
//  ASD_2
//
//  Created by Valentyn on 02.10.2025.
//
//Задано матрицю дійсних чисел. Впорядкувати (переставити) рядки матриці за зростанням суми їх елементів.
func quickSortMatrixSteps(_ matrix: [[Double]]) -> [[[Double]]] {
    var matrix = matrix
    var steps: [[[Double]]] = [matrix]
    
    func quickSort(_ arr: inout [[Double]], low: Int, high: Int) {
        if low < high {
            let p = partition(&arr, low: low, high: high)
            steps.append(arr)
            quickSort(&arr, low: low, high: p - 1)
            quickSort(&arr, low: p + 1, high: high)
        }
    }
    
    func partition(_ arr: inout [[Double]], low: Int, high: Int) -> Int {
        let pivot = arr[high].reduce(0, +) //сума всіх елементів, аккумулятор 
        var i = low
        for j in low..<high {
            if arr[j].reduce(0, +) < pivot {
                arr.swapAt(i, j)
                steps.append(arr)
                i += 1
            }
        }
        arr.swapAt(i, high)
        steps.append(arr)
        return i
    }
    
    quickSort(&matrix, low: 0, high: matrix.count - 1)
    return steps
}

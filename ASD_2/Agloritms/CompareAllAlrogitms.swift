import Foundation

func ramdom_nums(size_of_array: Int) -> [Int]{
    var result : [Int] = []
    for _ in 0..<size_of_array {
        result.append(Int.random(in: 0..<100000000))
    }
    return result
}

// Counting Sort для цілих чисел з вимірюванням часу.
// Повертає відсортований масив у зростаючому порядку та тривалість виконання в секундах.
func countingSortInts(_ array: [Int]) -> (sorted: [Int], duration: TimeInterval) {
    guard !array.isEmpty else { return ([], 0) }
    
    // Вимірювання часу (через Date для сумісності; повертаємо Double у секундах)
    let start = Date()
    
    // Знаходимо мінімум і максимум для визначення діапазону
    guard let minValue = array.min(), let maxValue = array.max() else {
        return (array, 0)
    }
    let range = maxValue - minValue + 1
    var count = Array(repeating: 0, count: range)
    
    // Підрахунок входжень із зсувом на minValue (для підтримки від’ємних значень)
    for num in array {
        count[num - minValue] += 1
    }
    
    // Побудова відсортованого масиву (зростання)
    var sorted: [Int] = []
    sorted.reserveCapacity(array.count)
    for i in 0..<count.count {
        let value = i + minValue
        if count[i] > 0 {
            sorted.append(contentsOf: repeatElement(value, count: count[i]))
        }
    }
    
    let duration = Date().timeIntervalSince(start)
    return (sorted, duration)
}

// Merge Sort для цілих чисел з вимірюванням часу (зростаючий порядок).
// Повертає відсортований масив і тривалість виконання в секундах.
func mergeSortInts(_ array: [Int]) -> (sorted: [Int], duration: TimeInterval) {
    guard !array.isEmpty else { return ([], 0) }
    let start = Date()
    
    func merge(_ left: [Int], _ right: [Int]) -> [Int] {
        var merged: [Int] = []
        merged.reserveCapacity(left.count + right.count)
        var i = 0
        var j = 0
        while i < left.count && j < right.count {
            if left[i] <= right[j] { // зростаючий порядок
                merged.append(left[i])
                i += 1
            } else {
                merged.append(right[j])
                j += 1
            }
        }
        if i < left.count { merged.append(contentsOf: left[i...]) }
        if j < right.count { merged.append(contentsOf: right[j...]) }
        return merged
    }
    
    func sort(_ arr: [Int]) -> [Int] {
        guard arr.count > 1 else { return arr }
        let mid = arr.count / 2
        let left = sort(Array(arr[..<mid]))
        let right = sort(Array(arr[mid...]))
        return merge(left, right)
    }
    
    let sorted = sort(array)
    let duration = Date().timeIntervalSince(start)
    return (sorted, duration)
}

// Quick Sort для цілих чисел з вимірюванням часу (зростаючий порядок).
// Повертає відсортований масив і тривалість виконання в секундах.
func quickSortInts(_ array: [Int]) -> (sorted: [Int], duration: TimeInterval) {
    guard !array.isEmpty else { return ([], 0) }
    var arr = array
    let start = Date()
    
    func partition(_ a: inout [Int], low: Int, high: Int) -> Int {
        let pivot = a[high]
        var i = low
        for j in low..<high {
            if a[j] <= pivot { // зростаючий порядок
                a.swapAt(i, j)
                i += 1
            }
        }
        a.swapAt(i, high)
        return i
    }
    
    func quickSort(_ a: inout [Int], low: Int, high: Int) {
        if low < high {
            let p = partition(&a, low: low, high: high)
            quickSort(&a, low: low, high: p - 1)
            quickSort(&a, low: p + 1, high: high)
        }
    }
    
    quickSort(&arr, low: 0, high: arr.count - 1)
    let duration = Date().timeIntervalSince(start)
    return (arr, duration)
}

// Selection Sort для цілих чисел з вимірюванням часу (зростаючий порядок).
// Повертає відсортований масив і тривалість виконання в секундах.
func selectionSortInts(_ array: [Int]) -> (sorted: [Int], duration: TimeInterval) {
    guard !array.isEmpty else { return ([], 0) }
    var arr = array
    let start = Date()
    
    for i in 0..<arr.count {
        var minIndex = i
        for j in (i + 1)..<arr.count {
            if arr[j] < arr[minIndex] {
                minIndex = j
            }
        }
        if i != minIndex {
            arr.swapAt(i, minIndex)
        }
    }
    
    let duration = Date().timeIntervalSince(start)
    return (arr, duration)
}

// Shell Sort для цілих чисел з вимірюванням часу (зростаючий порядок).
// Повертає відсортований масив і тривалість виконання в секундах.
func shellSortInts(_ array: [Int]) -> (sorted: [Int], duration: TimeInterval) {
    guard !array.isEmpty else { return ([], 0) }
    var arr = array
    let start = Date()
    
    var gap = max(1, arr.count / 2)
    while gap > 0 {
        for i in gap..<arr.count {
            let temp = arr[i]
            var j = i
            while j >= gap && arr[j - gap] > temp {
                arr[j] = arr[j - gap]
                j -= gap
            }
            arr[j] = temp
        }
        gap /= 2
    }
    
    let duration = Date().timeIntervalSince(start)
    return (arr, duration)
}

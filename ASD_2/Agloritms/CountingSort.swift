import Foundation

// MARK: - Counting Sort для Double
func CountingSort_17(_ array: [Double]) -> (steps: [[Double]], countInfo: [(value: Double, count: Int)]) {
    guard !array.isEmpty else { return ([], []) }
    var steps: [[Double]] = [array]
    
    //Масштабуємо числа до цілих (множимо на 100 для 2 знаків після коми)
    let scale = 100.0
    let scaledArray = array.map { Int($0 * scale) }
    steps.append(array) // Початковий стан
    
    //Знаходимо min та max
    guard let minValue = scaledArray.min(),
          let maxValue = scaledArray.max() else { return (steps, []) }
    let range = maxValue - minValue + 1
    
    //Створюємо масив підрахунку
    var countArray = Array(repeating: 0, count: range)
    
    //Підраховуємо кількість кожного елемента
    for num in scaledArray {
        countArray[num - minValue] += 1
    }
    
    // Створюємо масив інформації про підрахунок у порядку індексів
    var countInfo: [(value: Double, count: Int)] = []
    for i in 0..<countArray.count {
        if countArray[i] > 0 {
            let scaledValue = i + minValue
            let originalValue = Double(scaledValue) / scale
            countInfo.append((value: originalValue, count: countArray[i]))
        }
    }
    
    // ШАГ 5: Будуємо відсортований масив
    var sortedArray: [Double] = []
    
    // Проходимо масив підрахунку
    for i in stride(from: countArray.count - 1, through: 0, by: -1) {
        let scaledValue = i + minValue
        let originalValue = Double(scaledValue) / scale
        
        // Додаємо елемент стільки разів, скільки він зустрічався
        for _ in 0..<countArray[i] {
            sortedArray.append(originalValue)
            
            // Зберігаємо кожен крок додавання елемента
            if sortedArray.count % max(1, array.count / 10) == 0 || sortedArray.count == array.count {
                steps.append(sortedArray)
            }
        }
    }
    
    // Додаємо фінальний результат, якщо його ще немає
    if steps.last != sortedArray {
        steps.append(sortedArray)
    }
    
    return (steps, countInfo)
}

// MARK: - Підготовка масиву з трансформацією
func prepareArray_17(_ array: [Int]) -> [Double] {
    return array.map { number -> Double in
        if number.isMultiple(of: 2) {
            // Парні: tan(x) - x
            let value = tan(Double(number)) - Double(number)
            return value
        } else {
            // Непарні: |x|
            return abs(Double(number))
        }
    }
}

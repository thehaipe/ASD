
import Foundation
func selectionSort(_ array: [Int]) -> [[Int]] {
    var arr = array
    var steps: [[Int]] = [arr]
    for i in 0..<arr.count {
        var minIndex = i
        for j in i+1..<arr.count {
            if arr[j] < arr[minIndex] {
                minIndex = j
            }
        }
        if i != minIndex {
            arr.swapAt(i, minIndex)
            print(arr)
        }
        steps.append(arr)
    }
    return steps
}
func prepareArray_13(_ array: [Int]) -> [Int]{
    return array.filter { $0 % 3 != 0 }.map { $0 * $0 }
}

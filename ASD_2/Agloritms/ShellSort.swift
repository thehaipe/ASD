//How it works
import Foundation
func shellSort(_ array: [String]) -> [[String]] {
    var arr = array
    var gap = arr.count / 2
    var steps: [[String]] = [arr]
    while gap > 0 {
        //Цикл, в якому інтвервал прямує до 0
        for i in gap..<arr.count {
            var j = i
            let temp = arr[i]
            //Зсуваємо елементи вправо (з кроком gap), поки знаходимо правильне місце для temp.
            while j >= gap && arr[j - gap] > temp {
                arr[j] = arr[j - gap]
                j -= gap
            }
            arr[j] = temp
        }
        gap /= 2
        steps.append(arr)
    }
    return steps
}
func prepareArray_14(_ array: [String]) -> [String]{
    return array.filter { $0.count < 8 }
}




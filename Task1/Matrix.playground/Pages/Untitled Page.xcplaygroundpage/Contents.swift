import Foundation

// Задание 1
// Условия задачи:
// На вход подается матрица А х В (1 <= А, В <= 10^3; 1 <= А * В <= 10^3). Значение каждой ячейки - целое число 0 или 1.
// Найти наименьшее расстояние от каждой ячейки до ближайшей ячейки со значением 1.
// Расстояние между соседними ячейками равно 1.
// Пример:
// Входная матрица:
// [[1,0,1],
// [0,1,0],
// [0,0,0]]
// Выходная матрица:
// [[0,1,0],
// [1,0,1],
// [2,1,2]]

func findDistanceMatrix(from matrix: [[Int]]) -> [[Int]] {
    guard validateMatrix(matrix) else { return [] }
    
    let rows = matrix.count
    let columns = matrix[0].count
    let searchDirections = [(0,1),(0,-1),(1,0),(-1,0)]
    var resultMatrix = matrix
    var checkPointArray = [(Int,Int)]()
    
    for row in 0..<rows {
        for column in 0..<columns {
            if matrix[row][column] == 1 {
                resultMatrix[row][column] = 0
                checkPointArray.append((row, column))
            } else {
                resultMatrix[row][column] = 10000
            }
        }
    }
    
    while !checkPointArray.isEmpty {
        let checkPoint = checkPointArray.removeFirst()
        let currentRow = checkPoint.0
        let currentColumn = checkPoint.1
        
        for direction in searchDirections {
            let newRow = currentRow + direction.0
            let newColumn = currentColumn + direction.1
            
            if newRow >= 0 && newRow < rows && newColumn >= 0 && newColumn < columns {
                if resultMatrix[newRow][newColumn] > resultMatrix[currentRow][currentColumn] {
                    resultMatrix[newRow][newColumn] = resultMatrix[currentRow][currentColumn] + 1
                    checkPointArray.append((newRow, newColumn))
                }
            }
        }
    }
    
    return resultMatrix
}

func validateMatrix(_ matrix: [[Int]]) -> Bool {
    guard !matrix.isEmpty else {
        print("Matrix is empty")
        return false
    }
    
    let rows = matrix.count
    let columns = matrix[0].count
    
    if rows >= 1, columns <= 1000, (rows * columns) <= 1000 {
        for row in matrix {
            if row.count == columns {
                for item in row {
                    if item == 0 || item == 1 {
                        continue
                    } else {
                        print("Matrix is not accepted. Elements must be 0 or 1")
                        return false
                    }
                }
            } else {
                print("Matrix is not accepted. The matrix must be A x B")
                return false
            }
        }
        return true
    }
    
    return false
}

func printDistanceMatrix(_ matrix: [[Int]]) {    
    for row in matrix {
        print(row.map { "\($0)" }.joined(separator: " "))
    }
}

// Example 1
//let matrix1: [[Int]] = []
//printDistanceMatrix(findDistanceMatrix(from: matrix1))

// Example 2
//let matrix2 = [[1,0,1],[0,1,0], [0,0,0], [1,1,0]]
//printDistanceMatrix(findDistanceMatrix(from: matrix2))

// Example 3
//let matrix3 = [[1,0,1,0,1],[0,1,0,1,0], [0,0,1,0,0], [1,0,1,0,1], [0,0,0,0,0], [0,0,0,0,0]]
//printDistanceMatrix(findDistanceMatrix(from: matrix3))

// Example 4
//let matrix4 = [[1,0,1,0],[0,1,0,1], [0,0,0,0], [1,1,0,0]]
//printDistanceMatrix(findDistanceMatrix(from: matrix4))

// Example 5
//let matrix5 = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,1,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,1,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[1,0,0,0]]
//printDistanceMatrix(findDistanceMatrix(from: matrix5))

// Example 6
//let matrix6 = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]]
//printDistanceMatrix(findDistanceMatrix(from: matrix6))

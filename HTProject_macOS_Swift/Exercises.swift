//
//  Exercises.swift
//  HTProject_macOS_Swift
//
//  Created by Hem1ngT4i on 2024/4/25.
//  Copyright © 2024 Hem1ngT4i. All rights reserved.
//

import Foundation

enum ExerciseType: String {
    case plus = "+"
    case minus = "–"
    case multiple = "×"
    case divide = "÷"
    case mix = ""
}

class DailyExercises {
    private var min: Int
    private var max: Int
    private var type: ExerciseType
    private var count: Int
    private var column: Int = 4
    
    init(min: Int = 10, max: Int = 100, type: ExerciseType = .mix, count: Int = 52) {
        self.min = min
        self.max = max
        self.type = type
        self.count = count
    }
    
    func generate() {
        let date = Date().description
        printSeparator(with: " Exercises" + " " + date[date.startIndex..<String.Index(utf16Offset: 10, in: date)] + " ")
        var formatter = ""
        let originType = type
        let mixTypes: [ExerciseType] = [.plus, .minus, .multiple, .divide]
        for i in 0..<count {
            var firstNumber = Int.random(in: min..<max)
            var secondNumber = Int.random(in: min..<max)
            formatter += (i % column == 0) ? "" : "        "
            if originType == .mix {
                type = mixTypes[Int.random(in: 0..<4)]
            }
            if originType == .divide {
                secondNumber = Int.random(in: 5..<50)
                firstNumber = Swift.min(10000, firstNumber * secondNumber)
            }
            formatter += getFormatterOfType(firstNumber: firstNumber, secondNumber: secondNumber)
            if (i + 1) % 4 == 0 {
                print(formatter)
                formatter = "\n"
            }
        }
        print(formatter)
        printSeparator(with: "******** End *********")
    }
    
    private func printSeparator(with text: String) {
        print("\n*********************************\(text)*********************************\n")
    }
    
    private func getFormatterOfType(firstNumber: Int, secondNumber: Int) -> String {
        switch type {
        case .plus:
            return generateExercisesOfPlus(firstNum: firstNumber, secondNum: secondNumber)
        case .minus:
            return generateExercisesOfMinus(firstNum: firstNumber, secondNum: secondNumber)
        case .multiple:
            return generateExercisesOfMultiple(firstNum: firstNumber, secondNum: secondNumber)
        case .divide:
            return generateExercisesOfDivide(firstNum: firstNumber, secondNum: secondNumber)
        default:
            return ""
        }
    }
    
    private func generateExercisesOfPlus(firstNum: Int, secondNum: Int) -> String {
        generateExpression(firstNum: firstNum, secondNum: secondNum)
    }
    
    private func generateExercisesOfMinus(firstNum: Int, secondNum: Int) -> String {
        let flag = firstNum > secondNum
        return generateExpression(firstNum: flag ? firstNum : secondNum, secondNum: flag ? secondNum : firstNum)
    }
    
    private func generateExercisesOfMultiple(firstNum: Int, secondNum: Int) -> String {
        generateExpression(firstNum: firstNum, secondNum: secondNum)
    }
    
    private func generateExercisesOfDivide(firstNum: Int, secondNum: Int) -> String {
        generateExpression(firstNum: firstNum, secondNum: secondNum)
    }
    
    private func generateExpression(firstNum: Int, secondNum: Int) -> String {
        let firstNumString = (firstNum < 10 ? " " : "") + firstNum.description
        let secondNumString = (secondNum < 10 ? " " : "") + secondNum.description
        return firstNumString + " \(type.rawValue) " + secondNumString +  " = "
    }
}

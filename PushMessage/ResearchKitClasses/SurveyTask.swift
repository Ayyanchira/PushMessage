//
//  SurveyTask.swift
//  HomeWork4
//
//  Created by Akshay Ayyanchira on 11/7/17.
//  Copyright © 2017 Akshay Ayyanchira. All rights reserved.
//

import Foundation
import ResearchKit

class SurveyTask: NSObject {
    
    var orderedTask:ORKNavigableOrderedTask?
    var steps = [ORKStep]()
    var surveyID = ""

    func getOrderedTasksWithRulesWith(surveyID:Int, questionList:[Questions]) -> ORKNavigableOrderedTask {
        
        //some initializing code here
        self.surveyID = "\(surveyID)"
        //Creating steps
        for step in questionList{
            switch step.type{
            case "Instruction":
                print("Show instruction Page")
                let instructionStepWeightManagement = ORKInstructionStep(identifier: "\(step.questionid)")
                instructionStepWeightManagement.title = step.question
//                instructionStepWeightManagement.text = step.message
                steps += [instructionStepWeightManagement]
                
            case "text":
                let answerFormatSelection = ORKTextAnswerFormat()
                let questionStep = ORKQuestionStep(identifier: "\(step.questionid)", title: step.question, answer: answerFormatSelection)
                steps += [questionStep]

                
            case "likert":
                let likert = Int(step.likertscale)
                let answerFormatScale = ORKScaleAnswerFormat(maximumValue: likert!, minimumValue: 1, defaultValue: 1, step: 1)
                let questionStep = ORKQuestionStep(identifier: "\(step.questionid)", title: nil, text: step.question, answer: answerFormatScale)
                steps += [questionStep]
                
                
            case "Boolean":
                    print("Boolean question")
                    let answerFormatYesOrNo = ORKBooleanAnswerFormat()
                    let questionStep = ORKQuestionStep(identifier: "\(step.questionid)", title: nil, answer: answerFormatYesOrNo)
                    steps += [questionStep]
                    
//                case "Scale":
//                    print("Scale question")
//                    let answerFormatScale = ORKScaleAnswerFormat(maximumValue: (step.answerOptions?.count)!, minimumValue: 1, defaultValue: 1, step: 1)
//                    let questionStep = ORKQuestionStep(identifier: "\(step.questionid)", title: step.title, text: step.message, answer: answerFormatScale)
//                    steps += [questionStep]
                
                case "Selection","multiple":
                    print("Selection question")
                    let answerOptions = ["Strongly Disagree","Disagree","Neutral","Agree","Strongly Agree"]
                    var textChoices:[ORKTextChoice] = []
                    for (index,answerOption) in (answerOptions.enumerated()){
                        let orkTextChoice = ORKTextChoice(text: answerOption, detailText: nil, value: index+1 as NSCoding & NSCopying & NSObjectProtocol, exclusive: false)
                        textChoices.append(orkTextChoice)
                    }
                    let answerFormatSelection = ORKTextScaleAnswerFormat(textChoices: textChoices, defaultIndex: 2)
                    let questionStep = ORKQuestionStep(identifier: "\(step.questionid)", title:step.question, answer: answerFormatSelection)
                    steps += [questionStep]
                    
                    
                case "Text":
                    let answerFormatSelection = ORKTextAnswerFormat()
                    let questionStep = ORKQuestionStep(identifier: "\(step.questionid)", title: step.question, answer: answerFormatSelection)
                    steps += [questionStep]
                    
                default:
                    print("Something went wrong")
                }
            
        }
        
        //Adding Completion Step
        let completionStep = ORKCompletionStep(identifier: "SummaryStep")
        completionStep.title = "Thank you for your time!"
        completionStep.text = "Your participation is very important to us."
        steps += [completionStep]
        
        //Finalizing steps
        orderedTask = ORKNavigableOrderedTask(identifier: self.surveyID, steps: steps)
        
//        // Applying rules
//        for (stepIndex,step) in questionList.enumerated(){
//            if step.rulesApplicable == true{
//                let questionID = step.id!
//                switch step.answerFormat!{
//                case "Boolean":
//                    var predicateArray:[NSPredicate] = []
//                    var destinationArray:[String] = []
//                    for (index,answerOption) in (step.answerOptions?.enumerated())!{
//                        let predicate = ORKResultPredicate.predicateForBooleanQuestionResult(with: ORKResultSelector(resultIdentifier: questionID), expectedAnswer: index == 0)
//                        predicateArray.append(predicate)
//                        let destinationStepIndex = Int(step.rules![index])
//                        let destinationStep = steps[destinationStepIndex!]
//                        let destinationID = destinationStep.identifier
//                        destinationArray.append(destinationID)
//                    }
//
//                    let defaultNextStep = steps[stepIndex + 1]
//                    let defaultNextStepID = defaultNextStep.identifier
//                    let rule = ORKPredicateStepNavigationRule(resultPredicates: predicateArray, destinationStepIdentifiers:destinationArray, defaultStepIdentifier: defaultNextStepID, validateArrays: true)
//                    orderedTask?.setNavigationRule(rule, forTriggerStepIdentifier: questionID)
//
////                case "Scale":
////
////                case "Selection":
////
////                case "Text":
//
//                default:
//                    print("Something went wrong")
//                }
//            }
//        }
        
        
        return orderedTask!
    }
}
//public var SurveyTask:NSObject{
//
//    var orderedTask:ORKNavigableOrderedTask
//
//    var steps = [ORKStep]()
//
//    //Text Input Question
//    let daysCountAnswer = ORKScaleAnswerFormat(maximumValue: 7, minimumValue: 0, defaultValue: 4, step: 1)
//    let alcoholQuestionStepTitle = "How many days you had alcohol this week?"
//    let alcoholQuestionStep = ORKQuestionStep(identifier: "AlcoholStep", title: alcoholQuestionStepTitle, answer: daysCountAnswer)
//    steps += [alcoholQuestionStep]
//
//
//
//
//
//    return ORKNavigableOrderedTask(identifier: "surveyOne", steps: steps)
//}


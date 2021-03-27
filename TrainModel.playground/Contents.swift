import CreateML
import Foundation

let fileURL = URL(fileURLWithPath:"/tmp/traindata.json")
let testURL = URL(fileURLWithPath: "/tmp/testdata.json")

if let data = try? MLDataTable(contentsOf: fileURL),
   let textClassifier = try? MLTextClassifier(trainingData: data,
                                   textColumn: "text",
                                   labelColumn: "label") {
    // create test data
    if let testData = try? MLDataTable(contentsOf: testURL) {
        let metrics = textClassifier.evaluation(on: testData,
                                                textColumn: "text",
                                                labelColumn: "label")
        print("metrics \(metrics)")
        
        let metadata = MLModelMetadata(author: "Gualtiero Frigerio",
                                       shortDescription: "A model trained to classify Apple topics", version: "1.0")
        let modelFileURL = URL(fileURLWithPath: "/tmp/AppleTopics.mlmodel")
        try textClassifier.write(to: modelFileURL, metadata: metadata)
    }
}









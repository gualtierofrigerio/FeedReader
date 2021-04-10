import turicreate as tc

training_data = tc.SFrame.read_json('training.json')
test_data = tc.SFrame.read_json('testdata.json')

model = tc.text_classifier.create(training_data, 'label', features=['text'], max_iterations=100)

predictions = model.predict(test_data)

metrics = model.evaluate(test_data)
print(metrics['accuracy'])

# Save the model for later use in Turi Create
model.save('MyTextMessageClassifier.model')

# Export for use in Core ML
model.export_coreml('AppleTopicsTC.mlmodel')

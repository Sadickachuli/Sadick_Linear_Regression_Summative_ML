# Student Performance Prediction API

## Description

This repository contains a model for predicting student performance based on a dataset. The model analyzes various factors influencing academic performance and predicts a performance index based on input features.

### About the Dataset

**Description:**
The Student Performance Dataset is designed to examine the factors influencing academic student performance. It consists of 10,000 student records, each containing information about various predictors and a performance index.

**Variables:**
- **Hours Studied:** The total number of hours spent studying by each student.
- **Previous Scores:** The scores obtained by students in previous tests.
- **Extracurricular Activities:** Whether the student participates in extracurricular activities (Yes or No).
- **Sleep Hours:** The average number of hours of sleep the student had per day.
- **Sample Question Papers Practiced:** The number of sample question papers the student practiced.

**Target Variable:**
- **Performance Index:** A measure of the overall performance of each student. The performance index represents the student's academic performance and is rounded to the nearest integer. It ranges from 10 to 100, with higher values indicating better performance.

## API Endpoint

The publicly available API endpoint for accessing the student performance prediction model is:

**API Endpoint URL:** `https://fast-api-1-5td2.onrender.com/predict`

# Demo Video


https://github.com/user-attachments/assets/fb9067d1-7b0f-4295-86c8-e70d3df73ee3



### Request

To get predictions from the model, make a POST request to the endpoint with the following JSON payload:

```json
{
  "hours_studied": value,
  "previous_scores": value,
  "extracurricular_activities": "Yes/No",
  "sleep_hours": value,
  "sample_question_papers_practiced": value
}

**Response** 
{
  "predicted_performance_index": value
}





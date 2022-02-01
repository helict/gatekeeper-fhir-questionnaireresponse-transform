def loinc: [{
  "valueCoding": {"system": "http://loinc.org", "code": .}
}];
def optional(bool; value): if bool then {"valueString": value} else empty end;
def inline_4x1(a1; a2; a3; a4; a5): [{
  "valueCoding": {
    "system": "string",
    "code": {
      (a1): "Not at all",
      (a2): "Little",
      (a3): "Moderate",
      (a4): "Quite a bit",
      (a5): "Strongly",
    }[.]
  }
}];
def inline_7x7(a1; a2; a3): [{
  "valueCoding": {
    "system": "string",
    "code": {(a1): "Worse", (a2): "The same", (a3): "Better"}[.]
  }
}];

{
  "resourceType": "QuestionnaireResponse",
  "questionnaire": "http://example.com/Questionnaire/COVID-SHORT",
  "status": "completed",
  "item": [
    {
      "linkId": "demography",
      "item": [
        {
          "linkId": "demography.birthDate",
          "answer": [{"valueDate": .COVID_Q01}]
        },
        {
          "linkId": "demography.gender",
          "answer": [{
            "valueCoding": {
              "system": "http://hl7.org/fhir/ValueSet/administrative-gender",
              "code": .COVID_Q02
            }
          }]
        },
        {
          "linkId": "demography.country",
          "answer": {
            "valueString": {
              COVID_Q03_A1: "Cyprus",
              COVID_Q03_A2: "Germany",
              COVID_Q03_A3: "Greece",
              COVID_Q03_A4: "Italy",
              COVID_Q03_A5: "Poland",
              COVID_Q03_A6: "Spain",
              COVID_Q03_A7: "United Kingdom",
              COVID_Q03_A8: "Hong Kong",
              COVID_Q03_A9: "Taiwan",
              COVID_Q03_A10: "Singapore",
              COVID_Q03_A11: .COVID_Q03_detail,
            }[.COVID_Q03]
          }
        },
        {
          "linkId": "demography.education",
          "answer": {
            "valueString": {
              COVID_Q04_A1: "No education",
              COVID_Q04_A2: "Primary school",
              COVID_Q04_A3: "Secondary school",
              COVID_Q04_A4: "High school",
              COVID_Q04_A5: "University degree",
              COVID_Q04_A6: "Master degree",
              COVID_Q04_A7: "PhD degree",
            }[.COVID_Q04]
          }
        }
      ]
    },
    {
      "linkId": "overallHealthStatus",
      "item": [{
        "linkId": "medicalHistory",
        "item": [{
          "linkId": "medicalHistory.problems",
          "answer": [
            optional(.COVID_Q07_A1; "Respiratory illness"),
            optional(.COVID_Q07_A2; "Diabetes Type 2"),
            optional(.COVID_Q07_A3; "Obesity"),
            optional(.COVID_Q07_A4; "Cardiovascular disease: heart failure, coronary artery disease or cardiomyopathies"),
            optional(.COVID_Q07_A5; "Cancer"),
            optional(.COVID_Q07_A6; "Chronic kidney disease"),
            optional(.COVID_Q07_A7; "Arthritis"),
            optional(.COVID_Q07_A8; "Immune disorder"),
            optional(.COVID_Q07_A9; "Emotional or mental health problems such as Depression or Anxiety"),
            optional(.COVID_Q07_A10; .COVID_Q07_detail)
          ]
        }]
      }]
    },
    {
      "linkId": "covid19HealthExposureStatus",
      "item": [{
        "linkId": "covid19HealthExposureStatus.infection",
        "answer": [{
          "valueString": {
            COVID_Q08_A1: "Yes, I had some symptoms and tested positive",
            COVID_Q08_A2: "Yes, I had some symptoms but tested negative",
            COVID_Q08_A3: "Yes, I had some symptoms but never took a test",
            COVID_Q08_A4: "No, I had no symptoms but tested positive",
            COVID_Q08_A5: "No, I never had symptoms neither tested positive",
          }[.COVID_Q08]
        }]
      }]
    },
    {
      "linkId": "covid19PsychologicalImpact",
      "item": [
        {
          "linkId": "covid19PsychologicalImpact.generalQuestions",
          "item": [
            {
              "linkId": "covid19PsychologicalImpact.generalQuestions.last2Weeks",
              "answer": .COVID_Q13 | inline_4x1("COVID_Q13_A1"; "COVID_Q13_A2"; "COVID_Q13_A3"; "COVID_Q13_A4"; "COVID_Q13_A5")
            },
            {
              "linkId": "covid19PsychologicalImpact.generalQuestions.highestPeak",
              "answer": .COVID_Q14 | inline_4x1("COVID_Q14_A1"; "COVID_Q14_A2"; "COVID_Q14_A3"; "COVID_Q14_A4"; "COVID_Q14_A5")
            }
          ]
        },
        {
          "linkId": "covid19PsychologicalImpact.PHQ4",
          "item": [{
            "linkId": "covid19PsychologicalImpact.PHQ4.psychosocialSupport",
            "answer": [{
              "valueString": {
                COVID_Q37_A1: "No",
                COVID_Q37_A2: "None available",
                COVID_Q37_A3: .COVID_Q37_detail,
              }[.COVID_Q37]
            }]
          }]
        }
      ]
    },
    {
      "linkId": "physicalActivity",
      "item": [{
        "linkId": "physicalActivity.overallLast2Weeks",
        "answer": [{
          "valueString": {
            COVID_Q48_A1: "Now I do less physical activity",
            COVID_Q48_A2: "Now I do more or less the same amount of physical activity",
            COVID_Q48_A3: "Now I do more physical activity",
          }[.COVID_Q48]
        }]
      }]
    },
    {
      "linkId": "sleepHealth",
      "item": [{
        "linkId": "sleepHealth.overallQualityVsBeforeCovid19",
        "answer": .COVID_Q55 | inline_7x7("COVID_Q55_A1"; "COVID_Q55_A2"; "COVID_Q55_A3")
      }]
    },
    {
      "linkId": "covid19EffectsOnChronicDiseases",
      "item": [{
        "linkId": "accessMedCare",
        "item": [{
          "linkId": "accessMedCares.bookAppointmentDuringCovid19",
          "answer": [{
            "valueString": {
              COVID_Q75_A1: "Much harder",
              COVID_Q75_A2: "Somewhat harder",
              COVID_Q75_A3: "No change",
              COVID_Q75_A4: "Somewhat easier",
              COVID_Q75_A5: "Much easier",
              COVID_Q75_A6: "Not applicable",
            }[.COVID_Q75]
          }]
        }]
      }]
    },
    {
      "linkId": "virtualConsultations",
      "item": [
        {
          "linkId": "virtualConsultations.beforeCovid19Virtual",
          "answer": .COVID_Q58 | loinc
        },
        {
          "linkId": "virtualConsultations.duringCovid19F2F",
          "answer": .COVID_Q59 | loinc
        },
        {
          "linkId": "virtualConsultations.duringCovid19Virtual",
          "answer": .COVID_Q60 | loinc
        },
        if .COVID_Q58 == "LA33-6" or .COVID_Q60 == "LA33-6" then {
          "linkId": "virtualConsultations.duringCovid19VirtualUsefulness",
          "answer": [{
            "valueString": {
              COVID_Q61_A1: "Very useful",
              COVID_Q61_A2: "Useful",
              COVID_Q61_A3: "Average",
              COVID_Q61_A4: "Not useful",
              COVID_Q61_A5: "Not useful at all",
            }[.COVID_Q61]
          }]
        } else empty end,
        {
          "linkId": "virtualConsultations.futureWill",
          "answer": [{
            "valueString": {
              COVID_Q62_A1: "No, I would not want any virtual consultations",
              COVID_Q62_A2: "Yes, but only as part of a mix of face-to-face and virtual consultations",
              COVID_Q62_A3: "Yes, as many of my consultations as possible",
            }[.COVID_Q62]
          }]
        }
      ]
    },
    {
      "linkId": "digitalHealthcare",
      "item": [
        {
          "linkId": "digitalHealthcare.healthTechnologiesUsedBeforeCovid19",
          "answer": [
            optional(.COVID_Q63_A1; "Virtual consultation"),
            optional(.COVID_Q63_A2; "Remote monitoring"),
            optional(.COVID_Q63_A3; "Smartphone/tablet apps (e.g., tracking personal activity or psychological well-being)"),
            optional(.COVID_Q63_A4; "Wearable technology (e.g., a wristband activity tracker)"),
            optional(.COVID_Q63_A5; "Smart scales"),
            optional(.COVID_Q63_A6; "Websites"),
            optional(.COVID_Q63_A7; "Social media"),
            optional(.COVID_Q63_A8; "Electronic health records"),
            optional(.COVID_Q63_A9; "Online support communities"),
            optional(.COVID_Q63_A10; .COVID_Q63_detail),
            optional(.COVID_Q63_A11; "None")
          ]
        },
        {
          "linkId": "digitalHealthcare.healthTechnologiesUsedDuringCovid19",
          "answer": [
            optional(.COVID_Q64_A1; "Virtual consultation"),
            optional(.COVID_Q64_A2; "Remote monitoring"),
            optional(.COVID_Q64_A3; "Smartphone/tablet apps (e.g., tracking personal activity or psychological well-being)"),
            optional(.COVID_Q64_A4; "Wearable technology (e.g., a wristband activity tracker)"),
            optional(.COVID_Q64_A5; "Smart scales"),
            optional(.COVID_Q64_A6; "Websites"),
            optional(.COVID_Q64_A7; "Social media"),
            optional(.COVID_Q64_A8; "Electronic health records"),
            optional(.COVID_Q64_A9; "Online support communities"),
            optional(.COVID_Q64_A10; .COVID_Q64_detail),
            optional(.COVID_Q64_A11; "None")
          ]
        },
        {
          "linkId": "digitalHealthcare.usageIntent",
          "answer": [
            optional(.COVID_Q65_A1; "Health and wellness advisories"),
            optional(.COVID_Q65_A2; "Remote monitoring of ongoing health issues through at-home devices"),
            optional(.COVID_Q65_A3; "Routine appointments"),
            optional(.COVID_Q65_A4; "Mental health appointments"),
            optional(.COVID_Q65_A5; "Appointments with medical specialists from chronic conditions"),
            optional(.COVID_Q65_A6; "Appointments with medical specialists for diagnosis or acute care"),
            optional(.COVID_Q65_A7; "Diagnoses for illnesses, diseases and disorders"),
            optional(.COVID_Q65_A8; "None of the above")
          ]
        },
        {
          "linkId": "digitalHealthcare.usageImpediments",
          "answer": [
            optional(.COVID_Q66_A1; "Concerns about my privacy or data security"),
            optional(.COVID_Q66_A2; "Don’t trust the effectiveness of the service"),
            optional(.COVID_Q66_A3; "Prefer my current providers"),
            optional(.COVID_Q66_A4; "Don’t take the initiative to try something new or change my habit"),
            optional(.COVID_Q66_A5; "Don’t know where to start"),
            optional(.COVID_Q66_A6; "Lack of access or affordability of the devices I need"),
            optional(.COVID_Q66_A7; "Haven’t heard of any"),
            optional(.COVID_Q66_A8; "None of the above")
          ]
        }
      ]
    }
  ]
}

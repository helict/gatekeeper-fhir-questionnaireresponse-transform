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
def inline_4x5(a1; a2; a3; a4): [{
  "valueCoding": {
    "system": "string",
    "code": {
      (a1): "Not at all",
      (a2): "Several days",
      (a3): "More than half the day",
      (a4): "Nearly every day",
    }[.]
  }
}];
def inline_7x7(a1; a2; a3): [{
  "valueCoding": {
    "system": "string",
    "code": {(a1): "Worse", (a2): "The same", (a3): "Better"}[.]
  }
}];
def inline_9x6(a1; a2; a3; a4): [{
  "valueCoding": {
    "system": "string",
    "code": {
      (a1): "Not at all",
      (a2): "Not very much",
      (a3): "Some",
      (a4): "Very much",
    }[.]
  }
}];

{
  "resourceType": "QuestionnaireResponse",
  "questionnaire": "http://hl7.eu/fhir/ig/gk/Questionnaire/covid-quest-1",
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
        },
        {
          "linkId": "demography.employment",
          "answer": {
            "valueString": {
              COVID_Q05_A1: "Employed",
              COVID_Q05_A2: "Self-employed",
              COVID_Q05_A3: "Unemployed",
              COVID_Q05_A4: "Unable to work",
              COVID_Q05_A5: "Homemaker",
              COVID_Q05_A6: "Student",
              COVID_Q05_A7: "Retired",
            }[.COVID_Q05]
          }
        }
      ]
    },
    {
      "linkId": "overallHealthStatus",
      "item": [
        {
          "linkId": "healthStatus",
          "item": [{
            "linkId": "healthStatus.rate",
            "answer": .COVID_Q06 | loinc
          }]
        },
        {
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
        }
      ]
    },
    {
      "linkId": "covid19HealthExposureStatus",
      "item": [
        {
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
        },
        {
          "linkId": "covid19HealthExposureStatus.symptoms",
          "answer": [
            optional(.COVID_Q09_A1; "Cough"),
            optional(.COVID_Q09_A2; "Fever"),
            optional(.COVID_Q09_A3; "Fatigue"),
            optional(.COVID_Q09_A4; "Headache"),
            optional(.COVID_Q09_A5; "Shortness of breath"),
            optional(.COVID_Q09_A6; "Sore throat"),
            optional(.COVID_Q09_A7; "Diarrhoea"),
            optional(.COVID_Q09_A8; "Nausea/vomiting"),
            optional(.COVID_Q09_A9; "Loss of taste or smell"),
            optional(.COVID_Q09_A10; "Runny nose"),
            optional(.COVID_Q09_A11; "Abdominal pain"),
            optional(.COVID_Q09_A12; .COVID_Q09_detail),
            optional(.COVID_Q09_A13; "None of the above")
          ]
        },
        {
          "linkId": "covid19HealthExposureStatus.other",
          "answer": [
            optional(.COVID_Q10_A1; "Yes, someone with positive test"),
            optional(.COVID_Q10_A2; "Yes, someone with the symptoms likely to be associated with an infection"),
            optional(.COVID_Q10_A3; "No")
          ]
        },
        {
          "linkId": "covid19HealthExposureStatus.household",
          "answer": .COVID_Q11 | loinc
        },
        {
          "linkId": "covid19HealthExposureStatus.householdEvents",
          "answer": [
            optional(.COVID_Q12_A1; "Fallen ill physically"),
            optional(.COVID_Q12_A2; "Hospitalized"),
            optional(.COVID_Q12_A3; "Passed away"),
            optional(.COVID_Q12_A4; "Put into self-quarantine with symptoms"),
            optional(.COVID_Q12_A5; "Put into self-quarantine without symptoms (e.g., due to possible exposure)"),
            optional(.COVID_Q12_A6; "None of the above")
          ]
        }
      ]
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
            },
            {
              "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks",
              "item": [
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.informed",
                  "answer": .COVID_Q15 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.protected",
                  "answer": .COVID_Q16 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.afraid",
                  "answer": .COVID_Q17 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.afraidForFamily",
                  "answer": .COVID_Q18 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.isolated",
                  "answer": .COVID_Q19 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.avoided",
                  "answer": .COVID_Q20 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelings2Weeks.exhausted",
                  "answer": .COVID_Q21 | loinc
                }
              ]
            },
            {
              "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak",
              "item": [
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.informed",
                  "answer": .COVID_Q22 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.protected",
                  "answer": .COVID_Q23 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.afraid",
                  "answer": .COVID_Q24 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.afraidForFamily",
                  "answer": .COVID_Q25 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.isolated",
                  "answer": .COVID_Q26 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.avoided",
                  "answer": .COVID_Q27 | loinc
                },
                {
                  "linkId": "covid19PsychologicalImpact.generalQuestions.feelingsPeak.exhausted",
                  "answer": .COVID_Q28 | loinc
                }
              ]
            }
          ]
        },
        {
          "linkId": "covid19PsychologicalImpact.PHQ4",
          "item": [
            {
              "linkId": "covid19PsychologicalImpact.PHQ4.problems2Weeks",
              "item": [
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problems2Weeks.littleIntrest",
                  "answer": .COVID_Q29 | inline_4x5("COVID_Q29_A1"; "COVID_Q29_A2"; "COVID_Q29_A3"; "COVID_Q29_A4")
                },
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problems2Weeks.depressed",
                  "answer": .COVID_Q30 | inline_4x5("COVID_Q30_A1"; "COVID_Q30_A2"; "COVID_Q30_A3"; "COVID_Q30_A4")
                },
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problems2Weeks.anxious",
                  "answer": .COVID_Q31 | inline_4x5("COVID_Q31_A1"; "COVID_Q31_A2"; "COVID_Q31_A3"; "COVID_Q31_A4")
                },
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problems2Weeks.worrying",
                  "answer": .COVID_Q32 | inline_4x5("COVID_Q32_A1"; "COVID_Q32_A2"; "COVID_Q32_A3"; "COVID_Q32_A4")
                }
              ]
            },
            {
              "linkId": "covid19PsychologicalImpact.PHQ4.problemsPeak",
              "item": [
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problemsPeak.littleIntrest",
                  "answer": .COVID_Q33 | inline_4x5("COVID_Q33_A1"; "COVID_Q33_A2"; "COVID_Q33_A3"; "COVID_Q33_A4")
                },
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problemsPeak.depressed",
                  "answer": .COVID_Q34 | inline_4x5("COVID_Q34_A1"; "COVID_Q34_A2"; "COVID_Q34_A3"; "COVID_Q34_A4")
                },
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problemsPeak.anxious",
                  "answer": .COVID_Q35 | inline_4x5("COVID_Q35_A1"; "COVID_Q35_A2"; "COVID_Q35_A3"; "COVID_Q35_A4")
                },
                {
                  "linkId": "covid19PsychologicalImpact.PHQ4.problemsPeak.worrying",
                  "answer": .COVID_Q36 | inline_4x5("COVID_Q36_A1"; "COVID_Q36_A2"; "COVID_Q36_A3"; "COVID_Q36_A4")
                }
              ]
            },
            {
              "linkId": "covid19PsychologicalImpact.PHQ4.psychosocialSupport",
              "answer": [{
                "valueString": {
                  COVID_Q37_A1: "No",
                  COVID_Q37_A2: "None available",
                  COVID_Q37_A3: .COVID_Q37_detail,
                }[.COVID_Q37]
              }]
            },
            {
              "linkId": "covid19PsychologicalImpact.PHQ4.extraordinaryStress",
              "answer": [{
                "valueString": {
                  COVID_Q38_A1: "No",
                  COVID_Q38_A2: .COVID_Q38_detail,
                }[.COVID_Q38]
              }]
            }
          ]
        }
      ]
    },
    {
      "linkId": "lifestyleHabits",
      "item": [
        {
          "linkId": "lifestyleHabits.smokingBeforeCovid19",
          "answer": [{
            "valueString": {
              COVID_Q39_A1: "No, I have never smoked",
              COVID_Q39_A2: "No, I quitted smoking",
              COVID_Q39_A3: "Yes, <7 cigarettes per week",
              COVID_Q39_A4: "Yes, <10 cigarettes per day",
              COVID_Q39_A5: "Yes, >10 cigarettes per day",
            }[.COVID_Q39]
          }]
        },
        {
          "linkId": "lifestyleHabits.smokingNow",
          "answer": [{
            "valueString": {
              COVID_Q40_A1: "No, I have never smoked",
              COVID_Q40_A2: "No, I quitted smoking",
              COVID_Q40_A3: "Yes, <7 cigarettes per week",
              COVID_Q40_A4: "Yes, <10 cigarettes per day",
              COVID_Q40_A5: "Yes, >10 cigarettes per day",
            }[.COVID_Q40]
          }]
        },
        {
          "linkId": "lifestyleHabits.alcohoolBeforeCovid19",
          "answer": [{
            "valueString": {
              COVID_Q41_A1: "No, I have never drank (on a daily basis)",
              COVID_Q41_A2: "No, I quitted drinking (on a daily basis)",
              COVID_Q41_A3: "Yes, occasionally",
              COVID_Q41_A4: "Yes, daily",
            }[.COVID_Q41]
          }]
        },
        {
          "linkId": "lifestyleHabits.alcohoolNow",
          "answer": [{
            "valueString": {
              COVID_Q42_A1: "No, I have never drank (on a daily basis)",
              COVID_Q42_A2: "No, I quitted drinking (on a daily basis)",
              COVID_Q42_A3: "Yes, occasionally",
              COVID_Q42_A4: "Yes, daily",
            }[.COVID_Q42]
          }]
        },
        {
          "linkId": "lifestyleHabits.drugsBeforeCovid19",
          "answer": [{
            "valueString": {
              COVID_Q43_A1: "No, I have never used recreational drugs",
              COVID_Q43_A2: "No, I quitted using recreational drugs",
              COVID_Q43_A3: "Yes, occasionally",
              COVID_Q43_A4: "Yes, regularly",
            }[.COVID_Q43]
          }]
        },
        {
          "linkId": "lifestyleHabits.drugsNow",
          "answer": [{
            "valueString": {
              COVID_Q44_A1: "Nein, ich habe nie Drogen konsumiert",
              COVID_Q44_A2: "Nein, ich habe aufgehört Drogen zu konsumieren",
              COVID_Q44_A3: "Ja, gelegentlich",
              COVID_Q44_A4: "Ja, regelmäßig",
            }[.COVID_Q44]
          }]
        }
      ]
    },
    {
      "linkId": "physicalActivity",
      "item": [
        {
          "linkId": "physicalActivity.vigorous",
          "answer": [{
            "valueString": {
              COVID_Q45_A1: "3 or more times/week",
              COVID_Q45_A2: "1–2 times/week",
              COVID_Q45_A3: "None",
            }[.COVID_Q45]
          }]
        },
        {
          "linkId": "physicalActivity.moderate",
          "answer": [{
            "valueString": {
              COVID_Q46_A1: "5 or more times/week",
              COVID_Q46_A2: "3–4 times/week",
              COVID_Q46_A3: "1–2 times/week",
              COVID_Q46_A4: "None",
            }[.COVID_Q46]
          }]
        },
        {
          "linkId": "physicalActivity.sedentaryTime",
          "answer": [{"valueInteger": .COVID_Q47 | tonumber}]
        },
        {
          "linkId": "physicalActivity.overallLast2Weeks",
          "answer": [{
            "valueString": {
              COVID_Q48_A1: "Now I do less physical activity",
              COVID_Q48_A2: "Now I do more or less the same amount of physical activity",
              COVID_Q48_A3: "Now I do more physical activity",
            }[.COVID_Q48]
          }]
        }
      ]
    },
    {
      "linkId": "sleepHealth",
      "item": [
        {
          "linkId": "sleepHealth.satisfaction",
          "answer": .COVID_Q49 | loinc
        },
        {
          "linkId": "sleepHealth.awakeAllDay",
          "answer": .COVID_Q50 | loinc
        },
        {
          "linkId": "sleepHealth.asleepDuringNightHours",
          "answer": .COVID_Q51 | loinc
        },
        {
          "linkId": "sleepHealth.timeAwake",
          "answer": .COVID_Q52 | loinc
        },
        {
          "linkId": "sleepHealth.sleepDuration",
          "answer": .COVID_Q53 | loinc
        },
        {
          "linkId": "sleepHealth.regularity",
          "answer": .COVID_Q54 | loinc
        },
        {
          "linkId": "sleepHealth.overallQualityVsBeforeCovid19",
          "answer": .COVID_Q55 | inline_7x7("COVID_Q55_A1"; "COVID_Q55_A2"; "COVID_Q55_A3")
        },
        {
          "linkId": "sleepHealth.overallQualityVsPeakCovid19",
          "answer": .COVID_Q56 | inline_7x7("COVID_Q56_A1"; "COVID_Q56_A2"; "COVID_Q56_A3")
        },
        {
          "linkId": "sleepHealth.medication",
          "answer": [{
            "valueString": {
              COVID_Q57_A1: "Yes, both before and during the pandemic.",
              COVID_Q57_A2: "Yes, I started it during the pandemic.",
              COVID_Q57_A3: "No, but I have used it before the pandemic.",
              COVID_Q57_A4: "No, I have never used medication to sleep.",
            }[.COVID_Q57]
          }]
        }
      ]
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
        },
        {
          "linkId": "digitalHealthcare.responsibleDataUsageConfidence",
          "answer": [{
            "valueString": {
              COVID_Q67_A1: "Not at all confident",
              COVID_Q67_A2: "Not very confident",
              COVID_Q67_A3: "Somewhat confident",
              COVID_Q67_A4: "Very confident",
            }[.COVID_Q67]
          }]
        },
        {
          "linkId": "digitalHealthcare.trust",
          "item": [
            {
              "linkId": "digitalHealthcare.trust.hospitals",
              "answer": .COVID_Q68 | inline_9x6("COVID_Q68_A1"; "COVID_Q68_A2"; "COVID_Q68_A3"; "COVID_Q68_A4")
            },
            {
              "linkId": "digitalHealthcare.trust.doctors",
              "answer": .COVID_Q69 | inline_9x6("COVID_Q69_A1"; "COVID_Q69_A2"; "COVID_Q69_A3"; "COVID_Q69_A4")
            },
            {
              "linkId": "digitalHealthcare.trust.pharmacy",
              "answer": .COVID_Q70 | inline_9x6("COVID_Q70_A1"; "COVID_Q70_A2"; "COVID_Q70_A3"; "COVID_Q70_A4")
            },
            {
              "linkId": "digitalHealthcare.trust.labs",
              "answer": .COVID_Q71 | inline_9x6("COVID_Q71_A1"; "COVID_Q71_A2"; "COVID_Q71_A3"; "COVID_Q71_A4")
            },
            {
              "linkId": "digitalHealthcare.trust.insuranceCompany",
              "answer": .COVID_Q72 | inline_9x6("COVID_Q72_A1"; "COVID_Q72_A2"; "COVID_Q72_A3"; "COVID_Q72_A4")
            },
            {
              "linkId": "digitalHealthcare.trust.techCompany",
              "answer": .COVID_Q73 | inline_9x6("COVID_Q73_A1"; "COVID_Q73_A2"; "COVID_Q73_A3"; "COVID_Q73_A4")
            },
            {
              "linkId": "digitalHealthcare.trust.government",
              "answer": .COVID_Q74 | inline_9x6("COVID_Q74_A1"; "COVID_Q74_A2"; "COVID_Q74_A3"; "COVID_Q74_A4")
            }
          ]
        }
      ]
    },
    {
      "linkId": "covid19EffectsOnChronicDiseases",
      "item": [
        {
          "linkId": "accessMedCare",
          "item": [
            {
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
            },
            {
              "linkId": "accessMedCares.waitAppointmentDuringCovid19",
              "answer": [{
                "valueString": {
                  COVID_Q76_A1: "Much longer",
                  COVID_Q76_A2: "Somewhat longer",
                  COVID_Q76_A3: "Stayed the same",
                  COVID_Q76_A4: "Somewhat shorter",
                  COVID_Q76_A5: "Much shorter",
                  COVID_Q76_A6: "Not applicable",
                }[.COVID_Q76]
              }]
            },
            {
              "linkId": "accessMedCares.prescriptionDuringCovid19",
              "answer": [{
                "valueString": {
                  COVID_Q77_A1: "Each time",
                  COVID_Q77_A2: "Very often",
                  COVID_Q77_A3: "Sometimes",
                  COVID_Q77_A4: "Rarely",
                  COVID_Q77_A5: "Never",
                  COVID_Q77_A6: "Not applicable",
                }[.COVID_Q77]
              }]
            },
            {
              "linkId": "accessMedCares.prescriptionRunoutDuringCovid19",
              "answer": [{
                "valueString": {
                  COVID_Q78_A1: "No",
                  COVID_Q78_A2: "Yes, once",
                  COVID_Q78_A3: "Yes, twice or more",
                  COVID_Q78_A4: "Not applicable",
                }[.COVID_Q78]
              }]
            }
          ]
        },
        {
          "linkId": "motivationAndSupport",
          "item": [
            {
              "linkId": "motivationAndSupport.family",
              "answer": [{
                "valueString": {
                  COVID_Q79_A1: "Much worse",
                  COVID_Q79_A2: "Somewhat worse",
                  COVID_Q79_A3: "Stayed the same",
                  COVID_Q79_A4: "Somewhat better",
                  COVID_Q79_A5: "Much better",
                  COVID_Q79_A6: "Not applicable",
                }[.COVID_Q79]
              }]
            },
            {
              "linkId": "motivationAndSupport.healthcareProfessionals",
              "answer": [{
                "valueString": {
                  COVID_Q80_A1: "Much worse",
                  COVID_Q80_A2: "Somewhat worse",
                  COVID_Q80_A3: "Stayed the same",
                  COVID_Q80_A4: "Somewhat better",
                  COVID_Q80_A5: "Much better",
                  COVID_Q80_A6: "Not applicable",
                }[.COVID_Q80]
              }]
            }
          ]
        }
      ]
    },
    {
      "linkId": "covid19Vaccination",
      "item": [
        {
          "linkId": "covid19Vaccination.informed",
          "answer": [{"valueInteger": .COVID_Q81}]
        },
        {
          "linkId": "covid19Vaccination.status",
          "answer": .COVID_Q82 | loinc
        },
        if .COVID_Q82 == "LA32-8" then {
          "linkId": "covid19Vaccination.will",
          "answer": .COVID_Q83 | loinc
        } else {
          "linkId": "covid19Vaccination.adverseEffects",
          "answer": .COVID_Q84 | loinc
        } end,
        {
          "linkId": "covid19Vaccination.everyYear",
          "answer": .COVID_Q85 | loinc
        }
      ]
    }
  ]
}

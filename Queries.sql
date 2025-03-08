CREATE TABLE heart_disease (
   Chest_pain INTERGER,
   Shortness_of_breath INTERGER,
   Fatigue INTERGER,
   Palpitation INTERGER,
   Dizziness INTERGER,
   Swelling INTERGER,
   Pain_Arms_Jaw_Back INTERGER,
   Cold_sweats_Nausea INTERGER,
   High_BP INTERGER,
   High_colesterol INTERGER,
   Diabetes INTERGER,
   Smoking INTERGER,
   Obesity INTERGER,
   Sedentary_Lifestyle INTERGER,
   Family_History INTERGER,
   Chronic_Stress INTERGER,
   Gender INTERGER,
   Age INTERGER,
   Heart_Risk INTERGER
);

CREATE TABLE stroke_data (
   Age NUMERIC,
   Gender STRING,
   SES STRING,
   Hypertension INTERGER,
   Heart_Disease INTERGER,
   BMI NUMERIC,
   Avg_Glucose INTERGER,
   Diabetes INTERGER,
   Smoking_Status STRING,
   Stroke INTERGER
);

--DELETE FROM heart_disease
--WHERE ROWID = (SELECT MIN(1) FROM heart_disease);

--VACUUM;

-- Altera os valores 0 e 1 das tabelas por Sim ou Não e altera os valores em inglês por português

UPDATE heart_disease
SET 
    Chest_Pain = CASE WHEN Chest_Pain = 0 THEN 'Não' WHEN Chest_Pain = 1 THEN 'Sim' END,
    Shortness_of_breath = CASE WHEN Shortness_of_breath = 0 THEN 'Não' WHEN Shortness_of_breath = 1 THEN 'Sim' END,
    Fatigue = CASE WHEN Fatigue = 0 THEN 'Não' WHEN Fatigue = 1 THEN 'Sim' END,
    Palpitation = CASE WHEN Palpitation = 0 THEN 'Não' WHEN Palpitation = 1 THEN 'Sim' END,
    Dizziness = CASE WHEN Dizziness = 0 THEN 'Não' WHEN Dizziness = 1 THEN 'Sim' END,
    Swelling = CASE WHEN Swelling = 0 THEN 'Não' WHEN Swelling = 1 THEN 'Sim' END,
    Pain_Arms_Jaw_Back = CASE WHEN Pain_Arms_Jaw_Back = 0 THEN 'Não' WHEN Pain_Arms_Jaw_Back = 1 THEN 'Sim' END,
    Cold_sweats_Nausea = CASE WHEN Cold_sweats_Nausea = 0 THEN 'Não' WHEN Cold_sweats_Nausea = 1 THEN 'Sim' END,
    High_BP = CASE WHEN High_BP = 0 THEN 'Não' WHEN High_BP = 1 THEN 'Sim' END,
    High_colesterol = CASE WHEN High_colesterol = 0 THEN 'Não' WHEN High_colesterol = 1 THEN 'Sim' END,
    Diabetes = CASE WHEN Diabetes = 0 THEN 'Não' WHEN Diabetes = 1 THEN 'Sim' END,
    Smoking = CASE WHEN Smoking = 0 THEN 'Não' WHEN Smoking = 1 THEN 'Sim' END,
    Obesity = CASE WHEN Obesity = 0 THEN 'Não' WHEN Obesity = 1 THEN 'Sim' END,
    Sedentary_Lifestyle = CASE WHEN Sedentary_Lifestyle = 0 THEN 'Não' WHEN Sedentary_Lifestyle = 1 THEN 'Sim' END,
    Family_History = CASE WHEN Family_History = 0 THEN 'Não' WHEN Family_History = 1 THEN 'Sim' END,
    Chronic_Stress = CASE WHEN Chronic_Stress = 0 THEN 'Não' WHEN Chronic_Stress = 1 THEN 'Sim' END,
    Gender = CASE WHEN Gender = 0 THEN 'Masculino' WHEN Gender = 1 THEN 'Feminino' END,
    Heart_Risk = CASE WHEN Heart_Risk = 0 THEN 'Não' WHEN Heart_Risk = 1 THEN 'Sim' END;
   

UPDATE stroke_data
SET 
    Hypertension = CASE WHEN Hypertension = 0 THEN 'Não' WHEN Hypertension = 1 THEN 'Sim' END,
    Heart_Disease = CASE WHEN Heart_Disease = 0 THEN 'Não' WHEN Heart_Disease = 1 THEN 'Sim' END,
    Diabetes = CASE WHEN Diabetes = 0 THEN 'Não' WHEN Diabetes = 1 THEN 'Sim' END,
    Stroke = CASE WHEN Stroke = 0 THEN 'Não' WHEN Stroke = 1 THEN 'Sim' END,
    Gender = CASE WHEN Gender = 'Male' THEN 'Masculino' WHEN Gender = 'Female' THEN 'Feminino' END,
    SES = CASE WHEN SES = 'Medium' THEN 'Médio' WHEN SES = 'Low' THEN 'Baixo' WHEN SES = 'High' THEN 'Alto' END,
    Smoking_Status = CASE WHEN Smoking_Status = 'Current' THEN 'Ativo' WHEN Smoking_Status = 'Never' THEN 'Nunca' WHEN Smoking_Status = 'Former' THEN 'Ex-fumante' END;
    
-- Comparação entre os gêneros

SELECT gender, Heart_Risk, COUNT(*) as total
FROM heart_disease
GROUP BY gender, Heart_Risk;

-- Analise de variavel específica

SELECT Palpitation, Heart_Risk, COUNT(*) as total
FROM heart_disease
GROUP BY Palpitation, Heart_Risk;

SELECT Fatigue, Heart_Risk, COUNT(*) as total
FROM heart_disease
GROUP BY Fatigue, Heart_Risk;

SELECT Dizziness, Heart_Risk, COUNT(*) as total
FROM heart_disease
GROUP BY Dizziness, Heart_Risk;


SELECT Smoking_Status, Stroke, COUNT(*) as total
FROM stroke_data
GROUP BY Smoking_Status, Stroke;

-- Relações entre várias variáveis

SELECT Age, Diabetes, Hypertension, Stroke
FROM stroke_data;

-- Porcentagem de Infartos relacionando Sexo e idade
CREATE TABLE percentage AS
SELECT Gender,
     CASE
            WHEN CAST(Age AS INT) < 30 THEN 'Under 30'
            WHEN CAST(Age AS INT) BETWEEN 30 AND 50 THEN '30-50'
            ELSE 'Above 50'
        END AS age_group,
        COUNT(*) AS total_patients,
        SUM(CASE WHEN Stroke = 'Sim' THEN 1 ELSE 0 END) AS total_strokes,
        ROUND(SUM(CASE WHEN Stroke = 'Sim' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS stroke_percentage
 FROM stroke_data
 GROUP BY Gender, age_group;



-- JOIN nas duas tabelas analisando risco de doença cardiaca e AVC baseado no Sexo dos pacientes

WITH heart_agg AS (
    SELECT 
        Gender,
        AVG(CASE WHEN Heart_Risk = 'Sim' THEN 1 ELSE 0 END) AS media_heart_risk,
        COUNT(CASE WHEN Heart_Risk = 'Sim' THEN 1 ELSE 0 End) AS contagem_Risco
    FROM heart_disease
    GROUP BY Gender
),
stroke_agg AS (
    SELECT 
        Gender,
        AVG(CASE WHEN Stroke = 'Sim' THEN 1 ELSE 0 END) AS taxa_stroke,
        COUNT(CASE WHEN Stroke = 'Sim' THEN 1 ELSE 0 END) AS contagem_avc_positivo
    FROM stroke_data
    GROUP BY Gender
)
SELECT 
    h.Gender,
    h.media_heart_risk,
    h.contagem_Risco,
    s.taxa_stroke,
    s.contagem_avc_positivo
FROM heart_agg h
JOIN stroke_agg s ON h.Gender = s.Gender;

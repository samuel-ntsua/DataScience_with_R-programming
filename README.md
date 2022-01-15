# Data Science with R Programming.
_WARNING: Please do not submit this solution for your Simplilearn project!! Your submission will be flagged for plagiarism_  
I completed this Data Science project to fulfill one of the requirements for Simplilearn's Data Science certification.  
**To be awarded the certificate, learners must submit a non-guided project in each of the following courses:**
    1. **_Data Science with R Programming_** (Deadline for project: Aug 15, 2018)
    2. Data Science with Python
    3. Machine Learning
    4. Tableau Training
    5. Big Data Hadoop and Spark Developer
    6. Data Science Capstone project
### Some housekeeping.
I generated an output of this write-up using knitr. (In RStudio, File->Knit Document). Knitr then runs my r-code and knit the output into a nice word document.  Please note that if there is a line in the code that installs a package , knitr expect the repository to be explicitly specified, like in install.packages(..., repos="....")

All packages used in this code are installed and loaded using pacman::p_load
`install.packages("pacman")`
`pacman::p_load(ggplot2, tidyr, dplyr)`

###### R packages used in this project.

I use this trick (gathered from the internet) to skip package already installed in my RStudio.

```R-programming
packages <- c("Hmisc","corrplot","PerformanceAnalytics","correlation","car","caTools")

installed_packages <- packages %in% rownames(installed.packages())

if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages], repos = "http://cran.us.r-project.org" )
}

invisible(lapply(packages, library, character.only = TRUE))
```

### Project description and tasks.

A nationwide survey of hospital costs conducted by the US Agency for Healthcare
consists of hospital records of inpatient samples. The given data is restricted to
the city of Wisconsin and relates to patients in the age group 0-17 years. The
agency wants to analyze the data to research on the healthcare costs and their
utilization.

Here is a detailed description of the given dataset:
* AGE : Age of the patient discharged
* FEMALE : Binary variable that indicates if the patient is female
* LOS : Length of stay, in days
* RACE : Race of the patient (specified numerically)
* TOTCHG : Hospital discharge costs
* APRDRG : All Patient Refined Diagnosis Related Groups

The goals of this project are:
- To record the patient statistics, the agency wants to find the age category
of people who frequent the hospital and has the maximum expenditure.
- In order of severity of the diagnosis and treatments and to find out the
expensive treatments, the agency wants to find the diagnosis related group
that has maximum hospitalization and expenditure.
- To make sure that there is no malpractice, the agency needs to analyze if
the race of the patient is related to the hospitalization costs.
- To properly utilize the costs, the agency has to analyze the severity of the
hospital costs by age and gender for proper allocation of resources.
- Since the length of stay is the crucial factor for inpatients, the agency wants
to find if the length of stay can be predicted from age, gender, and race.
- To perform a complete analysis, the agency wants to find the variable that
mainly affects the hospital costs.

---
This is the link to the source data at Wisconsin School of Business. The data is part of the resources accompanying the textbook ```Regression Modeling with Actuarial and Financial Applications by Edward W. Frees.ISBN: 9780521135962```  : [HospitalCosts](https://instruction.bus.wisc.edu/jfrees/jfreesbooks/Regression%20Modeling/BookWebDec2010/CSVData/HospitalCosts.csv)

### My approach to solution.

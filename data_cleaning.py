import pandas as pd

# Importing the required csv files
df_job_skills = pd.read_csv("Schema/job_skills.csv")
df_job_skills_connector_raw = pd.read_csv("Schema/Unused/job_skills_connector_raw.csv")


# Cleaning job_skills_connector_raw DataFrame
df_job_skills["skill_name"] = df_job_skills["skill_name"].str.lower().str.strip()

# Splitting job skills into rows by comma
df_job_skills_connector_raw["job_skills"] = df_job_skills_connector_raw["job_skills"].str.split(", ")

df_job_skills_connector = df_job_skills_connector_raw.explode("job_skills")
df_job_skills_connector_raw['job_skills'].explode('job_skills')


df_job_skills_connector["job_skills"] = df_job_skills_connector["job_skills"].str.strip()

#Merging the cleaned job_skill in connector with skill_id from job_skills
df_merged = df_job_skills_connector.merge(
    df_job_skills[["skill_id", "skill_name"]],
    left_on="job_skills",
    right_on="skill_name",
    how="inner",
)

#Removing unnecessary columns
df_merged.drop(columns=["skill_name", "job_skills"], inplace=True)



print(df_merged.head(50))


#Exporting
df_merged.to_csv("cleaned_job_skill_connector.csv", index=False)

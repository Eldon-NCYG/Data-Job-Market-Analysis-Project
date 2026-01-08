# Deep Analysis into the Data

Rather than doing a simple surface level summary about the data (which can be shown through data visualisations alone), this deeper analysis to goes above and beyond uncover less obvious patterns, trends, and relationships. I analysed how specific job roles differ from each other, how geographic and technical competence factors affect salaries, and what technical skills are most in-demand and trending.

## Executive Questions:

I have organised my analysis into four different categories of questions. Each category has questions designed to yieled deeper, decision-relevant insights. The SQL file showing all queries to answer these questions is [here](sql_scripts/analysis.sql).

### Technical Skill Importance: What skills should I learn to stay ahead of the curve and have the best ROI?

#### **Foundational Skills:**

##### What are the universal foundation skills that every data/tech professional must have, regardless of title and seniority?

![Foundational Skills Table](<Images/Analysis Images/skills_foundational.png>)

- **50% Margin:** Python (51%) & SQL (50.2%) are the only two skills in the dataset that cross the 50% margin.
- **Opportunity Cost:** If someone lacks Python or SQL in their skillset, statistically, they are out of over half of the total jobs in this dataset.
- These two skills would be considered foundational skills every individual in the job market should know.
- **Cloud Computing Rise:** There is also a strong demand in cloud computing platforms like AWS (21%) and Azure (19.6%). This makes sense as cloud computing has been rising in popularity in the past couple of years.
  ![Foundational Skills Visualisation](<Images/Analysis Images/skills_foundational_vis.png>)

#### **Skills Trending in 2024:**

##### Which emerging skills saw the highest growth in 2024? Does this pose a shift in the industry's standard tech stack for the future?

![Trending Skills Table](<Images/Analysis Images/skills_trending.png>)

- **Trending Skill of 2024:** The only 'trending' skill in 2024 was Hugging Face, a large open source library for large language models and specialised AI apps. It had a 322.3% growth rate in 2024.
- This is likely because of a big structural evolution in 2024 due to several big updates, driving it to be the "central hub" for open sourced models.
- **AI Revolution:** This indicates a shift from traditional predictive analytics (standard machine learning) to generative and agentic workflows.
- All the other skills have been pretty stagnant in terms of their growth in demand in 2024.

#### **Skill Category Value:**

##### Which skill category categories currently have the highest average salaries, and does this remain consistent across different seniority levels?

![Skill Category Value Table](<Images/Analysis Images/skils_category_value.png>)
![Skill Category Value Visualisation](<Images/Analysis Images/skills_category_value_vis.png>)

- **Databases Drastic Increase in Salary:** Databases show the most drastic salary increase. While juniors are getting paid on average $69,551, seniors get paid an average of $149,020. This 114% increase is the largest jump out of all the skill categories, indicating more technical database concepts like high-level data architecture is rare and highly compensated.
- **Analyst Tool Ceiling:** Analyst tools (like Excel, Tableau, and Power BI) have the lowest growth potential as you advance in seniority. Technical skills like Databases, Cloud, and Programming typically pay more, which indicates that technical depth is more valued when you're a senior.
- **ROI Maximising:** To maximise career ROI, the data suggests "depth over bredth". Rather than knowing basics from a lot of different categories, you should go into technical depth in one or two areas. The technical categories have a higher barrier as they are harder to pick up, but offer significantly better pay.

#### **Skill Variety & Compensation:**

##### Does a broader toolkit (average unique skill for a job posting) actually lead to a higher pay?

![Skill Density & Compensation Table](<Images/Analysis Images/skills_density_compensation.png>)
![Skill Density & Compensation Vis](<Images/Analysis Images/Skills/skill_variety_compensation_vis.png>)
![Skill Density & Compensation Distribution](<Images/Analysis Images/Skills/skill_variety_compensation_vis_2.png>)
- **Efficiency Collapse:** From an ROI perspective, skill efficiency significantly drops as you add more skill requirements. A specialist (1 - 2 skills) earns roughly $278k per skill whereas a standard professional (3 - 5 skills) earns an average of $60k per skill. By the time a professional reaches 10+ skills, they are earning only about $19k per skill. This is about a 14x decrease from a specialist with 1 - 2 skills.
- **Marginal Returns in skill acquisition:** Expanding your skillset to 10+ skills results in nearly stagnant salary growth. The effort required to learn and maintain this many skills for about a 1% increase in salary ($243k - $245k) represents a very poor ROI.
- **Depth over Breadth:** The data consistently shows that is more lucrative to focus on "technical depth" - mastering a couple of skills, rather than being a "jack of all trades" - skimming the surface of lots of skills.
- **Job Opportunity:** The market shows that you don't need a massive skillset to stay competitive. About 65% of job postings require 5 skills or fewer, while 45% of job postings require 6 or more.



### Job Market Trends: How did hiring volatility and seniority shifts throughout 2024 affect the job market?

### **Market Share & Saturation**

Which roles dominate and are the most in-demand in the current data job market.

### **Were there hiring seasons during 2024?:**

Which month in 2024 had the highest and lowest volume of new job postings?

### **Is the barrier of entry into the data tech field getting higher?:** Is the market favouring senior or junior roles? How did the number of senior and junior roles change throughout 2024?

### **Role Specific Volatility:** Which specific roles showed the most consistent hiring volume regardless of the season?

### Geographical Influence: Where are the best job opportunities located?

### **Global Opportunity Density:**

Which countries have the highest number of job postings relative to the number of unique companies hiring there?

### **Remote Job Distribution and pay:**

Which countries have embraced remote work, and which countries are staying in the office? And do remote and onsite jobs differ in pay?

### **Degree Importance By Country:**

Does where I live change how much employers care about a degree? And does a degree requirement lead to higher pay?

### **Role-Specific Geographic Hubs**

Were there any 'specialised hubs' (countries) for specific roles? Is there a country-specific premium for certain roles?

### Role Comparison Analysis: Which career path offers the highest salary return relative to its technical complexity?

#### **Technical ROI:**

Which job role offers the highest salary return relative to its technical complexity? Considering technical skills and if a degree is required.

#### **Seniority Difference:**

Which role has the steepest salary growth from Junior to Senior level?

#### **Degree Importance:**

How does degree market share vary across roles, and does a degree requirement translate into a higher salary?

#### **Skill Overlap between Data Analysts & Data Scientists:**

There seems to be a lot of nuance between these roles and they are often mistaken for each other. So what percentage of Data Analyst skills overlap with Data Scientist Skills?

### **Role Based Remoteness**

Which specific job roles the the highest 'Remote Market Share', and is there a significant pay difference between remote and on-site positions for the same title?

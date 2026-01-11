# Deep Analysis into the Data

Rather than doing a simple surface level summary about the data (which can be shown through data visualisations alone), this deeper analysis to goes above and beyond uncover less obvious patterns, trends, and relationships. I analysed how specific job roles differ from each other, how geographic and technical competence factors affect salaries, and what technical skills are most in-demand and trending.

# Executive Questions:

I have organised my analysis into four different categories of questions. Each category has questions designed to yieled deeper, decision-relevant insights. The SQL file showing all queries to answer these questions is [here](sql_scripts/analysis.sql).

## Technical Skill Importance: What skills should I learn to stay ahead of the curve and have the best ROI?

### **Foundational Skills:**

#### What are the universal foundation skills that every data/tech professional must have, regardless of title and seniority?

![Foundational Skills Table](<Images/Analysis Images/Skills/skills_foundational.png>)

- **50% Margin:** Python (51%) & SQL (50.2%) are the only two skills in the dataset that cross the 50% margin.
- **Opportunity Cost:** If someone lacks Python or SQL in their skillset, statistically, they are out of over half of the total jobs in this dataset.
- These two skills would be considered foundational skills every individual in the job market should know.
- **Cloud Computing Rise:** There is also a strong demand in cloud computing platforms like AWS (21%) and Azure (19.6%). This makes sense as cloud computing has been rising in popularity in the past couple of years.
![Foundational Skills Visualisation](<Images/Analysis Images/Skills/skills_foundational_vis.png>)


### **Skills Trending in 2024:**

#### Which emerging skills saw the highest growth in 2024? Does this pose a shift in the industry's standard tech stack for the future?

![Trending Skills Table](<Images/Analysis Images/Skills/skills_trending.png>)

- **Trending Skill of 2024:** The only 'trending' skill in 2024 was Hugging Face, a large open source library for large language models and specialised AI apps. It had a 322.3% growth rate in 2024.
- This is likely because of a big structural evolution in 2024 due to several big updates, driving it to be the "central hub" for open sourced models.
- **AI Revolution:** This indicates a shift from traditional predictive analytics (standard machine learning) to generative and agentic workflows.
- All the other skills have been pretty stagnant in terms of their growth in demand in 2024.

### **Skill Category Value:**

#### Which skill category categories currently have the highest average salaries, and does this remain consistent across different seniority levels?

![Skill Category Value Table](<Images/Analysis Images/Skills/skils_category_value.png>)
![Skill Category Value Visualisation](<Images/Analysis Images/Skills/skills_category_value_vis.png>)

- **Databases Drastic Increase in Salary:** Databases show the most drastic salary increase. While juniors are getting paid on average $69,551, seniors get paid an average of $149,020. This 114% increase is the largest jump out of all the skill categories, indicating more technical database concepts like high-level data architecture is rare and highly compensated.
- **Analyst Tool Ceiling:** Analyst tools (like Excel, Tableau, and Power BI) have the lowest growth potential as you advance in seniority. Technical skills like Databases, Cloud, and Programming typically pay more, which indicates that technical depth is more valued when you're a senior.
- **ROI Maximising:** To maximise career ROI, the data suggests "depth over bredth". Rather than knowing basics from a lot of different categories, you should go into technical depth in one or two areas. The technical categories have a higher barrier as they are harder to pick up, but offer significantly better pay.

### **Skill Variety & Compensation:**

#### Does a broader toolkit (average unique skill for a job posting) actually lead to a higher pay?

![Skill Density & Compensation Table](<Images/Analysis Images/Skills/skills_variety_compensation.png>)
![Skill Density & Compensation Vis](<Images/Analysis Images/Skills/skill_variety_compensation_vis.png>)
![Skill Density & Compensation Distribution](<Images/Analysis Images/Skills/skill_variety_compensation_vis_2.png>)
- **Efficiency Collapse:** From an ROI perspective, skill efficiency significantly drops as you add more skill requirements. A specialist (1 - 2 skills) earns roughly $278k per skill whereas a standard professional (3 - 5 skills) earns an average of $60k per skill. By the time a professional reaches 10+ skills, they are earning only about $19k per skill. This is about a 14x decrease from a specialist with 1 - 2 skills.
- **Marginal Returns in skill acquisition:** Expanding your skillset to 10+ skills results in nearly stagnant salary growth. The effort required to learn and maintain this many skills for about a 1% increase in salary ($243k - $245k) represents a very poor ROI.
- **Depth over Breadth:** The data consistently shows that is more lucrative to focus on "technical depth" - mastering a couple of skills, rather than being a "jack of all trades" - skimming the surface of lots of skills.
- **Job Opportunity:** The market shows that you don't need a massive skillset to stay competitive. About 65% of job postings require 5 skills or fewer, while 45% of job postings require 6 or more.

### Overall Market Technical Skill Importance Key Inights:
- **Foundational "Must-Have" Skills:** Python & SQL are the two skills that should be considered foundational skills which every candidate should have in their skillset. Lacking either skill effectively disqualifies a candidate from over half of all roles in the data tech field, regardless of seniority.
- **2024 AI Pivot:** Hugging Face emerged as the definitive trending sill of 2024 with a 322.3% growth rate. This indicates a fundamental shift in the data industry's tech stack, now focusing on Generative AI integration and agentic workflows over traditional predictive analytics.
- **Skillset Efficiency:** To to succeed in this job market, the data suggests a depth over breadth approach when it comes to learning technical skills, as 65% of job postings require five skills or fewer. To maximise efficiency, mastering 1-2 in-demand skills yields a 14x higher ROI-per-skill than a broad & shallow skillset.


## Job Market Trends: How did hiring volatility and seniority shifts throughout 2024 affect the job market?

### **Market Share & Saturation**
#### Which roles dominate and are the most in-demand in the current data job market.
![Job Market Share](<Images/Analysis Images/Market Trends/job_market_share_table.png>)
- This is just a quick reference for the data job market share. It is always helpful to know what the distribution is like for future reference.
![Job Market Share Chart](<Images/Analysis Images/Market Trends/job_market_share_vis.png>)




### **Were there hiring seasons during 2024?:**
![Hiring Seasons Table](<Images/Analysis Images/Market Trends/hiring_seasons_table.png>)

The month over month percentage change is showing a steady decline as the year progresses.
![Monthly vs Moving Average](<Images/Analysis Images/Market Trends/hiring_seasons_moving_avg_vs_monthly.png>)
**The data shows three distinct hiring seasons that a job seeker should know:**
- **Quarter 1 Peak:** Hiring was at its highest in Jan (52,917) and Feb (55,336). This is statistically the best time to apply, as many companies are adjusting to new annual budgets and headcounts.
- **Mid-Year Surge:** After a steady decline through quarter 2, July saw a massive 21.7% month-over-month increase. This represents another crucial hiring window.
- **Pre-hiring Window:** The market experienced a very sharp decline in hiring from Sep - Nov (bottoming out at 13,719 jobs). The 124.7% jump in month-over-month increase in December (30,831) indicates a very strong "pre-hiring" phase, where companies are getting ready for the following year.
![Month over Month hires](<Images/Analysis Images/Market Trends/month_over_month_hires.png>)


### **Is the barrier of entry into the data tech field getting higher?:** 
#### Is the market favouring senior or junior roles? How did the number of senior and junior roles change throughout 2024?
![Barrier to Entry Table](<Images/Analysis Images/Market Trends/barrier_to_entry_table.png>)
![Seniority Growth Percentage](<Images/Analysis Images/Market Trends/growth_percentage.png>)

- **Seniority Favoured:** The data job market in 2024 was heavily favouring professionals with established experience. 
- For every 1 Junior job posted in 2024, there were approximately 31 Mid-level jobs. This confirms that the barrier to entry for the data job market is getting higher.
- **Economic Struggle Worldwide:** A potential reason for this could be due to the slower worldwide economic growth (a lot of countries in recession) in 2024, leading to companies trying to cut costs on employees by prioritising candidates who can contribute immediately without extensive training.


### **Role Specific Volatility:** Which specific roles showed the most consistent hiring volume regardless of the season?
![Volatility Table](<Images/Analysis Images/Market Trends/volatility_table.png>)
- **Understanding Volatility (Standard Deviation):** `volatility_sd` is the average amount that the monthly job count deviates from the `avg_monthly_vol`. Typically, the higher the higher the average monthly job posting volume is, the higher the volatility.
- **Fair Comparison of Volatility:** To fairly track volatility, we use `stability_score`, which is `volatility_sd` / `avg_monthly_vol`. A higher score indicates a more "stable" role, where hiring remains consistent relative to its size.
- The table indicates that even if a role's average monthly job posting volume is high, it doesn't correspond to a high stability score.
- **Role Volatility comparison:** Analyst and Engineering roles are the most volatile, meaning their hiring is highly reactive to immediate business needs and seasonal shifts. Data Scientist roles were the most stable job role in the data job market.
- **Recommendation for Job Seekers:** Targeting highly stable roles like Data Science increases risk of 'seasonal rejection', whereas aiming for roles like Data & Business Analyst roles may require more precise timing to align with peak hiring windows during the year.
![Volatility Visualisation](<Images/Analysis Images/Market Trends/volatility_vis.png>)


### Overall Market Trends Key Insights:
- **Volume Vs. Stability:** The data shows that the 2024 data job market that favours Data Science for stability and Data Engineering for sheer volume. Analyst and Engineering roles are the most volatile, meaning their hiring is highly reactive to immediate business needs and seasonal shifts.
- **Seniority Pivot:** The data job market in 2024 was increasingly favouring more experienced workers as the year went on to potentially cut down training & liability costs. 
- **Hiring Seasonality:** The market has three distinct phases: a Q1 Peak (Jan-Feb), a Mid-Year Surge (July), and a Pre-hiring Window (December). The 124.7% spike in December indicates companies are preparing a month before budgets officially reset for the next year.


## Geographical Influence: Where are the best job opportunities located?

### **Global Opportunity Density:**

#### Which countries have the highest number of job postings relative to the number of unique companies hiring there?
![Opportunity Density Table](<Images/Analysis Images/Geographical Influence/opportunity_density_table.png>)
![Opportunity Density Visualistion](<Images/Analysis Images/Geographical Influence/opportunity_density_vis.png>)
- **Density Ratio:** This is `total_jobs` / `unique_companies`,representing the average number of job postings per company in a specific country. This serves as a metric for market concentration.
- **High Density, Emerging Countries:** Countries with a smaller data job market frequently show the highest density ratio. This occurs because global tech infrastructure is often concentrated within a few major firms in these regions rather than spread across a broad local ecosystem. El Salvador (8.62) and Guam (8.60) lead global rankings, suggesting a market dominated by a small number of high-volume hirers.
- **U.S. as the Central Tech Hub:** The data shows The United States is the definitive global leader in tech job opportunities. With 140,364 total jobs and 25,429 unique companies, it significantly outpaces every other country in the dataset, solidifying its status as the world’s central tech hub.
- **Secondary Global Tech Hubs:** Aside from the U.S. being the obvious tech hub, the data shows India and several European countries (such as U.K. Germany and France) as the secondary hubs.
- While these tech hub nations don't always have the highest density ratios, their high volume of unique companies indicates a more developed hiring landscape compared to emerging markets.
![alt text](<Images/Analysis Images/Geographical Influence/opportunity_map_vis.png>)


### **Remote Job Distribution and pay:**

#### Which countries have embraced remote work, and which countries are staying in the office? And do remote and onsite jobs differ in pay?
![alt text](<Images/Analysis Images/Geographical Influence/remote_table.png>)
- **Remote-Forward Hubs:** Remote adoption rate is higher within Western Countries. Canada (24.9%), Mexico (22.1%), and Poland (20.7%) showing significant remote job proportions.
- **Traditional In Office Cultures**: Remote adoption remains lowest in most Asian countries. Traditional "in-office" cultures persist in these regions, despite the global shift in tech. For example, Hong Kong (1.6%), Singapore (2.7%), and Malaysia (2.9%). This reluctance to adapt to remote work likely stems from traditional business philosophies that prioritise physical presence and established routines over digital flexibility.
![alt text](<Images/Analysis Images/Geographical Influence/remote_vis1.png>)
![alt text](<Images/Analysis Images/Geographical Influence/remote_vis2.png>)

- **The Remote Premium:** For the 2024 data job market, remote roles tend to have a higher average salary than onsite positions. This seems to be the effect of seniority. Senior positions show the highest remote adoption at 14.6% and have comparatively higher salaries reaching $153,423 compared to $138,780 for onsite. Conversely, Junior/Entry roles are are the only category where onsite pay exceeds remote pay, likely because these roles require more hands-on, onsite mentorship.
![alt text](<Images/Analysis Images/Geographical Influence/remote_table2.png>)


### **Degree Importance By Country:**

#### Does where I live change how much employers care about a degree? And does a degree requirement lead to higher pay?
![alt text](<Images/Analysis Images/Geographical Influence/degree_table.png>)
- **Global Shift to Skills-First Hiring:** By the end of 2024, 60% of job postings didn't require a degree and instead favoured the technical skills you brought to the table.
![alt text](<Images/Analysis Images/Geographical Influence/degree_proportion_vis.png>)
- **Degree Importance in Europe:** European countries tend to require degrees more than other countries in the world, like U.K. (52.5%) and Poland (50.8%), with over half of their job postings requiring a degree.
- The rest of the world has largely moved past this requirement with Less than ~40% of job postings requireing a degree.
- **The U.S. Tech Hub as a Market Disruptor:** The global tech hub, the U.S. has 78% of its job postings not requiring a degree. Given the U.S. tech industry's market's influence on global hiring trends, this suggests that degrees may become increasingly optional for staying competitive in the data industry.
![alt text](<Images/Analysis Images/Geographical Influence/degree_salary_vis.png>)
- **No relationship between degree and higher pay:** The data suggests there is no correlation between holding a degree and a higher salary. Professionals with degrees in some countries may have a higher pay while in other countries, professionals don't need a degree for a higher pay. 




### Overall Geographical Influence Key Insights:
- **Global Tech Hubs:** The U.S. claims the "Global Tech Hub" title due to its sheer volume of job postings and companies. Secondary tech hubs include several European nations, India, and Singapore for East/South East Asia.
- **Global Opportunity Density:** Smaller and emerging markets like El Salvador and Guam have the highest job-per-company density, while more developed job markets (U.S., India, Several European Countries) have a substantially higher volume of job postings and unique companies, despite not having as high of a density.
- **Cultural Adoption Divide:** Asian job markets have lower remote job adoption rates likely due to deeply rooted onsite traditions, while western markets are less conservative and have higher remote adoption rates.
- **Remote Pay Premium:** The average remote salary exceeds the average onsite salary due to senior roles having mroe remote positions and higher pay, skewing those averages.
- **Global Shift to "Skills-First":** Degrees are most prevalent in Europe, but globally, the market is moving towards a skills-first economy, increasingly favouring technical skills competence over holding a formal degree, all without influencing a professional's yearly salary.
- **U.S. favouring Skills over Degrees:** The global tech hub, the U.S. is favouring technical skills over a degree with over 78% of job postings not requiring a degree. Given the U.S. tech industry's market's influence on global hiring trends, this suggests that degrees may become increasingly optional for staying competitive in the data industry.



## Role Comparison Analysis: Which career path offers the highest salary return relative to its technical complexity?

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

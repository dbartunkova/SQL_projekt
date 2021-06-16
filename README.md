# SQL_projekt
Covid19_data - projekt od Engeta

Výsledkem scriptu je tabulka, která obsahuje faktory, které mohou ovlivňovat rychlost šíření koronaviru na úrovni jednotlivých států. 

Výsledná data jsou panelová, klíči jsou stát (country) a den (date). 
Samotné počty nakažených mi nicméně nejsou nic platné - je potřeba vzít v úvahu také počty provedených testů a počet obyvatel daného státu. Z těchto tří proměnných je potom možné vytvořit vhodnou vysvětlovanou proměnnou. Denní počty nakažených chci vysvětlovat pomocí proměnných několika typů. Každý sloupec v tabulce bude představovat jednu proměnnou. 

Bylo potřeba upravit hodnoty v tabulkách lookup_table a covid19_basic_differences a změnit název Czechia na Czech Republic, aby se názvy státu shodovaly napříč všemi tabulkami.


### V tabulce jsou vedle klíčů country a date tyto sloupce: 

weekend - binární proměnná pro víkend / pracovní den
season - roční období daného dne (zakódujte prosím jako 0 až 3)
population_density - hustota zalidnění - ve státech s vyšší hustotou zalidnění se nákaza může šířit rychleji
GDP_obyvatele_2019 - HDP na obyvatele - použijeme jako indikátor ekonomické vyspělosti státu
gini_koeficient - GINI koeficient - má majetková nerovnost vliv na šíření koronaviru?
mortaliy_under_5 - dětská úmrtnost - použijeme jako indikátor kvality zdravotnictví
median_age_2018 - medián věku obyvatel v roce 2018 - státy se starším obyvatelstvem mohou být postiženy více
religion a religion_percentage_2020 - podíly jednotlivých náboženství - použijeme jako proxy proměnnou pro kulturní specifika. Pro každé náboženství v daném státě bych chtěl procentní podíl jeho příslušníků na celkovém obyvatelstvu
life_exp_difference - rozdíl mezi očekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých proběhl rychlý rozvoj mohou reagovat jinak než země, které jsou vyspělé už delší dobu
průměrná denní (nikoli noční!) teplota
rainy_hours - počet hodin v daném dni, kdy byly srážky nenulové
max_daily_gust - maximální síla větru v nárazech během dne




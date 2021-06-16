# SQL_projekt
Covid19_data - projekt od Engeta

Výsledkem scriptu je tabulka, která obsahuje faktory, které mohou ovlivňovat rychlost šíření koronaviru na úrovni jednotlivých států. 

Výsledná data jsou panelová, klíči jsou stát (country) a den (date). 
Samotné počty nakažených mi nicméně nejsou nic platné - je potřeba vzít v úvahu také počty provedených testů a počet obyvatel daného státu. Z těchto tří proměnných je potom možné vytvořit vhodnou vysvětlovanou proměnnou. Denní počty nakažených chci vysvětlovat pomocí proměnných několika typů. Každý sloupec v tabulce bude představovat jednu proměnnou. 

Bylo potřeba upravit hodnoty v tabulkách lookup_table a covid19_basic_differences a změnit název "Czechia" na "Czech Republic", aby se názvy státu shodovaly napříč všemi tabulkami. Dále bylo potřeba upravit hodnoty v tabulce countries z "Praha" na "Prague".


#### V tabulce jsou vedle klíčů country a date tyto sloupce: 

weekend - binární proměnná pro víkend/pracovní den (vytvořené view, pokud je hodnota k danému dni = 1, tak je to víkend, pokud je hodnota = 0, tak se jedná o pracovní den)

season - roční období daného dne (zakódované jako 0 až 3), kdy měsíce 12, 1 a 2 = 0; měsíce 3, 4, 5 = 1; měsíce 6, 7, 8 = 2 a měsíce 9, 10, 11 = 3. Toto rozdělení na čtyři roční doby je meteorologické a je platné pro země v mírném pásmu. 

capital_city - tabulka weather obsahuje nikoliv názvy států, ale jen názvy měst (hlavních měst) - bylo potřeba propojit přes názvy měst (přes tabulku countries)

population_density - hustota zalidnění - ve státech s vyšší hustotou zalidnění se nákaza může šířit rychleji - údaj z tabulky countries
 
GDP_obyvatele_2019 - HDP na obyvatele - použijeme jako indikátor ekonomické vyspělosti státu - celkový údaj HDP z tabulky economies je vydělen počtem obyvatel (tabulka countries)

gini_koeficient - GINI koeficient - má majetková nerovnost vliv na šíření koronaviru? - z Giniho indexu uvedeného v tabulce economies jsem si vybrala nejaktuálnější údaj pro danou zemi a vydělila stem, abychom získali Giniho koeficient. 

mortaliy_under_5 - dětská úmrtnost - použijeme jako indikátor kvality zdravotnictví - údaj z tabulky economies

median_age_2018 - medián věku obyvatel v roce 2018 - státy se starším obyvatelstvem mohou být postiženy více - údaj z tabulky countries

percentage_confirmed - procento pozitivních případů z provedených testů

confirmed_per_milion - počet potvrzených případů v přepočtu na milion obyvatel

religion a religion_percentage_2020 - podíly jednotlivých náboženství - použijeme jako proxy proměnnou pro kulturní specifika. Pro každé náboženství v daném státě bych chtěl procentní podíl jeho příslušníků na celkovém obyvatelstvu

life_exp_difference - rozdíl mezi očekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých proběhl rychlý rozvoj mohou reagovat jinak než země, které jsou vyspělé už delší dobu

průměrná denní (nikoli noční!) teplota

rainy_hours - počet hodin v daném dni, kdy byly srážky nenulové - vytvořené view, údaje jsou uvedeny v tříhodinových intervalech, výsledná suma deštivých hodin během dne je tak vynásobená třemi

max_daily_gust - maximální síla větru v nárazech během dne - vytvořené view s maximální hodnotou nárazu větru během dne (kromě půlnočních hodnot)




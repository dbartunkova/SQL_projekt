# SQL_projekt
Covid19_data - projekt od Engeta

Výsledkem scriptu je tabulka, která obsahuje faktory, které mohou ovlivňovat rychlost šíření koronaviru na úrovni jednotlivých států. 

Výsledná data jsou panelová, klíči jsou stát (country) a den (date). 

Každý sloupec v tabulce představuje jednu proměnnou, díky které můžeme vysvětlovat počty nakažených. 

Bylo potřeba upravit hodnoty v tabulkách lookup_table a covid19_basic_differences a změnit název "Czechia" na "Czech Republic", aby se názvy státu shodovaly napříč všemi tabulkami. Dále bylo potřeba upravit hodnoty v tabulce countries z "Praha" na "Prague". Dále bylo zapotřebí upravit datový typ u proměnné temp (teplota), abychom mohli spočítat průměrnou teplotu. Tabulka weathers obsahuje mnoho null hodnot u atributu city, s čímž bylo potřeba při spojování tabulek počítat. Celkově v tabulkách některé údaje chybí (např. Gini index: není pro např. rok 2018 údaj u všech zemí, vybrala jsem proto pro výpočet vždy ten nejnovější rok). 


#### V tabulce jsou vedle klíčů country a date tyto sloupce: 

weekend - binární proměnná pro víkend/pracovní den (hodnota 1 značí víkend, hodnota 0 pracovní den)

season - roční období daného dne, kdy měsíce 12, 1 a 2 = 0; měsíce 3, 4, 5 = 1; měsíce 6, 7, 8 = 2 a měsíce 9, 10, 11 = 3. Toto rozdělení na čtyři roční doby je meteorologické a je platné pro země v mírném pásmu.

capital_city - tabulka weather obsahuje nikoliv názvy států, ale jen názvy měst (hlavních měst) - bylo potřeba propojit přes názvy měst (přes tabulku countries pomocí left join, abychom "neztratili" země, které nemají v tabulce weathers uvedený název města)

population_density - hustota zalidnění - ve státech s vyšší hustotou zalidnění se nákaza může šířit rychleji - údaj z tabulky countries
 
GDP_obyvatele_2019 - indikátor ekonomické vyspělosti státu - celkový údaj HDP z tabulky economies je vydělen počtem obyvatel (tabulka countries)

gini_koeficient - má majetková nerovnost vliv na šíření koronaviru? - z Giniho indexu uvedeného v tabulce economies jsem si vybrala nejaktuálnější údaj pro danou zemi a vydělila stem, abych získala Giniho koeficient. 

mortaliy_under_5 - dětská úmrtnost - indikátor kvality zdravotnictví - údaj z tabulky economies

median_age_2018 - medián věku obyvatel v roce 2018 - státy se starším obyvatelstvem mohou být postiženy více - údaj z tabulky countries

percentage_confirmed - procento pozitivních případů z provedených testů

confirmed_per_milion - počet potvrzených případů v přepočtu na milion obyvatel

religion a religion_percentage_2020 - podíly jednotlivých náboženství - proxy proměnná pro kulturní specifika. Pro každé náboženství v daném státě je uveden procentní podíl jeho příslušníků na celkovém obyvatelstvu

life_exp_difference - rozdíl mezi očekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých proběhl rychlý rozvoj mohou reagovat jinak než země, které jsou vyspělé už delší dobu

average_temperature - průměrná denní teplota - vypočítaná pomocí aritmetického průměru teplot naměřených v hlavních synoptických termínech (v 00:00, 06:00, 12:00 a 18:00 hod.).

rainy_hours - počet hodin v daném dni, kdy byly srážky nenulové - údaje jsou uvedeny v tříhodinových intervalech, výsledná suma deštivých hodin během dne je tak vynásobená třemi

max_daily_gust - maximální síla větru v nárazech během dne - vytvořené view s maximální hodnotou nárazu větru během dne (kromě půlnočních hodnot)




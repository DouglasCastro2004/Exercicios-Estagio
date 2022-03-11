--CONTE O NÚMERO DE INSTALAÇÕES--
1ª Questão : Para nossa primeira incursão em agregados, vamos nos ater a algo simples. 
Queremos saber quantas instalações existem - basta produzir uma contagem total.

	QUERY - select count(*) from cd.facilities;

--CONTE O NÚMERO DE INSTALAÇÕES CARAS--
2ª Questão : Produza uma contagem do número de instalações que têm um custo para hóspedes de 10 ou mais.

	QUERY - select count(*) from cd.facilities where guestcost >= 10;  

--CONTE O NÚMERO DE RECOMENDAÇÕES QUE CADA MEMBRO FAZ--
3ª Questão : Produza uma contagem do número de recomendações que cada membro fez. Ordem por ID de membro.

	QUERY - select recommendedby, count(*) 
			from cd.members
			where recommendedby is not null
			group by recommendedby
		order by recommendedby; 

--LISTE O TOTAL DE VAGAS RESERVADAS POR INSTALAÇÃO--
4ª Questão : Produza uma lista do número total de slots reservados por instalação. 
Por enquanto, basta produzir uma tabela de saída consistindo de id de instalação e slots, classificados por id de instalação.

	QUERY - select facid, sum(slots) as "Total Slots"
			from cd.bookings
			group by facid
		order by facid;

--LISTE O TOTAL DE VAGAS RESERVADAS POR INSTALAÇÃO EM UM DETERMINADO MÊS--
5ª Questão : Produza uma lista do número total de slots reservados por instalação no mês de setembro de 2012. 
Produza uma tabela de saída consistindo em id de instalação e slots, classificados pelo número de slots.

	QUERY - select facid, sum(slots) as "Total Slots"
			from cd.bookings
			where
				starttime >= '2012-09-01'
				and starttime < '2012-10-01'
			group by facid
		order by sum(slots);

--LISTE O TOTAL DE VAGAS RESERVADAS POR INSTALAÇÃO POR MÊS--
6ª Questão : Produza uma lista do número total de slots reservados por instalação por mês no ano de 2012. 
Produza uma tabela de saída consistindo de id de instalação e slots, classificados por id e mês.

	QUERY - select facid, extract(month from starttime) as month, sum(slots) as "Total Slots"
			from cd.bookings
			where extract(year from starttime) = 2012
			group by facid, month
		order by facid, month; 

--ENCONTRE A CONTAGEM DE MEMBROS QUE FIZERAM PELO MENOS UMA RESERVA--
7ª Questão : Encontre o número total de membros (incluindo convidados) que fizeram pelo menos uma reserva.

	QUERY - select count(distinct memid) from cd.bookings;

--LISTE INSTALAÇÕES COM MAIS DE 1000 SLOTS RESERVADOS--
8ª Questão : Produza uma lista de instalações com mais de 1.000 vagas reservadas. 
Produza uma tabela de saída consistindo de ID de instalação e slots, classificados por ID de instalação.

	QUERY - select facid, sum(slots) as "Total Slots"
        		from cd.bookings
       			group by facid
        		having sum(slots) > 1000
        	order by facid;

--ENCONTRE A RECEITA TOTAL DE CADA INSTALAÇÃO--
9ª Questão : Produza uma lista de instalações junto com sua receita total. 
A tabela de saída deve consistir no nome da instalação e receita, classificada por receita. 
Lembre-se que há um custo diferente para convidados e membros!

	QUERY - select facs.name, sum(slots * case
				when memid = 0 then facs.guestcost
				else facs.membercost
				end) as revenue
			from cd.bookings bks
			inner join cd.facilities facs
				on bks.facid = facs.facid
			group by facs.name
		order by revenue;  

--ENCONTRE INSTALAÇÕES COM RECEITA TOTAL INFERIOR A 1000--
10ª Questão : Produza uma lista de instalações com receita total inferior a 1.000. 
Produza uma tabela de saída consistindo no nome da instalação e receita, classificada por receita. 
Lembre-se que há um custo diferente para convidados e membros!

	QUERY - select name, revenue from (
			select facs.name, sum(case 
						when memid = 0 then slots * facs.guestcost
						else slots * membercost
					end) as revenue
				from cd.bookings bks
				inner join cd.facilities facs
					on bks.facid = facs.facid
				group by facs.name
			) as agg where revenue < 1000
		order by revenue;

--EMITA A ID DA INSTALAÇÃO QUE POSSUI O MAIOR NÚMERO DE SLOTS RESERVADOS--
11ª Questão : Emita o ID da instalação que tem o maior número de slots reservados. 
Para pontos de bônus, experimente uma versão sem cláusula LIMIT . 
Esta versão provavelmente parecerá bagunçada!

	QUERY - select facid, sum(slots) as "Total Slots"
			from cd.bookings
			group by facid
		order by sum(slots) desc
		LIMIT 1; 

--LISTE O TOTAL DE VAGAS RESERVADAS POR INSTALAÇÃO POR MÊS, PARTE 2-- 
12ª Questão : Produza uma lista do número total de vagas reservadas por instalação por mês no ano de 2012. 
Nesta versão, inclua linhas de saída contendo os totais de todos os meses por instalação e um total de todos os meses para todas as instalações. 
A tabela de saída deve consistir em id de instalação, mês e slots, ordenados por id e mês. 
Ao calcular os valores agregados para todos os meses e todos os facids, retorne valores nulos nas colunas month e facid.

	QUERY - select facid, extract(month from starttime) as month, sum(slots) as slots
			from cd.bookings
			where
				starttime >= '2012-01-01'
				and starttime < '2013-01-01'
			group by rollup(facid, month)
		order by facid, month;

--LISTE O TOTAL DE HORAS RESERVADAS POR INSTALAÇÃO NOMEADA--
13ª Questão : Produza uma lista do número total de horas reservadas por instalação, lembrando que um slot dura meia hora. 
A tabela de saída deve consistir na identificação da instalação, nome e horas reservadas, classificadas pela identificação da instalação. 
Tente formatar as horas com duas casas decimais.

	QUERY - select facs.facid, facs.name,
			trim(to_char(sum(bks.slots)/2.0, '9999999999999999D99')) as "Total Hours"

			from cd.bookings bks
			inner join cd.facilities facs
				on facs.facid = bks.facid
			group by facs.facid, facs.name
		order by facs.facid; 

--LISTE A PRIMEIRA RESERVA DE CADA MEMBRO APÓS 1º DE SETEMBRO DE 2012--
14ª Questão : Produza uma lista de cada nome de membro, ID e sua primeira reserva após 1º de setembro de 2012. 
Faça o pedido por ID de membro.

	QUERY - select mems.surname, mems.firstname, mems.memid, min(bks.starttime) as starttime
			from cd.bookings bks
			inner join cd.members mems on
				mems.memid = bks.memid
			where starttime >= '2012-09-01'
			group by mems.surname, mems.firstname, mems.memid
		order by mems.memid;

--PRODUZA UMA LISTA DE NOMES DE MEMBROS, COM CADA LINHA CONTENDO A CONTAGEM TOTAL DE MEMBROS--
15ª Questão : Produza uma lista de nomes de membros, com cada linha contendo a contagem total de membros. 
Ordene por data de ingresso e inclua membros convidados.

	QUERY - select count(*) over(), firstname, surname
			from cd.members
		order by joindate;

--PRODUZIR UMA LISTA NUMERADA DE MEMBROS--
16ª Questão : Produza uma lista numerada monotonicamente crescente de membros (incluindo convidados), ordenados por sua data de ingresso. 
Lembre-se de que não há garantia de que os IDs dos membros sejam sequenciais.

	QUERY - select row_number() over(order by joindate), firstname, surname
			from cd.members
		order by joindate;

--EMITA O ID DA NSTALAÇÃO QUE POSSUI O MAIOR NÚMERO DE SLOTS RESERVADOS, NOVAMENTE--
17ª Questão : Emita o ID da instalação que tem o maior número de slots reservados. 
Certifique-se de que, em caso de empate, todos os resultados de empate sejam exibidos.

	QUERY - select facid, total from (
			select facid, sum(slots) total, rank() over (order by sum(slots) desc) rank
        			from cd.bookings
			    group by facid
			) as ranked
			where rank = 1;

--CLASSIFIQUE OS MEMBROS POR HORAS (ARREDONDADAS) USADAS--
18ª Questão : Produza uma lista de membros (incluindo convidados), juntamente com o número de horas que eles reservaram nas instalações, 
arredondado para as dez horas mais próximas. 
Classifique-os por esse número arredondado, produzindo saída de primeiro nome, sobrenome, horas arredondadas, classificação. 
Classifique por classificação, sobrenome e nome.

	QUERY - select firstname, surname,
			((sum(bks.slots)+10)/20)*10 as hours,
			rank() over (order by ((sum(bks.slots)+10)/20)*10 desc) as rank
			from cd.bookings bks
			inner join cd.members mems
				on bks.memid = mems.memid
			group by mems.memid
		order by rank, surname, firstname; 

--ENCONTRE AS TRÊS PRINCIPAIS INSTALAÇÕES GERADORAS DE RECEITA--
19ª Questão : Produza uma lista das três principais instalações geradoras de receita (incluindo empates). 
Nome e classificação da instalação de saída, classificados por classificação e nome da instalação.

	QUERY - select name, rank from (
			select facs.name as name, rank() over (order by sum(case
						when memid = 0 then slots * facs.guestcost
						else slots * membercost
					end) desc) as rank
				from cd.bookings bks
				inner join cd.facilities facs
					on bks.facid = facs.facid
				group by facs.name
			) as subq
			where rank <= 3
		order by rank;

--CLASSIFIQUE AS INSTALAÇÕES POR VALOR--
20ª Questão : Classifique as instalações em grupos de tamanho igual de alto, médio e baixo com base em sua receita. 
Ordene por classificação e nome da instalação.

	QUERY - select name, case when class=1 then 'high'
				when class=2 then 'average'
				else 'low'
				end revenue
			from (
				select facs.name as name, ntile(3) over (order by sum(case
						when memid = 0 then slots * facs.guestcost
						else slots * membercost
					end) desc) as class
				from cd.bookings bks
				inner join cd.facilities facs
					on bks.facid = facs.facid
				group by facs.name
			) as subq
		order by class, name;  

--CALCULE O TEMPO DE RETORNO PARA CADA INSTALAÇÃO--
21ª Questão : Com base nos 3 meses completos de dados até agora, calcule o tempo que cada instalação levará para pagar seu custo de propriedade. 
Lembre-se de levar em consideração a manutenção mensal contínua. Nome da instalação de saída e tempo de retorno em meses, ordem por nome da instalação. 
Não se preocupe com diferenças na duração dos meses, estamos apenas procurando um valor aproximado aqui!

	QUERY - select 	facs.name as name,
		    facs.initialoutlay/((sum(case
			     when memid = 0 then slots * facs.guestcost
			     else slots * membercost
			end)/3) - facs.monthlymaintenance) as months
		    from cd.bookings bks
		    inner join cd.facilities facs
			on bks.facid = facs.facid
		    group by facs.facid
		order by name;

--CALCULAR UMA MÉDIA MÓVEL DA RECEITA TOTAL--
22ª Questão : Para cada dia em agosto de 2012, calcule uma média móvel da receita total nos 15 dias anteriores. 
A saída deve conter colunas de data e receita, classificadas pela data. Lembre-se de levar em conta a possibilidade de um dia ter receita zero. 
Este é um pouco difícil, então não tenha medo de conferir a dica!

	QUERY - select 	dategen.date,
			(
		
				select sum(case
					when memid = 0 then slots * facs.guestcost
					else slots * membercost
				end) as rev

				from cd.bookings bks
				inner join cd.facilities facs
					on bks.facid = facs.facid
				where bks.starttime > dategen.date - interval '14 days'
					and bks.starttime < dategen.date + interval '1 day'
			)/15 as revenue
			from
			(
		
				select 	cast(generate_series(timestamp '2012-08-01',
					'2012-08-31','1 day') as date) as date
			)  as dategen
		order by dategen.date;









































































	
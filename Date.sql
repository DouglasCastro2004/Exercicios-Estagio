--PRODUZIR UM CARIMBO DE DATA/HORA PARA 1H DO DIA 31 DE AGOSTO DE 2012--
1ª Questão : Produza um carimbo de data/hora para 1h do dia 31 de agosto de 2012.

	QUERY - select timestamp '2012-08-31 01:00:00';

--SUBTRAIR TIMESTAMPS UNS DOS OUTROS--
2ª Questão : Encontre o resultado da subtração do timestamp '2012-07-30 01:00:00' do timestamp '2012-08-31 01:00:00'

	QUERY - select timestamp '2012-08-31 01:00:00' - timestamp '2012-07-30 01:00:00' as interval; 

--GERAR UMA LISTA DE TODAS AS DATAS EM OUTUBRO DE 2012--
3ª Questão : Produza uma lista de todas as datas em outubro de 2012. 
Elas podem ser geradas como um carimbo de data/hora (com a hora definida para meia-noite) ou uma data.

	QUERY - select generate_series(timestamp '2012-10-01', timestamp '2012-10-31', interval '1 day') as ts; 

--OBTER O DIA DO MÊS A PARTIR DE UM CARIMBO DE DATA/HORA--
4ª Questão : Obtenha o dia do mês do carimbo de data/hora '2012-08-31' como um número inteiro.

	QUERY - select extract(day from timestamp '2012-08-31');


--CALCULE O NÚMERO DE SEGUNDOS ENTRE OS TIMESTAMPS--
5ª Questão : Calcule o número de segundos entre os carimbos de data/hora '2012-08-31 01:00:00' e '2012-09-02 00:00:00'

	QUERY - select extract(epoch from (timestamp '2012-09-02 00:00:00' - '2012-08-31 01:00:00'));

--CALCULE O NÚMERO DE DIAS EM CADA MÊS DE 2012--
6ª Questão : Para cada mês do ano em 2012, imprima o número de dias desse mês. 
Formate a saída como uma coluna inteira contendo o mês do ano e uma segunda coluna contendo um tipo de dados de intervalo.

	QUERY - select 	extract(month from cal.month) as month,
			(cal.month + interval '1 month') - cal.month as length
			from
			(
				select generate_series(timestamp '2012-01-01', timestamp '2012-12-01', interval '1 month') as month
			) cal
		order by month;

--CALCULE O NÚMERO DE DIAS RESTANTES NO MÊS--
7ª Questão : Para qualquer carimbo de data/hora, calcule o número de dias restantes no mês. 
O dia atual deve contar como um dia inteiro, independentemente da hora. 
Use '2012-02-11 01:00:00' como um timestamp de exemplo para fins de resposta. Formate a saída como um valor de intervalo único.

	QUERY - select (date_trunc('month',ts.testts) + interval '1 month') 
			- date_trunc('day', ts.testts) as remaining
		   from (select timestamp '2012-02-11 01:00:00' as testts) ts;

--CALCULE O HORÁRIO DE TÉRMINO DAS RESERVAS--
8ª Questão : Retorna uma lista do horário de início e término das últimas 10 reservas (ordenadas pela hora em que terminam, seguidas pela hora em que começam) no sistema.

	QUERY - select starttime, starttime + slots*(interval '30 minutes') endtime
			from cd.bookings
		order by endtime desc, starttime desc
		limit 10;

--RETORNAR UMA CONTAGEM DE RESERVAS PARA CADA MÊS--
9ª Questão : Retornar uma contagem de reservas para cada mês, classificadas por mês.

	QUERY - select date_trunc('month', starttime) as month, count(*)
			from cd.bookings
			group by month
		order by month;

--CALCULE A PORCENTAGEM DE UTILIZAÇÃO PARA CADA INSTALAÇÃO POR MÊS--
10ª Questão : Calcule o percentual de utilização de cada instalação por mês, ordenado por nome e mês, arredondado para 1 casa decimal. 
O horário de abertura é às 8h, o horário de fechamento é às 20h30. 
Você pode tratar todos os meses como um mês inteiro, independentemente de haver algumas datas em que o clube não estava aberto.

	QUERY - select name, month, 
			round((100*slots)/
				cast(
					25*(cast((month + interval '1 month') as date)
					- cast (month as date)) as numeric),1) as utilisation
			from  (
				select facs.name as name, date_trunc('month', starttime) as month, sum(slots) as slots
					from cd.bookings bks
					inner join cd.facilities facs
						on bks.facid = facs.facid
					group by facs.facid, month
			) as inn
		order by name, month;






































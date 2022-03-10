--RECUPERAR TUDO DE UMA TABELA--
1ª Questão : Como você pode recuperar todas as informações da tabela cd.facilities?

	QUERY - select * from cd.facilities;
  
--RECUPERAR COLUNAS ESPECÍFICAS DE UMA TABELA--
2ª Questão : Você deseja imprimir uma lista de todas as instalações e seus custos para os membros. Como você recuperaria uma lista apenas de nomes e custos de instalações?

	QUERY - select name, membercost from cd.facilities;
	
--CONTROLAR QUAIS LINHAS SÃO RECUPERADAS
3ª Questão : Como você pode produzir uma lista de instalações que cobram uma taxa aos membros?

	QUERY - select * from cd.facilities where membercost > 0;
	
--CONTROLAR QUAIS LINHAS SÃO RECUPERADAS - PARTE 2--
4ª Questão : Como você pode produzir uma lista de instalações que cobram uma taxa aos membros e essa taxa seja inferior a 1/50 do custo mensal de manutenção? Devolva o facid, nome da instalação, custo do membro e manutenção mensal das instalações em questão.

	QUERY - select facid, name, membercost, monthlymaintenance 
			from cd.facilities 
			where membercost > 0
			and (membercost < monthlymaintenance/50);
		
--PESQUISAS BÁSICAS DE STRINGS--
5ª Questão : Como você pode produzir uma lista de todas as instalações com a palavra 'Tennis' em seu nome?

	QUERY - select * from cd.facilities 
			  where name like'%Tennis%';
			 
--CORRESPONDÃŠNCIA COM VÁRIOS VALORES POSSÍVEIS--
6ª Questão : Como você pode recuperar os detalhes das instalações com ID 1 e 5? Tente fazer isso sem usar o operador OR .

	QUERY - select * from cd.facilities 
			  where facid in (1,5);
			  
--CLASSIFIQUE OS RESULTADOS EM BUCKETS--
7ª Questão : Como você pode produzir uma lista de instalações, com cada uma rotulada como 'barata' ou 'cara' dependendo se o custo de manutenção mensal for superior a US$ 100? Devolva o nome e a manutenção mensal das instalações em questão.

	QUERY - select name, case when (monthlymaintenance > 100) then
					'expensive'
				else
					'cheap'
				end as cost
				from cd.facilities;  
				
--TRABALHANDO COM DATAS--
8ª Questão : Como você pode produzir uma lista de membros que ingressaram após o início de setembro de 2012? Retorne o memid, sobrenome, nome e data de ingresso dos membros em questão.

	QUERY - select memid, surname, firstname, joindate 
			from cd.members
			where joindate >= '2012-09-01';  
			
--REMOVENDO DUPLICATAS E ORDENANDO RESULTADOS--
9ª Questão : Como você pode produzir uma lista ordenada dos 10 primeiros sobrenomes na tabela de membros? A lista não deve conter duplicatas.

	QUERY - select distinct surname 
			from cd.members
			order by surname limit 10;
	
--COMBINANDO RESULTADOS DE VÁRIAS CONSULTAS--	
10ª Questão : Você, por algum motivo, quer uma lista combinada de todos os sobrenomes e todos os nomes das instalações. Sim, este é um exemplo artificial :-). Produza essa lista!

	QUERY - select surname from cd.members
			union
		select name from cd.facilities;
		
--AGREGAÇÃO SIMPLES--
11ª Questão : Você gostaria de obter a data de inscrição do seu último membro. Como você pode recuperar essas informações?

	QUERY - select max(joindate) as latest
			from cd.members;
			
--MAIS AGREGAÇÃO--
12ª Questão : Você gostaria de obter o nome e sobrenome do(s) último(s) membro(s) que se inscreveu - nãoapenas a data. Como você pode fazer isso?

	QUERY - select firstname, surname, joindate from cd.members
			where joindate = (select max(joindate)
			from cd.members);
		

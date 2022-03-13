--ENCONTRE A CADEIA DE RECOMENDAÇÃO ASCENDENTE PARA O ID DE MEMBRO 27--
1ª Questão : Encontre a cadeia de recomendação ascendente para o membro ID 27: ou seja, 
o membro que os recomendou e o membro que recomendou esse membro e assim por diante. 
Retornar ID de membro, nome e sobrenome. Ordem por ID de membro descendente.

	QUERY - with recursive recommenders(recommender) as (
			select recommendedby from cd.members where memid = 27
			union all
			select mems.recommendedby
				from recommenders recs
				inner join cd.members mems
					on mems.memid = recs.recommender
		)
			select recs.recommender, mems.firstname, mems.surname
				from recommenders recs
				inner join cd.members mems
					on recs.recommender = mems.memid
		order by memid desc;   

--ENCONTRE A CADEIA DE RECOMENDAÇÕES DESCENDENTE PARA O ID DE MEMBRO 1--
2ª Questão : Encontre a cadeia de recomendações descendente para o ID de membro 1: ou seja, 
os membros que eles recomendaram, os membros que esses membros recomendaram e assim por diante. 
Retorne o ID e o nome do membro e ordene por ID de membro crescente.

	QUERY - with recursive recommendeds(memid) as (
			select memid from cd.members where recommendedby = 1
			union all
			select mems.memid
				from recommendeds recs
				inner join cd.members mems
					on mems.recommendedby = recs.memid
		)
		select recs.memid, mems.firstname, mems.surname
				from recommendeds recs
				inner join cd.members mems
					on recs.memid = mems.memid
		order by memid;

--PRODUZIR UM CTE QUE POSSA RETORNAR A CADEIA DE RECOMENDAÇÃO ASCENDENTE PARA QUALQUER MEMBRO--
3ª Questão : Produza um CTE que possa retornar a cadeia de recomendação ascendente para qualquer membro. 
Você deve ser capaz de selecionar recomendador de recomendadores onde member=x . Demonstre-o obtendo as cadeias para os membros 12 e 22. 
A tabela de resultados deve ter membro e recomendador, ordenados por membro ascendente, recomendador descendente.

	QUERY - with recursive recommenders(recommender, member) as (
			select recommendedby, memid
				from cd.members
			union all
			select mems.recommendedby, recs.member
				from recommenders recs
				inner join cd.members mems
					on mems.memid = recs.recommender
		)
		select recs.member member, recs.recommender, mems.firstname, mems.surname
				from recommenders recs
				inner join cd.members mems		
					on recs.recommender = mems.memid
			where recs.member = 22 or recs.member = 12
		order by recs.member asc, recs.recommender desc;
























      
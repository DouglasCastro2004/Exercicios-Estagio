--RECUPERE OS HORÁRIOS DE INÍCIO DAS RESERVAS DOS MEMBROS--
1ª Questão : Como você pode produzir uma lista dos horários de início para reservas por membros chamados 'David Farrell'?

	QUERY - select bks.starttime
			from 
				cd.bookings bks
				inner join cd.members mems
					on mems.memid = bks.memid
			where 
				mems.firstname='David' 
				and mems.surname='Farrell'; 

--CALCULE OS HORÁRIOS DE INÍCIO DAS RESERVAS PARA QUADRAS DE TÊNIS--
2ª Questão : Como você pode produzir uma lista dos horários de início para reservas de quadras de tênis, para a data '2012-09-21'? 
Retorna uma lista de pares de nome de instalação e hora de início, ordenados por hora.

	QUERY - select bks.starttime as start, facs.name as name
		from 
			cd.facilities facs
			inner join cd.bookings bks
				on facs.facid = bks.facid
		where 
			facs.name in ('Tennis Court 2','Tennis Court 1') and
			bks.starttime >= '2012-09-21' and
			bks.starttime < '2012-09-22'
		order by bks.starttime;

--PRODUZIR UMA LISTA DE TODOS OS MEMBROS QUE RECOMENDARAM OUTRO MEMBRO--
3ª Questão : Como você pode gerar uma lista de todos os membros que recomendaram outro membro?
Certifique-se de que não haja duplicatas na lista e que os resultados sejam ordenados por (sobrenome, nome).

	QUERY - select distinct recs.firstname as firstname, recs.surname as surname
			from 
				cd.members mems
				inner join cd.members recs
				   on recs.memid = mems.recommendedby
			order by surname, firstname; 

--PRODUZA UMA LISTA DE TODOS OS MEMBROS, JUNTAMENTE COM SEU RECOMENDADOR--
4ª Questão : Como você pode gerar uma lista de todos os membros, incluindo a pessoa que os recomendou (se houver)? 
Certifique-se de que os resultados sejam ordenados por (sobrenome, nome).


	QUERY - select mems.firstname as memfname, mems.surname as memsname, recs.firstname as recfname, recs.surname as recsname
				from 
					cd.members mems
					left outer join cd.members recs
						on recs.memid = mems.recommendedby
		order by memsname, memfname;

--PRODUZIR UMA LISTA DE TODOS OS MEMBROS QUE USARAM UMA QUADRA DE TÊNIS--
5ª Questão : Como você pode produzir uma lista de todos os membros que usaram uma quadra de tênis? 
Inclua em sua saída o nome do tribunal e o nome do membro formatado como uma única coluna. 
Certifique-se de que não há dados duplicados e ordene pelo nome do membro seguido pelo nome da instalação.

	QUERY - select distinct mems.firstname ||' '|| mems.surname as member, facs.name as facility
			from 
				cd.members mems
				inner join cd.bookings bks
					on mems.memid = bks.memid
				inner join cd.facilities facs
					on bks.facid = facs.facid
			where	
				facs.name in ('Tennis Court 2','Tennis Court 1')
		order by member, facility;

--PRODUZA UMA LISTA DE RESERVAS CARAS--
6ª Questão : Como você pode produzir uma lista de reservas no dia de 2012-09-14 que custarão ao membro (ou convidado) mais de $30? 
Lembre-se de que os convidados têm custos diferentes para os membros (os custos listados são por 'slot' de meia hora), e o usuário convidado é sempre ID 0. 
Inclua em sua saída o nome da instalação, o nome do membro formatado como um único coluna e o custo. Ordene por custo decrescente e não use subconsultas.

	QUERY - select mems.firstname ||' '|| mems.surname as member, 
			facs.name as facility, 
			case 
				when mems.memid = 0 then
					bks.slots*facs.guestcost
				else
					bks.slots*facs.membercost
			end as cost
				from
               					 cd.members mems                
               					 inner join cd.bookings bks
                      					  on mems.memid = bks.memid
              	  				 inner join cd.facilities facs
                        				  on bks.facid = facs.facid
     		  	 	where
					bks.starttime >= '2012-09-14' and 
					bks.starttime < '2012-09-15' and (
						(mems.memid = 0 and bks.slots*facs.guestcost > 30) or
					(mems.memid != 0 and bks.slots*facs.membercost > 30)
			)
		order by cost desc;  

--PRODUZA UMA LISTA DE TODOS OS MEMBROS, JUNTAMENTE COM SEU RECOMENDADOR, SEM USAR JUNÇÕES--
7ª Questão : Como você pode gerar uma lista de todos os membros, incluindo o indivíduo que os recomendou (se houver), sem usar nenhuma associação? 
Certifique-se de que não haja duplicatas na lista e que cada par de nome + sobrenome esteja formatado como uma coluna e ordenado.

	QUERY - select distinct mems.firstname ||' '||  mems.surname as member,
			(select recs.firstname ||' '|| recs.surname as recommender 
				from cd.members recs 
				where recs.memid = mems.recommendedby
			)
			from 
				cd.members mems
		order by member;

--PRODUZA UMA LISTA DE RESERVAS CARAS, USANDO SUBCONSULTA--
8ª Questão - O exercício Produzir uma lista de reservas caras continha alguma lógica confusa: tivemos que calcular o custo da reserva tanto na cláusula WHERE quanto na instrução CASE . 
Tente simplificar esse cálculo usando subconsultas. Para referência, a pergunta foi:
Como você pode produzir uma lista de reservas no dia de 2012-09-14 que custarão ao membro (ou convidado) mais de $30? 
Lembre-se de que os convidados têm custos diferentes para os membros (os custos listados são por 'slot' de meia hora), e o usuário convidado é sempre ID 0. 
Inclua em sua saída o nome da instalação, o nome do membro formatado como um único coluna e o custo. Ordem por custo decrescente.

	QUERY - select member, facility, cost from (
			select 
				mems.firstname ||' '|| mems.surname as member,
				facs.name as facility,
				case
					when mems.memid = 0 then
						bks.slots*facs.guestcost
					else
						bks.slots*facs.membercost
				end as cost
				from
					cd.members mems
					inner join cd.bookings bks
						on mems.memid = bks.memid
					inner join cd.facilities facs
						on bks.facid = facs.facid
				where
					bks.starttime >= '2012-09-14' and
					bks.starttime < '2012-09-15'
			) as bookings
			where cost > 30
		order by cost desc;































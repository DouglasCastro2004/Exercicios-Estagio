--INSERIR ALGUNS DADOS EM UMA TABELA--
1ª Questão : O clube está adicionando uma nova instalação - um spa. 
Precisamos adicioná-lo à tabela de instalações. Use os seguintes valores:

*Facid: 9, Nome: 'Spa', custo do membro: 20, custo do hóspede: 30, desembolso inicial: 100.000, manutenção mensal: 800.

	QUERY - insert into cd.facilities
    			(facid, name, membercost, guestcost, initialoutlay, 
			 monthlymaintenance)
    			values (9, 'Spa', 20, 30, 100000, 800);

--INSERIR VÁRIAS LINHAS DE DADOS EM UMA TABELA--
2ª Questão : No exercício anterior, você aprendeu como adicionar um recurso. 
Agora você adicionará vários recursos em um comando. Use os seguintes valores:

*Facid: 9, Nome: 'Spa', custo do membro: 20, custo do hóspede: 30, desembolso inicial: 100.000, manutenção mensal: 800.
*Facid: 10, Nome: 'Squash Court 2', custo do membro: 3,5, custo do hóspede: 17,5, desembolso inicial: 5000, manutenção mensal: 80.

	QUERY - insert into cd.facilities
    			(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    			values (9, 'Spa', 20, 30, 100000, 800),
        		(10, 'Squash Court 2', 3.5, 17.5, 5000, 80);

--INSERIR DADOS CALCULADOS EM UMA TABELA--
3ª Questão : Vamos tentar adicionar o spa à tabela de instalações novamente. 
Desta vez, porém, queremos gerar automaticamente o valor para o próximo facid, em vez de especificá-lo como uma constante. 
Use os seguintes valores para todo o resto:

*Nome: 'Spa', custo do membro: 20, custo do hóspede: 30, gasto inicial: 100.000, manutenção mensal: 800.

	QUERY - insert into cd.facilities
    			(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
    		select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800; 

--ATUALIZAR ALGUNS DADOS EXISTENTES--
4ª Questão : Cometemos um erro ao inserir os dados da segunda quadra de tênis. 
O desembolso inicial foi de 10.000 em vez de 8.000: você precisa alterar os dados para corrigir o erro.

	QUERY - update cd.facilities
    			set initialoutlay = 10000
    			where facid = 1;

--ATUALIZAR VÁRIAS LINHAS E COLUNAS AO MESMO TEMPO--
5ª Questão : Queremos aumentar o preço das quadras de tênis para sócios e convidados. 
Atualize os custos para 6 para membros e 30 para convidados.

	QUERY - update cd.facilities
    			set
        			membercost = 6,
        			guestcost = 30
   			where facid in (0,1); 

--ATUALIZAR UMA LINHA COM BASE NO CONTEÚDO DE OUTRA LINHA--
6ª Questão : Queremos alterar o preço da segunda quadra de tênis para que custe 10% a mais que a primeira. 
Tente fazer isso sem usar valores constantes para os preços, para que possamos reutilizar a declaração se quisermos.

	QUERY - update cd.facilities facs
    			set
        			membercost = (select membercost * 1.1 from cd.facilities where facid = 0),
       	 			guestcost = (select guestcost * 1.1 from cd.facilities where facid = 0)
    			where facs.facid = 1;

--EXCLUIR TODAS AS RESERVAS--
7ª Questão : Como parte de uma limpeza de nosso banco de dados, queremos excluir todas as reservas da tabela cd.bookings. 
Como podemos realizar isso?

	QUERY - delete from cd.bookings;

--EXCLUIR UM MEMBRO DA TABELA cd.members--
8ª Questão : Queremos remover o membro 37, que nunca fez uma reserva, do nosso banco de dados. Como podemos conseguir isso?

	QUERY - delete from cd.members where memid = 37;

--EXCLUIR COM BASE EM EM UMA SUBCONSULTA--
9ª Questão : Em nossos exercícios anteriores, excluímos um membro específico que nunca havia feito uma reserva. 
Como podemos tornar isso mais geral, para excluir todos os membros que nunca fizeram uma reserva?

	QUERY - delete from cd.members 
			where memid not in (select memid from cd.bookings);




































































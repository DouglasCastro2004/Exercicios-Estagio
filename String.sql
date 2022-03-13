--FORMATAR O NOME DOS MEMBROS--
1ª Questão : Saída dos nomes de todos os membros, formatados como 'Sobrenome, Nome'

	QUERY - select surname ||', '|| firstname as name from cd.members;

--ENCONTRAR INSTALAÇÕES POR UM PREFIXO DE NOME--
2ª Questão : Encontre todas as instalações cujo nome comece com 'Tennis'. Recupere todas as colunas.

	QUERY - select * from cd.facilities where name like 'Tennis%'; 

--FAÇA UMA PESQUISA QUE NÃO DIFERENCIA MAIÚSCULAS E MINÚSCULAS--
3ª Questão : Faça uma pesquisa que não diferencia maiúsculas de minúsculas para encontrar todas as instalações cujo nome comece com 'tênis'. 
Recupere todas as colunas.

	QUERY - select * from cd.facilities where upper(name) like 'TENNIS%';  

--ENCONTRAR NÚMEROS DE TELEFONE COM PARÊNTESES--
4ª Questão : Você notou que a tabela de sócios do clube tem números de telefone com formatação muito inconsistente. 
Você gostaria de encontrar todos os números de telefone que contêm parênteses, retornando o ID do membro e o número de telefone classificado por ID do membro.

	QUERY - select memid, telephone from cd.members where telephone ~ '[()]';

--PREENCHER CÓDIGOS POSTAIS COM ZEROS À ESQUERDA--
5ª Questão : Os códigos postais em nosso conjunto de dados de exemplo tiveram zeros à esquerda removidos deles em virtude de serem armazenados como um tipo numérico. 
Recupere todos os CEPs da tabela de membros, preenchendo quaisquer CEPs com menos de 5 caracteres com zeros à esquerda. Faça o pedido pelo novo CEP.

	QUERY - select lpad(cast(zipcode as char(5)),5,'0') zip from cd.members order by zip;

--CONTE O NÚMERO DE MEMBROS CUJO SOBRENOME COMEÇA COM CADA LETRA DO ALFABETO--   
6ª Questão : Você gostaria de produzir uma contagem de quantos membros você tem cujo sobrenome começa com cada letra do alfabeto. 
Classifique por letra e não se preocupe em imprimir uma letra se a contagem for 0.

	QUERY - select substr (mems.surname,1,1) as letter, count(*) as count 
    			from cd.members mems
    			group by letter
    		order by letter;

--LIMPAR NÚMEROS DE TELEFONE--
7ª Questão : Os números de telefone no banco de dados são formatados de forma muito inconsistente. 
Você gostaria de imprimir uma lista de IDs de membros e números que tiveram os caracteres '-','(',')' e ' ' removidos. Ordem por ID de membro.

	QUERY - select memid, translate(telephone, '-() ', '') as telephone
    			from cd.members
    		order by memid;


























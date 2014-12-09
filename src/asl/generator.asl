//1. База убеждений
maxDelay(0). // максимальная величина паузы между 
                  //порождением  2х клиентов.
maxAgentCounter(10). // максимальное количество 
                             //порождаемых клиентов.
agentCounter(0). // счетчик созданных клиентов.
completeCounter(0). // счетчик клиентов, завершивших свою 
                                  //работу.
!start. // начальная цель, инициализирующая работу генератора, и вообще, всего

// 2. Планы по достижению целей
@g1[atomic]
+!start: agentCounter(AC) & maxAgentCounter(MAC) &      
AC<MAC <-
	-+agentCounter(AC+1);
	?maxDelay(MD);
	?agentCounter(C);
	.wait(math.round(math.random(MD)));
	.concat("unemployed",C, Name);  
	.create_agent(Name, "unemployed.asl"); 
	LL=math.round(math.random(3))+1; // уровень теории [1..4]
	PL=math.round(math.random(3))+1; // уровень практики [1..4]
	
	LD=math.round(math.random(1)); // желание читать [0..1]
	PD=math.round(math.random(1)); // желание программировать [0..1]
	
	.send(Name, tell, skills(LL, PL));
	.send(Name, tell, desires(LD, PD));
	!!start.
/*
Если еще не создано заданное количество клиентов, то данный план рекурсивно
порождает клиентов и определяет им параметр «желаемое количество порций»
(orderValue), выдерживая случайную паузу. Строка 15 определяет условия активации
плана. План настроен на перехват события возникновения цели !start, после чего
проверяются контекстные ограничения. В них сначала происходит конкретизация переменных
АС и МАС посредством считывания из базы убеждений указанных предикатов, потом их
сравнение. В строке 16 увеличивается счетчик созданных клиентов. В строках 17 и 18
происходит считывание из базы убеждений значений максимально возможной паузы и
текущего значения счетчика клиентов. В строке 19 выдерживается случайная пауза,
величина которой вычисляется через обращение к функциям генерации случайных чисел
и округления, определенных в модуле math. В строке 20 из отдельных фрагментов
путем конкатенации собирается имя для порождаемого клиента. Это имя помещается
в переменную Name. В строке 21 происходит непосредственное создание нового клиента
с заданным именем, который работает по заданной программе, хранящейся в указанном
файле. В строке 8 происходит вычисление очередной случайной величины, которая
далее рассматривается как объем заказа клиента. В строке 23 генератор сообщает
только что созданному клиенту убеждение, в котором указан объем заказа. Строка
24 рекурсивно вызывает этот же самый план, причем в базе намерений создается для
него новый стек (т.к. используется оператор «!!»).
 */
	
@g2[atomic]
	+!start <-	.send(boss,achieve,firmExpanded);
				.all_names(L);
				for ( .member(X,L) ) {
			        // .print(X);    // print all members of the list
			        if (.substring("unemployed", X)) { 
			        	.send(X,achieve,startAllowed);
			     	}
			     }
				
				.
/*
Стартуем необходимую логику, а именно -- босс должен достигнуть firmExpanded
а безработные -- startAllowed
 */


@g3[atomic]
+!finishMe[source(Agent)] <- 
	?completeCounter(C);
	-+completeCounter(C+1);
	.kill_agent(Agent).

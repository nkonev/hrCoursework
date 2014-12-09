// Agent unemployed in project jasonHelloWorls

/* Initial beliefs and rules */
expectedSkills(2, 2).
// Ожидаемые уровень теории и уровень практики

/* Initial goals */


/* Plans */
@g1[atomic]
+!prepareTasks(N) <-
	.print("Now i'll prepare tasks and questions for ", N);
	?makeQuestions;
	?findTasks;
	?ready(N);
	.

@g3[atomic]
+?makeQuestions <- true.

@g4[atomic]
+?findTasks <- true.

@g6[atomic]
+?ready(N) <- !meetUnemployed(N).

@g7[atomic]
+!meetUnemployed(N) <-
	.send(N, askOne, interviewTime(H,M,S), interviewTime(H,M,S));
	.print(H,":",M,":",S," ", "Hello, ",N, ", please tell me your scills");
	.send(N, askOne, skills(LL, PL), skills(LL, PL));
	.print(N,", your skills: learning ",LL,", practice ",PL, ".");
	
	?checkSkills(LL,PL, N);
	.

/* Сравнивает навыка агента unemployedn с требуемыми.
 * В случае когда навыки unemployedn не менее ожидаемых
 * нанимаем агента.
 */
@g8[atomic]
+?checkSkills(ACTUALLL, ACTUALPL, N) : expectedSkills(EXLL, EXPL) &      
	ACTUALLL>=EXLL & ACTUALPL>= EXPL <-
		.print("You hired!");
		.send(N, achieve, hired);
	.
	
/* Случай, когда навыков unemployedn недостаточно
 * отказываем ему.
 */
@g9[atomic]
+?checkSkills(ACTUALLL, ACTUALPL, N) <- 
	.print(N,", sorry, we phone you.");
	.send(N, achieve, rejected);
.
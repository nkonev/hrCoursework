started.	
/* Здесь «started.» - начальное убеждение.
При запуске программы по всем начальным убеждениям и целям
генерируются события добавления, приводящие к активации планов.
*/
+started <- .print("Hello World!").
/* «+started» - отслеживаемое нашим единственным планом событие.
Контекстные ограничения в данном примере отсутствуют.
Тело плана состоит из одной строки – это «.print("Hello World!")» -
вызов внутренней функции среды Jason, предназначенной для печати текстовых
сообщений в специальном окне.
*/
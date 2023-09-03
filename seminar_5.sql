
-- 1. Создайте представление, в которое попадет информация о пользователях 
-- (имя, фамилия, город и пол), которые не старше 20 лет.

CREATE OR REPLACE VIEW table1 AS
SELECT CONCAT (u.firstname, "  ", u.lastname) AS 'ФИО', p.hometown ,p.gender, p.birthday
FROM users u 
LEFT JOIN profiles p ON u.id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, birthday, DATE_FORMAT(NOW(), '%Y-%m-%d')) < 20;
-- WHERE p.birthday > '2003-01-01';

SELECT * FROM table1;


-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге (первое место у пользователя 
-- с максимальным количеством сообщений) . (используйте DENSE_RANK)

SELECT CONCAT(u.firstname, "  ", u.lastname) AS "ФИО", COUNT(m.from_user_id) "Количество сообщений",
DENSE_RANK()
OVER(ORDER BY COUNT(m.from_user_id) DESC) AS "DENSE_RANK"
FROM users u
JOIN messages m ON u.id = from_user_id
GROUP BY u.id;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created _at) 
-- и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)

SELECT CONCAT(u.firstname, "  ", u.lastname) AS"ФИО", m.*,
-- TIMESTAMPDIFF (SECOND, m.created_at, LAG(m.created_at) OVER(ORDER BY m.created_at)) AS "LAG_DIFF SEC", 
-- получается отрицательное значение
TIMESTAMPDIFF (SECOND, m.created_at, LEAD(m.created_at) OVER(ORDER BY m.created_at)) AS "LEAD_DIFF SEC"
FROM users u 
LEFT JOIN messages m ON u.id = from_user_id
ORDER BY m.created_at;


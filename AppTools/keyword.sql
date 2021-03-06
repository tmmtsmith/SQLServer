/*

Keyword parsing tool

*/
DECLARE @string TABLE(
  String VARCHAR(MAX)
)

INSERT INTO @string
VALUES ('The quick brown fox jumped over the lazy dogs.  Each dog heard this often written idiom and contacted Ruff, their attorney.  They filed a lawsuit against all the writers and developers using this often quoted idiom.  Unfortunately, Ruff did not win this case, as the judge thought that the idiom was just that - an idiom.  He frowned upon the actions of the dogs.')

DECLARE @keyword TABLE(
	ID SMALLINT IDENTITY(1,1),
	Keyword VARCHAR(250),
	Link VARCHAR(250)
)

INSERT INTO @keyword (Keyword,Link)
VALUES ('idiom','<a href="http://www.idiom.com/">idiom</a>')
	, ('dogs','<a href="http://lmgtfy.com/?q=dogs">dogs</a>')

DECLARE @begin SMALLINT = 1, @max SMALLINT, @key VARCHAR(250), @link VARCHAR(250), @limit INT, @limitextra INT
SELECT @max = MAX(ID) FROM @keyword
-- FOr linmit, set it
SET @limit = 150

WHILE @begin <= @max
BEGIN

	SELECT @key = Keyword FROM @keyword WHERE ID = @begin
	SELECT @link = Link FROM @keyword WHERE ID = @begin
	SET @limitextra = @limit + 1

	-- Limited string update
	UPDATE @string
	SET String = REPLACE(SUBSTRING(String,1,@limit),@key,@link) + SUBSTRING(String,@limitextra,8000)
	FROM @string

	-- Unlimited string update
	--UPDATE @string
	--SET String = REPLACE(String,@key,@link)
	--FROM @string

	SET @begin = @begin + 1
	SET @key = NULL
	SET @link = NULL

END

SELECT *
FROM @string

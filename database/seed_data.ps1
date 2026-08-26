$connectionString = "Server=(localdb)\MSSQLLocalDB;Database=HomeLibrary;Trusted_Connection=True;TrustServerCertificate=True;"

$books = @(
    @{
        Title = "C# для начинающих"
        Author = "Троелсен Э."
        Year = 2020
        Pages = 832
        Genre = "Программирование"
        ISBN = "978-5-699-78234-5"
        Description = "Полное руководство по языку C# от создателя серии книг Head First. Подробно рассматриваются основы языка, объектно-ориентированное программирование, работа с данными и многое другое."
        Xml = @"
<TableOfContents>
  <Chapter number="1" title="Введение в C#" pages="15"/>
  <Chapter number="2" title="Типы данных и переменные" pages="30">
    <Section title="Примитивные типы" pages="12"/>
    <Section title="Ссылочные типы" pages="18"/>
  </Chapter>
  <Chapter number="3" title="Операторы управления" pages="25"/>
  <Chapter number="4" title="Массивы и коллекции" pages="35"/>
  <Chapter number="5" title="Объектно-ориентированное программирование" pages="50">
    <Section title="Классы и объекты" pages="20"/>
    <Section title="Наследование" pages="15"/>
    <Section title="Полиморфизм" pages="15"/>
  </Chapter>
</TableOfContents>
"@
    },
    @{
        Title = "Искусство программирования на Python"
        Author = "Мэтт В."
        Year = 2019
        Pages = 640
        Genre = "Программирование"
        ISBN = "978-5-699-91234-1"
        Description = "Учебник по основам программирования на Python. Подходит для новичков и людей с базовыми знаниями в программировании."
        Xml = @"
<TableOfContents>
  <Chapter number="1" title="Знакомство с Python" pages="20"/>
  <Chapter number="2" title="Переменные и типы данных" pages="25"/>
  <Chapter number="3" title="Управляющие конструкции" pages="30"/>
  <Chapter number="4" title="Функции и модули" pages="40"/>
  <Chapter number="5" title="Работа с файлами" pages="20"/>
</TableOfContents>
"@
    },
    @{
        Title = "СУБД: теория и практика"
        Author = "Коннолли Т., Бегг К."
        Year = 2021
        Pages = 1376
        Genre = "Базы данных"
        ISBN = "978-5-699-61234-8"
        Description = "Классическое учебное пособие по системам управления базами данных. Охватывает теорию реляционных моделей, SQL, нормализацию, транзакции и современные подходы к проектированию БД."
        Xml = @"
<TableOfContents>
  <Chapter number="1" title="Основы реляционных БД" pages="18"/>
  <Chapter number="2" title="Язык SQL" pages="55">
    <Section title="DML-запросы" pages="25"/>
    <Section title="DDL-запросы" pages="15"/>
    <Section title="DCL-запросы" pages="15"/>
  </Chapter>
  <Chapter number="3" title="Нормализация" pages="22"/>
  <Chapter number="4" title="Индексы и производительность" pages="30"/>
  <Chapter number="5" title="Хранимые процедуры и триггеры" pages="35"/>
</TableOfContents>
"@
    },
    @{
        Title = "Банд о паттернах проектирования"
        Author = "Гамма Э., Хелм Р., Джонсон Р., Влиссидес Дж."
        Year = 2022
        Pages = 464
        Genre = "Архитектура"
        ISBN = "978-5-699-51234-2"
        Description = "Книга о 23 классических паттернах проектирования, описанных бандой четырёх. Обязательное чтение для каждого серьёзного программиста."
        Xml = @"
<TableOfContents>
  <Chapter number="1" title="Что такое паттерны проектирования" pages="12"/>
  <Chapter number="2" title="Порождающие паттерны" pages="40">
    <Section title="Singleton" pages="8"/>
    <Section title="Factory Method" pages="10"/>
    <Section title="Abstract Factory" pages="10"/>
    <Section title="Builder" pages="12"/>
  </Chapter>
  <Chapter number="3" title="Структурные паттерны" pages="35">
    <Section title="Adapter" pages="8"/>
    <Section title="Decorator" pages="10"/>
    <Section title="Facade" pages="7"/>
    <Section title="Proxy" pages="10"/>
  </Chapter>
  <Chapter number="4" title="Поведенческие паттерны" pages="45">
    <Section title="Observer" pages="10"/>
    <Section title="Strategy" pages="10"/>
    <Section title="Command" pages="12"/>
    <Section title="State" pages="13"/>
  </Chapter>
</TableOfContents>
"@
    },
    @{
        Title = "Кларк М. Алгоритмы и структуры данных"
        Author = "Кларк М."
        Year = 2018
        Pages = 528
        Genre = "Компьютерные науки"
        ISBN = "978-5-699-41234-7"
        Description = "Подробное описание основных алгоритмов и структур данных с примерами на C++. Рекомендуется студентам и разработчикам."
        Xml = @"
<TableOfContents>
  <Chapter number="1" title="Введение в алгоритмы" pages="15"/>
  <Chapter number="2" title="Сложность алгоритмов" pages="20"/>
  <Chapter number="3" title="Сортировки" pages="45">
    <Section title="Пузырьковая сортировка" pages="8"/>
    <Section title="Быстрая сортировка" pages="12"/>
    <Section title="Сортировка слиянием" pages="12"/>
    <Section title="Сортировка вставками" pages="8"/>
    <Section title="Сортировка выбором" pages="5"/>
  </Chapter>
  <Chapter number="4" title="Поиск" pages="30">
    <Section title="Линейный поиск" pages="5"/>
    <Section title="Бинарный поиск" pages="10"/>
    <Section title="Поиск в дереве" pages="15"/>
  </Chapter>
  <Chapter number="5" title="Графовые алгоритмы" pages="40"/>
</TableOfContents>
"@
    },
    @{
        Title = "Чистый код"
        Author = "Роберт Мартин"
        Year = 2021
        Pages = 464
        Genre = "Программирование"
        ISBN = "978-5-699-82234-3"
        Description = "Руководство по написанию чистого и поддерживаемого кода. Советы и примеры от опытного разработчика."
        Xml = $null
    },
    @{
        Title = "Дизайн данных"
        Author = "Кляйнханс М."
        Year = 2020
        Pages = 320
        Genre = "Базы данных"
        ISBN = "978-5-699-72234-9"
        Description = "Практическое руководство по проектированию баз данных для современных приложений."
        Xml = $null
    }
)

Add-Type -AssemblyName System.Data

$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$connection.Open()

foreach ($book in $books) {
    $command = $connection.CreateCommand()
    $command.CommandText = "sp_InsertBook"
    $command.CommandType = [System.Data.CommandType]::StoredProcedure

    $command.Parameters.AddWithValue("@Title", $book.Title)
    $command.Parameters.AddWithValue("@Author", $book.Author)
    $command.Parameters.AddWithValue("@Description", $book.Description)

    foreach ($param in @("Year", "Pages", "Genre", "ISBN")) {
        $val = $book[$param]
        if ($null -ne $val -and "" -ne $val) {
            $command.Parameters.AddWithValue("@$param", $val)
        } else {
            $command.Parameters.AddWithValue("@$param", [System.DBNull]::Value)
        }
    }

    if ($book.Xml) {
        $xmlParam = $command.Parameters.AddWithValue("@TableOfContents", $book.Xml)
        $xmlParam.SqlDbType = [System.Data.SqlDbType]::Xml
    } else {
        $command.Parameters.AddWithValue("@TableOfContents", [System.DBNull]::Value)
    }

    $outputParam = $command.Parameters.Add("@NewId", [System.Data.SqlDbType]::Int)
    $outputParam.Direction = [System.Data.ParameterDirection]::Output

    $command.ExecuteNonQuery()
    Write-Host "Inserted: $($book.Title) -> ID $($outputParam.Value)"
}

$connection.Close()
Write-Host "Done! 7 books inserted with proper Unicode encoding."

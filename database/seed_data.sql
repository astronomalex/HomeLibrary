USE [HomeLibrary];
GO

SET NOCOUNT ON;

-- Clear existing data
DELETE FROM [dbo].[Books];
DBCC CHECKIDENT ('[dbo].[Books]', RESEED, 0);
GO

DECLARE @Xml1 XML = N'
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
</TableOfContents>';

DECLARE @Xml2 XML = N'
<TableOfContents>
  <Chapter number="1" title="Знакомство с Python" pages="20"/>
  <Chapter number="2" title="Переменные и типы данных" pages="25"/>
  <Chapter number="3" title="Управляющие конструкции" pages="30"/>
  <Chapter number="4" title="Функции и модули" pages="40"/>
  <Chapter number="5" title="Работа с файлами" pages="20"/>
</TableOfContents>';

DECLARE @Xml3 XML = N'
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
</TableOfContents>';

DECLARE @Xml4 XML = N'
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
</TableOfContents>';

DECLARE @Xml5 XML = N'
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
</TableOfContents>';

INSERT INTO [dbo].[Books] ([Title], [Author], [Year], [Pages], [Genre], [ISBN], [Description], [TableOfContents])
VALUES
(N'C# для начинающих', N'Троелсен Э.', 2020, 832, N'Программирование', N'978-5-699-78234-5',
 N'Полное руководство по языку C# от создателя серии книг Head First. Подробно рассматриваются основы языка, объектно-ориентированное программирование, работа с данными и многое другое.',
 @Xml1),

(N'Искусство программирования на Python', N'Мэтт В.', 2019, 640, N'Программирование', N'978-5-699-91234-1',
 N'Учебник по основам программирования на Python. Подходит для новичков и людей с базовыми знаниями в программировании.',
 @Xml2),

(N'СУБД: теория и практика', N'Коннолли Т., Бегг К.', 2021, 1376, N'Базы данных', N'978-5-699-61234-8',
 N'Классическое учебное пособие по системам управления базами данных. Охватывает теорию реляционных моделей, SQL, нормализацию, транзакции и современные подходы к проектированию БД.',
 @Xml3),

(N'Банд о паттернах проектирования', N'Гамма Э., Хелм Р., Джонсон Р., Влиссидес Дж.', 2022, 464, N'Архитектура', N'978-5-699-51234-2',
 N'Книга о 23 классических паттернах проектирования, описанных бандой четырёх. Обязательное чтение для каждого серьёзного программиста.',
 @Xml4),

(N'Кларк М. Алгоритмы и структуры данных', N'Кларк М.', 2018, 528, N'Компьютерные науки', N'978-5-699-41234-7',
 N'Подробное описание основных алгоритмов и структур данных с примерами на C++. Рекомендуется студентам и разработчикам.',
 @Xml5),

(N'Чистый код', N'Роберт Мартин', 2021, 464, N'Программирование', N'978-5-699-82234-3',
 N'Руководство по написанию чистого и поддерживаемого кода. Советы и примеры от опытного разработчика.',
 NULL),

(N'Дизайн данных', N'Кляйнханс М.', 2020, 320, N'Базы данных', N'978-5-699-72234-9',
 N'Практическое руководство по проектированию баз данных для современных приложений.',
 NULL);

PRINT 'Seed data inserted: 7 books.';
GO

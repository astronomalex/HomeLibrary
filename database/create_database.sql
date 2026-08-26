USE [master];
GO

IF DB_ID(N'HomeLibrary') IS NOT NULL
BEGIN
    ALTER DATABASE [HomeLibrary] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [HomeLibrary];
END
GO

CREATE DATABASE [HomeLibrary];
GO

USE [HomeLibrary];
GO

CREATE TABLE [dbo].[Books]
(
    [Id]               INT IDENTITY(1,1) NOT NULL,
    [Title]            NVARCHAR(255)     NOT NULL,
    [Author]           NVARCHAR(255)     NOT NULL,
    [Year]             INT               NULL,
    [Pages]            INT               NULL,
    [Genre]            NVARCHAR(100)     NULL,
    [ISBN]             NVARCHAR(50)      NULL,
    [Description]      NVARCHAR(MAX)     NULL,
    [TableOfContents]  XML               NULL,
    [CreatedAt]        DATETIME2         NOT NULL DEFAULT(GETUTCDATE()),
    [UpdatedAt]        DATETIME2         NOT NULL DEFAULT(GETUTCDATE()),
    CONSTRAINT [PK_Books] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE NONCLUSTERED INDEX [IX_Books_Author] ON [dbo].[Books] ([Author] ASC);
GO

CREATE NONCLUSTERED INDEX [IX_Books_Title] ON [dbo].[Books] ([Title] ASC);
GO

-- ============================================================
-- Stored Procedures
-- ============================================================

-- Select all books
CREATE PROCEDURE [dbo].[sp_GetBooks]
    @Search NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id], [Title], [Author], [Year], [Pages],
        [Genre], [ISBN], [Description],
        [TableOfContents],
        [CreatedAt], [UpdatedAt]
    FROM [dbo].[Books]
    WHERE (@Search IS NULL
           OR [Title] LIKE N'%' + @Search + N'%'
           OR [Author] LIKE N'%' + @Search + N'%')
    ORDER BY [Title];
END
GO

-- Select book by Id
CREATE PROCEDURE [dbo].[sp_GetBookById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id], [Title], [Author], [Year], [Pages],
        [Genre], [ISBN], [Description],
        [TableOfContents],
        [CreatedAt], [UpdatedAt]
    FROM [dbo].[Books]
    WHERE [Id] = @Id;
END
GO

-- Insert book
CREATE PROCEDURE [dbo].[sp_InsertBook]
    @Title            NVARCHAR(255),
    @Author           NVARCHAR(255),
    @Year             INT            = NULL,
    @Pages            INT            = NULL,
    @Genre            NVARCHAR(100)  = NULL,
    @ISBN             NVARCHAR(50)   = NULL,
    @Description      NVARCHAR(MAX)  = NULL,
    @TableOfContents  XML            = NULL,
    @NewId            INT            OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [dbo].[Books]
        ([Title], [Author], [Year], [Pages], [Genre], [ISBN], [Description], [TableOfContents])
    VALUES
        (@Title, @Author, @Year, @Pages, @Genre, @ISBN, @Description, @TableOfContents);

    SET @NewId = SCOPE_IDENTITY();
END
GO

-- Update book
CREATE PROCEDURE [dbo].[sp_UpdateBook]
    @Id               INT,
    @Title            NVARCHAR(255),
    @Author           NVARCHAR(255),
    @Year             INT            = NULL,
    @Pages            INT            = NULL,
    @Genre            NVARCHAR(100)  = NULL,
    @ISBN             NVARCHAR(50)   = NULL,
    @Description      NVARCHAR(MAX)  = NULL,
    @TableOfContents  XML            = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [dbo].[Books]
    SET
        [Title]           = @Title,
        [Author]          = @Author,
        [Year]            = @Year,
        [Pages]           = @Pages,
        [Genre]           = @Genre,
        [ISBN]            = @ISBN,
        [Description]     = @Description,
        [TableOfContents] = @TableOfContents,
        [UpdatedAt]       = GETUTCDATE()
    WHERE [Id] = @Id;
END
GO

-- Delete book
CREATE PROCEDURE [dbo].[sp_DeleteBook]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM [dbo].[Books] WHERE [Id] = @Id;
END
GO

-- ============================================================
-- XML Query stored procedures
-- ============================================================

-- Find books containing a chapter with a specific keyword in title
CREATE PROCEDURE [dbo].[sp_FindBooksByChapterTitle]
    @Keyword NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id], [Title], [Author], [Year],
        [TableOfContents]
    FROM [dbo].[Books]
    WHERE [TableOfContents] IS NOT NULL
      AND [TableOfContents].exist('//Chapter[contains(upper-case(@title), upper-case(sql:variable("@Keyword")))]') = 1;
END
GO

-- Get chapter count per book
CREATE PROCEDURE [dbo].[sp_GetChapterCounts]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id],
        [Title],
        [Author],
        [TableOfContents].value('count(/TableOfContents/Chapter)', 'INT') AS [ChapterCount]
    FROM [dbo].[Books]
    WHERE [TableOfContents] IS NOT NULL
    ORDER BY [Title];
END
GO

-- Get total pages from XML chapters per book
CREATE PROCEDURE [dbo].[sp_GetXmlPageCounts]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id],
        [Title],
        [Author],
        [TableOfContents].value('sum(/TableOfContents/Chapter/@pages)', 'INT') AS [TotalXmlPages]
    FROM [dbo].[Books]
    WHERE [TableOfContents] IS NOT NULL
    ORDER BY [Title];
END
GO

-- ============================================================
-- XML Export stored procedure
-- ============================================================

-- Export books as XML document
CREATE PROCEDURE [dbo].[sp_ExportBooksXml]
    @BookId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @BookId IS NOT NULL
    BEGIN
        SELECT
            [Id], [Title], [Author], [Year], [Pages],
            [Genre], [ISBN], [Description],
            [TableOfContents]
        FROM [dbo].[Books]
        WHERE [Id] = @BookId
        FOR XML PATH('Book'), ROOT('HomeLibrary'), TYPE
    END
    ELSE
    BEGIN
        SELECT
            [Id], [Title], [Author], [Year], [Pages],
            [Genre], [ISBN], [Description],
            [TableOfContents]
        FROM [dbo].[Books]
        FOR XML PATH('Book'), ROOT('HomeLibrary'), TYPE
    END
END
GO

PRINT 'Database and stored procedures created successfully.';
GO

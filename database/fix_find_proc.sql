USE [HomeLibrary];
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[sp_FindBooksByChapterTitle]
    @Keyword NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH FoundBooks AS (
        SELECT DISTINCT b.[Id]
        FROM [dbo].[Books] b
        CROSS APPLY [TableOfContents].nodes('/TableOfContents/Chapter') AS x(ch)
        WHERE b.[TableOfContents] IS NOT NULL
          AND x.ch.value('@title', 'NVARCHAR(255)') LIKE N'%' + @Keyword + N'%'

        UNION

        SELECT DISTINCT b.[Id]
        FROM [dbo].[Books] b
        CROSS APPLY [TableOfContents].nodes('/TableOfContents/Chapter/Section') AS x(sec)
        WHERE b.[TableOfContents] IS NOT NULL
          AND sec.value('@title', 'NVARCHAR(255)') LIKE N'%' + @Keyword + N'%'
    )
    SELECT fb.[Id], b.[Title], b.[Author], b.[Year], b.[TableOfContents]
    FROM FoundBooks fb
    INNER JOIN [dbo].[Books] b ON fb.[Id] = b.[Id];
END
GO

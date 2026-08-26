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
        SELECT DISTINCT
            b.[Id]
        FROM [dbo].[Books] b
        CROSS APPLY [TableOfContents].nodes('/TableOfContents/Chapter') AS x(ch)
        WHERE b.[TableOfContents] IS NOT NULL
          AND x.ch.value('@title', 'NVARCHAR(255)') LIKE N'%' + @Keyword + N'%'
    )
    SELECT fb.[Id], b.[Title], b.[Author], b.[Year], b.[TableOfContents]
    FROM FoundBooks fb
    INNER JOIN [dbo].[Books] b ON fb.[Id] = b.[Id];
END
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

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

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

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

PRINT 'XML procedures recreated with QUOTED_IDENTIFIER ON.';
GO

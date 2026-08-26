USE [HomeLibrary];
GO

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

PRINT 'sp_ExportBooksXml created successfully.';
GO

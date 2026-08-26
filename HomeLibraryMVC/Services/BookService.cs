using System.Data;
using System.Xml.Linq;
using HomeLibraryMVC.Models;
using Microsoft.Data.SqlClient;

namespace HomeLibraryMVC.Services;

public class BookService
{
    private readonly string _connectionString;

    public BookService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
    }

    public async Task<List<Book>> GetBooksAsync(string? search = null)
    {
        var books = new List<Book>();
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("sp_GetBooks", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Search", (object?)search ?? DBNull.Value);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            books.Add(MapBook(reader));
        }
        return books;
    }

    public async Task<Book?> GetBookByIdAsync(int id)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("sp_GetBookById", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Id", id);

        await connection.OpenAsync();
        await using var reader = await command.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return MapBook(reader);
        }
        return null;
    }

    public async Task<int> InsertBookAsync(Book book)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("sp_InsertBook", connection)
        {
            CommandType = CommandType.StoredProcedure
        };

        command.Parameters.AddWithValue("@Title", book.Title);
        command.Parameters.AddWithValue("@Author", book.Author);
        command.Parameters.AddWithValue("@Year", (object?)book.Year ?? DBNull.Value);
        command.Parameters.AddWithValue("@Pages", (object?)book.Pages ?? DBNull.Value);
        command.Parameters.AddWithValue("@Genre", (object?)book.Genre ?? DBNull.Value);
        command.Parameters.AddWithValue("@ISBN", (object?)book.ISBN ?? DBNull.Value);
        command.Parameters.AddWithValue("@Description", (object?)book.Description ?? DBNull.Value);

        var xmlParamValue = command.Parameters.AddWithValue("@TableOfContents",
            (object?)book.TableOfContentsXml ?? DBNull.Value);
        xmlParamValue.SqlDbType = SqlDbType.Xml;

        var outputParam = command.Parameters.Add("@NewId", SqlDbType.Int);
        outputParam.Direction = ParameterDirection.Output;

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
        return (int)outputParam.Value!;
    }

    public async Task UpdateBookAsync(Book book)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("sp_UpdateBook", connection)
        {
            CommandType = CommandType.StoredProcedure
        };

        command.Parameters.AddWithValue("@Id", book.Id);
        command.Parameters.AddWithValue("@Title", book.Title);
        command.Parameters.AddWithValue("@Author", book.Author);
        command.Parameters.AddWithValue("@Year", (object?)book.Year ?? DBNull.Value);
        command.Parameters.AddWithValue("@Pages", (object?)book.Pages ?? DBNull.Value);
        command.Parameters.AddWithValue("@Genre", (object?)book.Genre ?? DBNull.Value);
        command.Parameters.AddWithValue("@ISBN", (object?)book.ISBN ?? DBNull.Value);
        command.Parameters.AddWithValue("@Description", (object?)book.Description ?? DBNull.Value);

        var xmlParamValue = command.Parameters.AddWithValue("@TableOfContents",
            (object?)book.TableOfContentsXml ?? DBNull.Value);
        xmlParamValue.SqlDbType = SqlDbType.Xml;

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task DeleteBookAsync(int id)
    {
        await using var connection = new SqlConnection(_connectionString);
        await using var command = new SqlCommand("sp_DeleteBook", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Id", id);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task<List<XmlQueryResult>> FindBooksByChapterTitleAsync(string keyword)
    {
        var results = new List<XmlQueryResult>();
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();
        await ApplyXmlSettingsAsync(connection);

        await using var command = new SqlCommand("sp_FindBooksByChapterTitle", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        command.Parameters.AddWithValue("@Keyword", keyword);
        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            results.Add(new XmlQueryResult
            {
                Id = reader.GetInt32(0),
                Title = reader.GetString(1),
                Author = reader.GetString(2),
                Year = reader.IsDBNull(3) ? null : reader.GetInt32(3),
                XmlData = reader.IsDBNull(4) ? null : reader[4].ToString()
            });
        }
        return results;
    }

    public async Task<List<ChapterCountResult>> GetChapterCountsAsync()
    {
        var results = new List<ChapterCountResult>();
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();
        await ApplyXmlSettingsAsync(connection);

        await using var command = new SqlCommand("sp_GetChapterCounts", connection)
        {
            CommandType = CommandType.StoredProcedure
        };

        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            results.Add(new ChapterCountResult
            {
                Id = reader.GetInt32(0),
                Title = reader.GetString(1),
                Author = reader.GetString(2),
                ChapterCount = reader.IsDBNull(3) ? 0 : reader.GetInt32(3)
            });
        }
        return results;
    }

    public async Task<List<XmlPageCountResult>> GetXmlPageCountsAsync()
    {
        var results = new List<XmlPageCountResult>();
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();
        await ApplyXmlSettingsAsync(connection);

        await using var command = new SqlCommand("sp_GetXmlPageCounts", connection)
        {
            CommandType = CommandType.StoredProcedure
        };

        await using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            results.Add(new XmlPageCountResult
            {
                Id = reader.GetInt32(0),
                Title = reader.GetString(1),
                Author = reader.GetString(2),
                TotalXmlPages = reader.IsDBNull(3) ? 0 : reader.GetInt32(3)
            });
        }
        return results;
    }

    public async Task<string> ExportLibraryXmlAsync(int? bookId = null)
    {
        await using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();
        await ApplyXmlSettingsAsync(connection);

        await using var command = new SqlCommand("sp_ExportBooksXml", connection)
        {
            CommandType = CommandType.StoredProcedure
        };
        if (bookId.HasValue)
            command.Parameters.AddWithValue("@BookId", bookId.Value);

        var result = await command.ExecuteScalarAsync();
        return result?.ToString() ?? "<HomeLibrary/>";
    }

    private static async Task ApplyXmlSettingsAsync(SqlConnection connection)
    {
        await using var cmd = new SqlCommand("SET QUOTED_IDENTIFIER ON; SET ANSI_NULLS ON;", connection);
        await cmd.ExecuteNonQueryAsync();
    }

    private static Book MapBook(SqlDataReader reader)
    {
        var book = new Book
        {
            Id = reader.GetInt32(reader.GetOrdinal("Id")),
            Title = reader.GetString(reader.GetOrdinal("Title")),
            Author = reader.GetString(reader.GetOrdinal("Author")),
            Year = reader.IsDBNull(reader.GetOrdinal("Year"))
                ? null : reader.GetInt32(reader.GetOrdinal("Year")),
            Pages = reader.IsDBNull(reader.GetOrdinal("Pages"))
                ? null : reader.GetInt32(reader.GetOrdinal("Pages")),
            Genre = reader.IsDBNull(reader.GetOrdinal("Genre"))
                ? null : reader.GetString(reader.GetOrdinal("Genre")),
            ISBN = reader.IsDBNull(reader.GetOrdinal("ISBN"))
                ? null : reader.GetString(reader.GetOrdinal("ISBN")),
            Description = reader.IsDBNull(reader.GetOrdinal("Description"))
                ? null : reader.GetString(reader.GetOrdinal("Description")),
            CreatedAt = reader.GetDateTime(reader.GetOrdinal("CreatedAt")),
            UpdatedAt = reader.GetDateTime(reader.GetOrdinal("UpdatedAt"))
        };

        var tocOrdinal = reader.GetOrdinal("TableOfContents");
        if (!reader.IsDBNull(tocOrdinal))
        {
            var xmlValue = reader[tocOrdinal];
            if (xmlValue is System.Data.SqlTypes.SqlXml sqlXml && sqlXml.Value != null)
            {
                book.TableOfContentsXml = sqlXml.Value;
            }
            else
            {
                book.TableOfContentsXml = xmlValue.ToString();
            }
        }

        return book;
    }
}

public class XmlQueryResult
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public int? Year { get; set; }
    public string? XmlData { get; set; }
}

public class ChapterCountResult
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public int ChapterCount { get; set; }
}

public class XmlPageCountResult
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Author { get; set; } = string.Empty;
    public int TotalXmlPages { get; set; }
}

using System.Data;
using Microsoft.Data.SqlClient;

var connectionString = "Server=(localdb)\\MSSQLLocalDB;Database=HomeLibrary;Trusted_Connection=True;TrustServerCertificate=True;";

await using var connection = new SqlConnection(connectionString);
await connection.OpenAsync();

// Test search
Console.WriteLine("=== Search for 'Пузырьковая' ===");
await using (var cmd = new SqlCommand("sp_FindBooksByChapterTitle", connection)
{
    CommandType = CommandType.StoredProcedure
})
{
    cmd.Parameters.AddWithValue("@Keyword", "Пузырьковая");
    await using var reader = await cmd.ExecuteReaderAsync();
    while (await reader.ReadAsync())
        Console.WriteLine($"  Found: Book {reader.GetInt32(0)} - {reader.GetString(1)}");
}

Console.WriteLine("\n=== Search for 'Сортировка' ===");
await using (var cmd2 = new SqlCommand("sp_FindBooksByChapterTitle", connection)
{
    CommandType = CommandType.StoredProcedure
})
{
    cmd2.Parameters.AddWithValue("@Keyword", "Сортировка");
    await using var reader2 = await cmd2.ExecuteReaderAsync();
    while (await reader2.ReadAsync())
        Console.WriteLine($"  Found: Book {reader2.GetInt32(0)} - {reader2.GetString(1)}");
}

Console.WriteLine("\n=== Search for 'Singleton' ===");
await using (var cmd3 = new SqlCommand("sp_FindBooksByChapterTitle", connection)
{
    CommandType = CommandType.StoredProcedure
})
{
    cmd3.Parameters.AddWithValue("@Keyword", "Singleton");
    await using var reader3 = await cmd3.ExecuteReaderAsync();
    while (await reader3.ReadAsync())
        Console.WriteLine($"  Found: Book {reader3.GetInt32(0)} - {reader3.GetString(1)}");
}

Console.WriteLine("\nDone.");

using HomeLibraryRazorPages.Models;
using HomeLibraryRazorPages.Services;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HomeLibraryRazorPages.Pages.Books;

public class IndexModel : PageModel
{
    private readonly BookService _bookService;

    public IndexModel(BookService bookService) => _bookService = bookService;

    public List<Book> Books { get; set; } = new();
    public string? Search { get; set; }

    public async Task OnGetAsync(string? search)
    {
        Search = search;
        Books = await _bookService.GetBooksAsync(search);
    }
}

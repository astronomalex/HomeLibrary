using HomeLibraryRazorPages.Models;
using HomeLibraryRazorPages.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HomeLibraryRazorPages.Pages.Books;

public class DetailsModel : PageModel
{
    private readonly BookService _bookService;

    public DetailsModel(BookService bookService) => _bookService = bookService;

    public Book? Book { get; set; }

    public async Task<IActionResult> OnGetAsync(int id)
    {
        Book = await _bookService.GetBookByIdAsync(id);
        if (Book == null) return NotFound();
        return Page();
    }
}

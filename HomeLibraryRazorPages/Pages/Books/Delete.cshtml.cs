using HomeLibraryRazorPages.Models;
using HomeLibraryRazorPages.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HomeLibraryRazorPages.Pages.Books;

public class DeleteModel : PageModel
{
    private readonly BookService _bookService;

    public DeleteModel(BookService bookService) => _bookService = bookService;

    [BindProperty]
    public Book Book { get; set; } = new();

    public async Task<IActionResult> OnGetAsync(int id)
    {
        var book = await _bookService.GetBookByIdAsync(id);
        if (book == null) return NotFound();
        Book = book;
        return Page();
    }

    public async Task<IActionResult> OnPostAsync(int id)
    {
        await _bookService.DeleteBookAsync(id);
        return RedirectToPage("Index");
    }
}

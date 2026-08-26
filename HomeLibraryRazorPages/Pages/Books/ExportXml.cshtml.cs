using HomeLibraryRazorPages.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HomeLibraryRazorPages.Pages.Books;

public class ExportXmlModel : PageModel
{
    private readonly BookService _bookService;

    public ExportXmlModel(BookService bookService) => _bookService = bookService;

    public async Task<IActionResult> OnGetAsync(int? id)
    {
        var xml = await _bookService.ExportLibraryXmlAsync(id);
        var bytes = System.Text.Encoding.UTF8.GetBytes(xml);
        var fileName = id.HasValue ? $"book_{id}.xml" : "home_library.xml";
        return File(bytes, "application/xml", fileName);
    }
}

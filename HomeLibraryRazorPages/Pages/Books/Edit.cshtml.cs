using HomeLibraryRazorPages.Models;
using HomeLibraryRazorPages.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HomeLibraryRazorPages.Pages.Books;

public class EditModel : PageModel
{
    private readonly BookService _bookService;

    public EditModel(BookService bookService) => _bookService = bookService;

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
        if (id != Book.Id) return BadRequest();
        if (!ModelState.IsValid) return Page();

        Book.TableOfContentsXml = SanitizeXml(Book.TableOfContentsXml);
        await _bookService.UpdateBookAsync(Book);
        return RedirectToPage("Index");
    }

    private static string? SanitizeXml(string? html)
    {
        if (string.IsNullOrWhiteSpace(html)) return null;

        var text = html.Trim();

        // Decode HTML entities that CKEditor inserts
        text = text.Replace("&nbsp;", " ");
        text = text.Replace("&amp;", "&");
        text = text.Replace("&lt;", "<");
        text = text.Replace("&gt;", ">");
        text = text.Replace("&quot;", "\"");
        text = text.Replace("&#39;", "'");

        // Strip HTML tags (<p>, <br>, etc.)
        text = System.Text.RegularExpressions.Regex.Replace(text, @"<br\s*/?>", "\n", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        text = System.Text.RegularExpressions.Regex.Replace(text, @"<p[^>]*>", "\n", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        text = System.Text.RegularExpressions.Regex.Replace(text, @"</p>", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        // Extract XML part
        var xmlStart = text.IndexOf("<TableOfContents");
        var xmlEnd = text.LastIndexOf("</TableOfContents>");
        if (xmlStart >= 0 && xmlEnd > xmlStart)
        {
            text = text.Substring(xmlStart, xmlEnd + "</TableOfContents>".Length - xmlStart);
        }

        return text;
    }
}

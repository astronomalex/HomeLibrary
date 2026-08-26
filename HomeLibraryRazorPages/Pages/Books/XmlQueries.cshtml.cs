using HomeLibraryRazorPages.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace HomeLibraryRazorPages.Pages.Books;

public class XmlQueriesModel : PageModel
{
    private readonly BookService _bookService;

    public XmlQueriesModel(BookService bookService) => _bookService = bookService;

    public string? Keyword { get; set; }
    public List<XmlQueryResult>? ChapterResults { get; set; }
    public List<ChapterCountResult>? ChapterCounts { get; set; }
    public List<XmlPageCountResult>? PageCounts { get; set; }

    public void OnGet()
    {
    }

    public async Task<IActionResult> OnPostSearchByChapterAsync(string keyword)
    {
        Keyword = keyword;
        ChapterResults = await _bookService.FindBooksByChapterTitleAsync(keyword);
        return Page();
    }

    public async Task<IActionResult> OnPostChapterCountsAsync()
    {
        ChapterCounts = await _bookService.GetChapterCountsAsync();
        return Page();
    }

    public async Task<IActionResult> OnPostPageCountsAsync()
    {
        PageCounts = await _bookService.GetXmlPageCountsAsync();
        return Page();
    }
}

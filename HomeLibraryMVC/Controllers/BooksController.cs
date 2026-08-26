using HomeLibraryMVC.Models;
using HomeLibraryMVC.Services;
using Microsoft.AspNetCore.Mvc;

namespace HomeLibraryMVC.Controllers;

public class BooksController : Controller
{
    private readonly BookService _bookService;

    public BooksController(BookService bookService)
    {
        _bookService = bookService;
    }

    public async Task<IActionResult> Index(string? search)
    {
        var books = await _bookService.GetBooksAsync(search);
        ViewBag.Search = search;
        return View(books);
    }

    public async Task<IActionResult> Details(int id)
    {
        var book = await _bookService.GetBookByIdAsync(id);
        if (book == null) return NotFound();
        return View(book);
    }

    public IActionResult Create()
    {
        return View(new Book());
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Book book)
    {
        if (!ModelState.IsValid) return View(book);

        book.TableOfContentsXml = SanitizeXml(book.TableOfContentsXml);
        await _bookService.InsertBookAsync(book);
        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> Edit(int id)
    {
        var book = await _bookService.GetBookByIdAsync(id);
        if (book == null) return NotFound();
        return View(book);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Book book)
    {
        if (id != book.Id) return BadRequest();
        if (!ModelState.IsValid) return View(book);

        book.TableOfContentsXml = SanitizeXml(book.TableOfContentsXml);
        await _bookService.UpdateBookAsync(book);
        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> Delete(int id)
    {
        var book = await _bookService.GetBookByIdAsync(id);
        if (book == null) return NotFound();
        return View(book);
    }

    [HttpPost, ActionName("Delete")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> DeleteConfirmed(int id)
    {
        await _bookService.DeleteBookAsync(id);
        return RedirectToAction(nameof(Index));
    }

    public async Task<IActionResult> XmlQueries()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> SearchByChapter(string keyword)
    {
        var results = await _bookService.FindBooksByChapterTitleAsync(keyword);
        ViewBag.Keyword = keyword;
        ViewBag.ChapterResults = results;
        return View("XmlQueries");
    }

    [HttpPost]
    public async Task<IActionResult> GetChapterCounts()
    {
        var results = await _bookService.GetChapterCountsAsync();
        ViewBag.ChapterCounts = results;
        return View("XmlQueries");
    }

    [HttpPost]
    public async Task<IActionResult> GetXmlPageCounts()
    {
        var results = await _bookService.GetXmlPageCountsAsync();
        ViewBag.PageCounts = results;
        return View("XmlQueries");
    }

    public async Task<IActionResult> ExportXml(int? id)
    {
        var xml = await _bookService.ExportLibraryXmlAsync(id);
        var bytes = System.Text.Encoding.UTF8.GetBytes(xml);
        var fileName = id.HasValue ? $"book_{id}.xml" : "home_library.xml";
        return File(bytes, "application/xml", fileName);
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

        // Strip HTML tags (<p>, <br>, <br/>, etc.) keeping content
        text = System.Text.RegularExpressions.Regex.Replace(text, @"<br\s*/?>", "\n", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        text = System.Text.RegularExpressions.Regex.Replace(text, @"<p[^>]*>", "\n", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        text = System.Text.RegularExpressions.Regex.Replace(text, @"</p>", "", System.Text.RegularExpressions.RegexOptions.IgnoreCase);

        // Strip any remaining tags but keep <TableOfContents> structure
        var xmlStart = text.IndexOf("<TableOfContents");
        var xmlEnd = text.LastIndexOf("</TableOfContents>");
        if (xmlStart >= 0 && xmlEnd > xmlStart)
        {
            text = text.Substring(xmlStart, xmlEnd + "</TableOfContents>".Length - xmlStart);
        }

        // Validate XML
        try
        {
            System.Xml.Linq.XElement.Parse(text);
            return text;
        }
        catch
        {
            return text; // Return as-is if parsing fails, let SQL handle it
        }
    }
}

using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;

namespace HomeLibraryMVC.Models;

public class Book
{
    public int Id { get; set; }

    [Required(ErrorMessage = "Название обязательно")]
    [Display(Name = "Название")]
    public string Title { get; set; } = string.Empty;

    [Required(ErrorMessage = "Автор обязателен")]
    [Display(Name = "Автор")]
    public string Author { get; set; } = string.Empty;

    [Display(Name = "Год издания")]
    [Range(1000, 2100, ErrorMessage = "Год должен быть от 1000 до 2100")]
    public int? Year { get; set; }

    [Display(Name = "Кол-во страниц")]
    [Range(1, 100000)]
    public int? Pages { get; set; }

    [Display(Name = "Жанр")]
    public string? Genre { get; set; }

    [Display(Name = "ISBN")]
    public string? ISBN { get; set; }

    [Display(Name = "Описание")]
    public string? Description { get; set; }

    [Display(Name = "Оглавление (XML)")]
    public string? TableOfContentsXml { get; set; }

    [Display(Name = "Дата создания")]
    public DateTime CreatedAt { get; set; }

    [Display(Name = "Дата обновления")]
    public DateTime UpdatedAt { get; set; }

    public XElement? TableOfContentsParsed
    {
        get
        {
            if (string.IsNullOrWhiteSpace(TableOfContentsXml))
                return null;
            try
            {
                return XElement.Parse(TableOfContentsXml);
            }
            catch
            {
                return null;
            }
        }
    }
}

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MusicCollection.DAL;
using MusicCollection.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using static System.Net.WebRequestMethods;
using System.Globalization;
using System.Text;

namespace MusicCollection.Controllers
{
    public class HomeController : Controller
    {
        AlbumContext db;

        public HomeController(AlbumContext db)
        {
            this.db = db;
        }

        public IActionResult Index()
        {
            var albums = db.Albums
                            .Include(a => a.Artist)
                            .Include(a => a.Type)
                            .Include(a => a.Category)
                            .OrderBy(a => a.Artist.Name)
                            .ThenBy(a => a.Title)
                            .ToList();

            return View(albums);
        }
        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult RecentAlbums()
        {
            var newestPublishDate = db.Albums.Max(a => a.Date);
            var newestAlbums = db.Albums
                .Include (a => a.Artist)
                .Include(a => a.Type)
                .Include (a => a.Category)
                .Where(a => a.Date == newestPublishDate)
                .OrderBy(a=>a.Artist.Name)
                .ThenBy(a=>a.Title)
                .ToList();
            return View(newestAlbums);
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult AddAlbum()
        {
            ViewBag.Types = db.Types.OrderBy(a => a.Name).ToList();
            ViewBag.Artists = db.Artists.ToList();
            ViewBag.Categories = db.Categories.OrderBy(a => a.Name).ToList();
            return View();
        }

        public static string RemoveDiacritics(string input)
        {
            if (string.IsNullOrEmpty(input))
                return input;

            string normalizedString = input.Normalize(NormalizationForm.FormD);
            StringBuilder stringBuilder = new StringBuilder();

            foreach (char c in normalizedString)
            {
                if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                    stringBuilder.Append(c);
            }

            return stringBuilder.ToString();
        }

        [HttpPost]
        public IActionResult AddAlbum(Album model, IFormFile posterFile)
        {
            bool state = true;
            if (string.IsNullOrEmpty(model.Title))
            {
                ModelState.AddModelError("Title", "Wpisz tytuł");
                state = false;
            }
            if (model.TypeId == null)
            {
                ModelState.AddModelError("TypeId", "Wybierz typ");
                state = false;
            }
            if (model.PublishDate < 1900 || model.PublishDate > DateTime.Now.Year)
            {
                ModelState.AddModelError("PublishYear", "Nieprawidłowy rok publikacji");
                state = false;
            }

            if (state)
            {
                var existingAlbum = db.Albums.FirstOrDefault(a => a.Title == model.Title && a.TypeId == model.TypeId);
                if (existingAlbum != null)
                {
                    ModelState.AddModelError("Title", "Album o tej nazwie i typie już istnieje");
                    ViewBag.Types = db.Types.ToList();
                    ViewBag.Categories = db.Categories.ToList();
                    ViewBag.Artists = db.Artists.ToList();
                    return View(model);
                }

                // Przetwarzanie pliku plakatu
                if (posterFile != null && posterFile.Length > 0)
                {
                    // Tworzenie nazwy pliku na podstawie tytułu albumu i typu
                    var selectedType = db.Types.FirstOrDefault(t => t.Id == model.TypeId)?.Name ?? "UnknownType";
                    var fileNameWithoutExtension = $"{RemoveDiacritics(model.Title.Replace(" ", "_")).ToLower()}_{RemoveDiacritics(selectedType.Replace(" ", "_")).ToLower()}";

                    // Usuwanie znaków specjalnych i innych niż litery i cyfry
                    fileNameWithoutExtension = Regex.Replace(fileNameWithoutExtension, "[^a-zA-Z0-9_]", "");

                    // Ustawianie nazwy pliku z rozszerzeniem
                    var fileName = $"{fileNameWithoutExtension}.jpg";

                    // Ustawianie ścieżki docelowej
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", fileName);

                    // Zapisywanie pliku na dysku
                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        posterFile.CopyTo(fileStream);
                    }

                    // Ustawianie ścieżki pliku plakatu w modelu albumu
                    model.Poster = "/posters/" + fileName;
                }

                // Sprawdzenie, czy artysta istnieje w bazie danych
                var artistName = Request.Form["artistName"].ToString();
                var existingArtist = db.Artists.FirstOrDefault(a => a.Name == artistName);

                // Jeśli artysta nie istnieje, dodaj nowego artystę do bazy danych
                if (existingArtist == null)
                {
                    existingArtist = new Artist { Name = artistName };
                    db.Artists.Add(existingArtist);
                    db.SaveChanges(); // Zapisanie zmian w bazie danych, aby uzyskać nowy identyfikator
                }

                // Ustawienie identyfikatora artysty w modelu albumu
                model.ArtistId = existingArtist.Id;

                // Dodanie albumu do bazy danych
                model.Date = DateTime.Today.ToString("yyyy.MM.dd");
                db.Albums.Add(model);
                db.SaveChanges();

                // Dodanie relacji do tabeli łączącej ArtistAlbums
                var albumArtist = new ArtistAlbum
                {
                    ArtistId = existingArtist.Id,
                    AlbumId = model.Id
                };
                db.ArtistAlbums.Add(albumArtist);
                db.SaveChanges();

                // Aktualizacja nazwy pliku z uwzględnieniem Id
                if (model.Id != 0)
                {
                    var selectedType = db.Types.FirstOrDefault(t => t.Id == model.TypeId)?.Name ?? "UnknownType";
                    var fileNameWithoutExtension = $"{RemoveDiacritics(model.Title.Replace(" ", "_")).ToLower()}_{RemoveDiacritics(selectedType.Replace(" ", "_")).ToLower()}";
                    fileNameWithoutExtension = Regex.Replace(fileNameWithoutExtension, "[^a-zA-Z0-9_]", "");
                    var fileName = $"{fileNameWithoutExtension}.jpg";
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", fileName);
                    var newFileName = $"{model.Id}_{fileName}";

                    // Zmień nazwę pliku na dysku
                    var oldFilePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", fileName);
                    var newFilePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", newFileName);
                    System.IO.File.Move(oldFilePath, newFilePath);

                    // Zaktualizuj ścieżkę pliku plakatu w modelu albumu
                    model.Poster = "/posters/" + newFileName;
                    db.SaveChanges();
                }

                return RedirectToAction("Index");
            }

            ViewBag.Types = db.Types.OrderBy(a => a.Name).ToList();
            ViewBag.Artists = db.Artists.ToList();
            ViewBag.Categories = db.Categories.OrderBy(a => a.Name).ToList();
            return View(model);
        }



        [HttpGet]
        public IActionResult GetArtistSuggestions(string query)
        {
            var artists = db.Artists
                .Where(a => a.Name.Contains(query))
                .Select(a => new { id = a.Id, name = a.Name })
                .OrderBy(a => a.name)
                .ToList();

            return Json(artists);
        }

        [HttpPost]
        public IActionResult Add(string name)
        {
            var existingArtist = db.Artists.FirstOrDefault(a => a.Name == name);

            if (existingArtist == null)
            {
                var newArtist = new Artist { Name = name };
                db.Artists.Add(newArtist);
                db.SaveChanges();
                return Json(new { id = newArtist.Id });
            }
            else
            {
                return Json(new { id = existingArtist.Id });
            }
        }

        public IActionResult ArtistAlbums(string artistName)
        {
            // Pobieranie wszystkich albumów dla danego artysty
            var artistAlbums = db.Albums
                                .Include(a => a.Artist)
                                .Include(a => a.Type)
                                .Include(a => a.Category)
                                .Where(a => a.Artist.Name == artistName)
                                .OrderBy(a => a.Title)
                                .ToList();

            return View(artistAlbums);
        }


        public IActionResult Search(string text)
        {
            // Pobierz wszystkie albumy z bazy danych
            IQueryable<Album> albumsQuery = db.Albums.Include(a => a.Artist).Include(a => a.Type).Include(a => a.Category).OrderBy(a => a.Artist.Name).ThenBy(a => a.Title);

            // Wyszukaj po tytule albumu
            IQueryable<Album> albumsByTitleQuery = albumsQuery;
            if (!string.IsNullOrEmpty(text))
            {
                albumsByTitleQuery = albumsByTitleQuery.Where(a => a.Title.ToLower().Contains(text.ToLower()));
            }
            var searchResultsByTitle = albumsByTitleQuery.ToList();

            // Wyszukaj po nazwie artysty
            IQueryable<Artist> artistsQuery = db.Artists.OrderBy(a => a.Name);
            IQueryable<Album> albumsByArtistQuery = albumsQuery;
            if (!string.IsNullOrEmpty(text))
            {
                artistsQuery = artistsQuery.Where(a => a.Name.ToLower().Contains(text.ToLower()));
                albumsByArtistQuery = albumsByArtistQuery.Where(a => a.Artist.Name.ToLower().Contains(text.ToLower()));
            }
            var searchResultsByArtist = albumsByArtistQuery.ToList();
            var artistResults = artistsQuery.ToList();


            // Jeśli znaleziono tylko jednego artystę i nie znaleziono żadnego albumu, przekieruj na stronę artysty
            if (artistResults.Count == 1 && !searchResultsByTitle.Any())
            {
                var artistName = artistResults.FirstOrDefault()?.Name;
                return RedirectToAction("ArtistAlbums", "Home", new { artistName });
            }

            var allalbums = albumsQuery.ToList().Count;
            if (searchResultsByTitle.Count == allalbums)
            {
                ViewBag.AllAlbums = true;
            }
            var uniqueArtists = searchResultsByArtist.Select(a => a.Artist).Distinct().ToList();
            // Wyświetl wyniki wyszukiwania na stronie wyszukiwarki
            ViewBag.SearchResultsByArtist = uniqueArtists;
            return View("Search", searchResultsByTitle);
        }

        public IActionResult CategoryAlbums(string categoryName)
        {
            // Pobieranie wszystkich albumów dla danego artysty
            var categoryAlbums = db.Albums
                                .Include(a => a.Artist)
                                .Include(a => a.Type)
                                .Include(a => a.Category)
                                .Where(a => a.Category.Name == categoryName)
                                .OrderBy(a => a.Artist.Name)
                                .ThenBy(a => a.Title)
                                .ToList();

            return View(categoryAlbums);
        }

        public IActionResult TypeAlbums(string typeName)
        {
            // Pobieranie wszystkich albumów dla danego artysty
            var typeAlbums = db.Albums
                                .Include(a => a.Artist)
                                .Include(a => a.Type)
                                .Include(a => a.Category)
                                .Where(a => a.Type.Name == typeName)
                                .OrderBy(a => a.Artist.Name)
                                .ThenBy(a => a.Title)
                                .ToList();

            return View(typeAlbums);
        }

        public IActionResult Stats()
        {
            var totalAlbums = db.Albums.Count();
            var totalArtists = db.Artists.Count();
            var averageReleaseYear = (int)Math.Floor(db.Albums.Average(a => a.PublishDate));

            var albumsByType = db.Albums
                .GroupBy(a => a.Type.Name)
                .Select(g => new AlbumsByTypeViewModel { TypeName = g.Key, Count = g.Count() })
                .ToList();

            var albumsByArtist = db.Artists
        .Select(a => new AlbumsByArtistViewModel
        {
            ArtistName = a.Name,
            AlbumCount = a.Album.Count()
        })
        .OrderByDescending(a => a.AlbumCount)
        .Take(8)
        .ToList();

            var albumsByGenre = db.Albums
                .GroupBy(a => a.Category.Name)
                .Select(g => new AlbumsByTypeViewModel { TypeName = g.Key, Count = g.Count() })
                .ToList();

            var oldestAlbum = db.Albums
                .Include(a => a.Artist)
                .Include(a => a.Type)
                .Include(a => a.Category)
                .OrderBy(a => a.PublishDate)
                .FirstOrDefault();

            var newestAlbum = db.Albums
                .Include(a => a.Artist)
                .Include(a => a.Type)
                .Include(a => a.Category)
                .OrderByDescending(a => a.PublishDate)
                .FirstOrDefault();

            ViewBag.AlbumsByArtistJson = Newtonsoft.Json.JsonConvert.SerializeObject(albumsByArtist);

            var statsViewModel = new StatsViewModel
            {
                TotalAlbums = totalAlbums,
                TotalArtists = totalArtists,
                AverageReleaseYear = averageReleaseYear,
                AlbumsByType = albumsByType,
                AlbumsByArtist = albumsByArtist,
                OldestAlbum = oldestAlbum,
                NewestAlbum = newestAlbum,
                AlbumsByGenre = albumsByGenre
            };

            var topArtistsType1 = db.Albums
                .Where(a => a.TypeId == 1)
                .GroupBy(a => a.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Pobieranie najpopularniejszych artystów dla typu 2
            var topArtistsType2 = db.Albums
                .Where(a => a.TypeId == 2)
                .GroupBy(a => a.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            var topArtistsCategoryRap = db.Albums
                .Where(a => a.CategoryId == 1)
                .GroupBy(a => a.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();
            var topArtistsCategoryRock = db.Albums
                .Where(a => a.CategoryId == 2)
                .GroupBy(a => a.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();
            var topArtistsCategoryInne = db.Albums
                .Where(a => a.CategoryId == 3)
                .GroupBy(a => a.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();
            ViewBag.TopArtistsCategoryInne = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsCategoryInne);
            ViewBag.TopArtistsCategoryRock = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsCategoryRock);
            ViewBag.TopArtistsCategoryRap = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsCategoryRap);
            ViewBag.TopArtistsType1 = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsType1);
            ViewBag.TopArtistsType2 = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsType2);

            return View(statsViewModel);
        }
    }
}

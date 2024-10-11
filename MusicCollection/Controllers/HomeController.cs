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
            // Pobieranie albumów z powiązanymi artystami
            var albums = db.Albums
                            .Include(a => a.ArtistAlbums) // Łączenie z tabelą ArtistAlbums
                            .ThenInclude(aa => aa.Artist) // Łączenie z tabelą Artists
                            .Include(a => a.Type)         // Łączenie z tabelą Type
                            .Include(a => a.Category)     // Łączenie z tabelą Category
                            .ToList(); // Przeniesienie danych do pamięci

            // Sortowanie albumów na poziomie aplikacji
            var sortedAlbums = albums
                                .OrderBy(a => string.Join(", ", a.ArtistAlbums
                                    .Select(aa => aa.Artist.Name)      // Pobieranie nazw artystów
                                    .OrderBy(name => name)))           // Sortowanie nazw artystów w albumie alfabetycznie
                                .ThenBy(a => a.Title)                  // Następnie sortowanie według tytułu albumu
                                .ToList();

            return View(sortedAlbums);
        }




        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult RecentAlbums()
        {
            var newestPublishDate = db.Albums.Max(a => a.Date);

            // Pobieranie albumów z powiązanymi artystami
            var albums = db.Albums
                            .Include(a => a.ArtistAlbums) // Łączenie z tabelą ArtistAlbums
                            .ThenInclude(aa => aa.Artist) // Łączenie z tabelą Artists
                            .Include(a => a.Type)         // Łączenie z tabelą Type
                            .Include(a => a.Category)     // Łączenie z tabelą Category
                            .Where(a => a.Date == newestPublishDate)
                            .ToList(); // Przeniesienie danych do pamięci

            // Sortowanie albumów na poziomie aplikacji
            var newestAlbums = albums
                                .OrderBy(a => string.Join(", ", a.ArtistAlbums
                                    .Select(aa => aa.Artist.Name)      // Pobieranie nazw artystów
                                    .OrderBy(name => name)))           // Sortowanie nazw artystów w albumie alfabetycznie
                                .ThenBy(a => a.Title)                  // Następnie sortowanie według tytułu albumu
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

            // Walidacja danych albumu
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
            var artistIds = Request.Form["artistIds[]"].ToString().Split(',');

            if (artistIds==null)
            {
                ModelState.AddModelError("artistIds[]", "Dodaj artystę");
                state = false;
            }


            if (state)
            {
                // Sprawdzanie czy album już istnieje
                var existingAlbum = db.Albums.FirstOrDefault(a => a.Title == model.Title && a.TypeId == model.TypeId);
                if (existingAlbum != null)
                {
                    ModelState.AddModelError("Title", "Album o tej nazwie i typie już istnieje");
                    ViewBag.Types = db.Types.ToList();
                    ViewBag.Categories = db.Categories.ToList();
                    ViewBag.Artists = db.Artists.ToList();
                    return View(model);
                }

                // Przetwarzanie pliku plakatu (pozostawiono bez zmian)
                if (posterFile != null && posterFile.Length > 0)
                {
                    var selectedType = db.Types.FirstOrDefault(t => t.Id == model.TypeId)?.Name ?? "UnknownType";
                    var fileNameWithoutExtension = $"{RemoveDiacritics(model.Title.Replace(" ", "_")).ToLower()}_{RemoveDiacritics(selectedType.Replace(" ", "_")).ToLower()}";
                    fileNameWithoutExtension = Regex.Replace(fileNameWithoutExtension, "[^a-zA-Z0-9_]", "");
                    var fileName = $"{fileNameWithoutExtension}.jpg";
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", fileName);
                    using (var fileStream = new FileStream(filePath, FileMode.Create))
                    {
                        posterFile.CopyTo(fileStream);
                    }
                    model.Poster = "/posters/" + fileName;
                }

                // Dodanie albumu do bazy danych
                model.Date = DateTime.Today.ToString("yyyy.MM.dd");
                db.Albums.Add(model);
                db.SaveChanges();

                foreach (var artistId in artistIds)
                {
                    Artist existingArtist;

                    // Sprawdzenie, czy artysta jest nowy
                    if (artistId.StartsWith("new-"))
                    {
                        // Nowy artysta - dodaj do bazy danych
                        var newArtistName = artistId.Replace("new-", "");
                        existingArtist = new Artist { Name = newArtistName };
                        db.Artists.Add(existingArtist);
                        db.SaveChanges();
                    }
                    else
                    {
                        // Istniejący artysta
                        existingArtist = db.Artists.FirstOrDefault(a => a.Id == int.Parse(artistId));
                    }

                    // Dodaj relację do tabeli łączącej ArtistAlbums
                    if (existingArtist != null)
                    {
                        var albumArtist = new ArtistAlbum
                        {
                            ArtistId = existingArtist.Id,
                            AlbumId = model.Id
                        };
                        db.ArtistAlbums.Add(albumArtist);
                    }
                }
                db.SaveChanges();

                // Aktualizacja nazwy pliku plakatu, jeśli album został zapisany
                if (model.Id != 0)
                {
                    var selectedType = db.Types.FirstOrDefault(t => t.Id == model.TypeId)?.Name ?? "UnknownType";
                    var fileNameWithoutExtension = $"{RemoveDiacritics(model.Title.Replace(" ", "_")).ToLower()}_{RemoveDiacritics(selectedType.Replace(" ", "_")).ToLower()}";
                    fileNameWithoutExtension = Regex.Replace(fileNameWithoutExtension, "[^a-zA-Z0-9_]", "");
                    var fileName = $"{fileNameWithoutExtension}.jpg";
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", fileName);
                    var newFileName = $"{model.Id}_{fileName}";

                    var oldFilePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", fileName);
                    var newFilePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "posters", newFileName);
                    System.IO.File.Move(oldFilePath, newFilePath);

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
            // Pobieranie albumów, gdzie wybrany artysta jest wśród artystów albumu
            var artistAlbums = db.Albums
                                 .Include(a => a.ArtistAlbums)
                                     .ThenInclude(aa => aa.Artist)
                                 .Include(a => a.Type)
                                 .Include(a => a.Category)
                                 .Where(a => a.ArtistAlbums.Any(aa => aa.Artist.Name == artistName))
                                 .OrderBy(a => a.Title)
                                 .ToList();

            // Dodanie ViewBag z nazwą artysty, aby łatwiej można było odwoływać się do tej zmiennej w widoku
            ViewBag.ArtistName = artistName;

            return View(artistAlbums);
        }



        public IActionResult Search(string text)
        {
            // Pobierz wszystkie albumy z tabelami powiązanymi
            IQueryable<Album> albumsQuery = db.Albums
                                              .Include(a => a.ArtistAlbums)
                                                  .ThenInclude(aa => aa.Artist)
                                              .Include(a => a.Type)
                                              .Include(a => a.Category)
                                              .OrderBy(a => a.ArtistAlbums
                                                             .Select(aa => aa.Artist.Name)
                                                             .FirstOrDefault())
                                              .ThenBy(a => a.Title);

            // Wyszukiwanie albumów po tytule
            IQueryable<Album> albumsByTitleQuery = albumsQuery;
            if (!string.IsNullOrEmpty(text))
            {
                albumsByTitleQuery = albumsByTitleQuery.Where(a => a.Title.ToLower().Contains(text.ToLower()));
            }
            var searchResultsByTitle = albumsByTitleQuery.ToList();

            // Wyszukiwanie artystów, których nazwa pasuje do tekstu
            IQueryable<Artist> artistsQuery = db.Artists.OrderBy(a => a.Name);
            if (!string.IsNullOrEmpty(text))
            {
                // Filtrujemy tylko artystów, których nazwa zawiera wpisany tekst (ignorując wielkość liter)
                artistsQuery = artistsQuery.Where(a => a.Name.ToLower().Contains(text.ToLower()));
            }

            // Pobierz wyniki artystów
            var artistResults = artistsQuery.ToList();

            // Jeśli znaleziono tylko jednego artystę i nie znaleziono żadnego albumu, przekieruj na stronę artysty
            if (artistResults.Count == 1 && !searchResultsByTitle.Any())
            {
                var artistName = artistResults.FirstOrDefault()?.Name;
                return RedirectToAction("ArtistAlbums", "Home", new { artistName });
            }

            // Zapisz wyniki wyszukiwania artystów do ViewBag
            ViewBag.SearchResultsByArtist = artistResults;

            // Sprawdź, czy wyszukiwanie obejmuje wszystkie albumy
            var allAlbumsCount = albumsQuery.Count();
            if (searchResultsByTitle.Count == allAlbumsCount)
            {
                ViewBag.AllAlbums = true;
            }

            return View("Search", searchResultsByTitle);
        }



        public IActionResult CategoryAlbums(string categoryName)
        {
            var albums = db.Albums
                            .Include(a => a.ArtistAlbums) // Łączenie z tabelą ArtistAlbums
                            .ThenInclude(aa => aa.Artist) // Łączenie z tabelą Artists
                            .Include(a => a.Type)         // Łączenie z tabelą Type
                            .Include(a => a.Category)     // Łączenie z tabelą Category
                            .Where(a => a.Category.Name == categoryName)
                            .ToList(); // Przeniesienie danych do pamięci

            // Sortowanie albumów na poziomie aplikacji
            var categoryAlbums = albums
                                .OrderBy(a => string.Join(", ", a.ArtistAlbums
                                    .Select(aa => aa.Artist.Name)      // Pobieranie nazw artystów
                                    .OrderBy(name => name)))           // Sortowanie nazw artystów w albumie alfabetycznie
                                .ThenBy(a => a.Title)                  // Następnie sortowanie według tytułu albumu
                                .ToList();

            return View(categoryAlbums);
        }

        public IActionResult TypeAlbums(string typeName)
        {
            var albums = db.Albums
                            .Include(a => a.ArtistAlbums) // Łączenie z tabelą ArtistAlbums
                            .ThenInclude(aa => aa.Artist) // Łączenie z tabelą Artists
                            .Include(a => a.Type)         // Łączenie z tabelą Type
                            .Include(a => a.Category)     // Łączenie z tabelą Category
                            .Where(a => a.Type.Name == typeName)
                            .ToList(); // Przeniesienie danych do pamięci

            // Sortowanie albumów na poziomie aplikacji
            var typeAlbums = albums
                                .OrderBy(a => string.Join(", ", a.ArtistAlbums
                                    .Select(aa => aa.Artist.Name)      // Pobieranie nazw artystów
                                    .OrderBy(name => name)))           // Sortowanie nazw artystów w albumie alfabetycznie
                                .ThenBy(a => a.Title)                  // Następnie sortowanie według tytułu albumu
                                .ToList();

            return View(typeAlbums);
        }

        public IActionResult Stats()
        {
            // Całkowita liczba albumów
            var totalAlbums = db.Albums.Count();

            // Całkowita liczba artystów
            var totalArtists = db.Artists.Count();

            // Średnia data wydania albumów
            var averageReleaseYear = (int)Math.Floor(db.Albums.Average(a => a.PublishDate));

            // Liczba albumów w zależności od typu
            var albumsByType = db.Albums
                .GroupBy(a => a.Type.Name)
                .Select(g => new AlbumsByTypeViewModel { TypeName = g.Key, Count = g.Count() })
                .ToList();

            // Liczba albumów dla każdego artysty
            var albumsByArtist = db.ArtistAlbums
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Liczba albumów w zależności od gatunku
            var albumsByGenre = db.Albums
                .GroupBy(a => a.Category.Name)
                .Select(g => new AlbumsByTypeViewModel { TypeName = g.Key, Count = g.Count() })
                .ToList();

            var newestAlbum = db.Albums
                .Include(a=>a.Type)
                .Include(a=>a.Category)
                .OrderByDescending(a => a.PublishDate)
                .ThenByDescending(a=>a.Id)
                .FirstOrDefault();
            var newestAlbumArtists = db.ArtistAlbums
                                              .Where(aa => aa.AlbumId == newestAlbum.Id)
                                              .Select(aa => aa.Artist)
                                              .ToList();

            var oldestAlbum = db.Albums
                .Include(a => a.Type)
                .Include(a => a.Category)
                .OrderBy(a => a.PublishDate).FirstOrDefault();
            var oldestAlbumArtists = db.ArtistAlbums
                                              .Where(aa => aa.AlbumId == oldestAlbum.Id)
                                              .Select(aa => aa.Artist)
                                              .ToList();

            // Serializacja danych o albumach według artystów do formatu JSON
            ViewBag.AlbumsByArtistJson = Newtonsoft.Json.JsonConvert.SerializeObject(albumsByArtist);

            // Przygotowanie modelu widoku
            var statsViewModel = new StatsViewModel
            {
                TotalAlbums = totalAlbums,
                TotalArtists = totalArtists,
                AverageReleaseYear = averageReleaseYear,
                AlbumsByType = albumsByType,
                AlbumsByArtist = albumsByArtist,
                OldestAlbum = oldestAlbum,
                OldestAlbumArtists = oldestAlbumArtists,
                NewestAlbum = newestAlbum,
                NewestAlbumArtists = newestAlbumArtists,
                AlbumsByGenre = albumsByGenre
            };

            // Najpopularniejsi artyści dla typu 1
            var topArtistsType1 = db.ArtistAlbums
                .Where(aa => aa.Album.TypeId == 1)
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Najpopularniejsi artyści dla typu 2
            var topArtistsType2 = db.ArtistAlbums
                .Where(aa => aa.Album.TypeId == 2)
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Najpopularniejsi artyści dla typu 3
            var topArtistsType3 = db.ArtistAlbums
                .Where(aa => aa.Album.TypeId == 3)
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Najpopularniejsi artyści w gatunku "Rap"
            var topArtistsCategoryRap = db.ArtistAlbums
                .Where(aa => aa.Album.CategoryId == 1)
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Najpopularniejsi artyści w gatunku "Rock"
            var topArtistsCategoryRock = db.ArtistAlbums
                .Where(aa => aa.Album.CategoryId == 2)
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Najpopularniejsi artyści w gatunku "Inne"
            var topArtistsCategoryInne = db.ArtistAlbums
                .Where(aa => aa.Album.CategoryId == 3)
                .GroupBy(aa => aa.Artist.Name)
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Count()
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();

            // Serializacja danych do widoku
            ViewBag.TopArtistsCategoryInne = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsCategoryInne);
            ViewBag.TopArtistsCategoryRock = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsCategoryRock);
            ViewBag.TopArtistsCategoryRap = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsCategoryRap);
            ViewBag.TopArtistsType1 = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsType1);
            ViewBag.TopArtistsType2 = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsType2);
            ViewBag.TopArtistsType3 = Newtonsoft.Json.JsonConvert.SerializeObject(topArtistsType3);

            return View(statsViewModel);
        }

    }
}

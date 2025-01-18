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
            // Pobieranie albumów z powiązanymi artystami i danymi dodatkowymi
            var albums = db.Albums
                            .Include(a => a.ArtistAlbums)
                            .ThenInclude(aa => aa.Artist)
                            .Include(a => a.Type)
                            .Include(a => a.Category)
                            .ToList();

            // Przygotowanie danych z priorytetem dla GroupName
            var preparedAlbums = albums.Select(album => new
            {
                Album = album,
                DisplayArtists = album.ArtistAlbums
                                        .Select(aa => !string.IsNullOrEmpty(aa.GroupName) ? aa.GroupName : aa.Artist.Name)
                                        .Distinct() // Usunięcie duplikatów (na wypadek powtarzania)
                                        .OrderBy(name => name) // Sortowanie nazw artystów/grup
            });

            // Sortowanie na podstawie nazw artystów lub grup
            var sortedAlbums = preparedAlbums
                                .OrderBy(a => string.Join(", ", a.DisplayArtists))
                                .ThenBy(a => a.Album.Title)
                                .Select(a => a.Album) // Przywrócenie listy albumów po sortowaniu
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

            // Przygotowanie danych z priorytetem dla GroupName
            var preparedAlbums = albums.Select(album => new
            {
                Album = album,
                DisplayArtists = album.ArtistAlbums
                                        .Select(aa => !string.IsNullOrEmpty(aa.GroupName) ? aa.GroupName : aa.Artist.Name)
                                        .Distinct() // Usunięcie duplikatów (na wypadek powtarzania)
                                        .OrderBy(name => name) // Sortowanie nazw artystów/grup
            });

            // Sortowanie na podstawie nazw artystów lub grup
            var newestAlbums = preparedAlbums
                                .OrderBy(a => string.Join(", ", a.DisplayArtists))
                                .ThenBy(a => a.Album.Title)
                                .Select(a => a.Album) // Przywrócenie listy albumów po sortowaniu
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
            var isGroup = Request.Form["isGroup"].ToString() == "on";
            var groupName = Request.Form["groupName"].ToString();

            if (artistIds == null || artistIds.Length == 0)
            {
                ModelState.AddModelError("artistIds[]", "Dodaj artystę");
                state = false;
            }

            if (isGroup && string.IsNullOrEmpty(groupName))
            {
                ModelState.AddModelError("groupName", "Podaj nazwę grupy");
                state = false;
            }

            if (state)
            {
                // Sprawdzanie, czy album już istnieje
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
                            AlbumId = model.Id,
                            GroupName = isGroup ? groupName : null
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
        public IActionResult GetGroupSuggestions(string query)
        {
            var groups = db.ArtistAlbums
                           .Where(aa => aa.GroupName != null && aa.GroupName.Contains(query))
                           .Select(aa => aa.GroupName)
                           .Distinct()
                           .ToList();

            return Json(groups.Select(groupName => new
            {
                name = groupName,
                artists = db.ArtistAlbums
                            .Where(aa => aa.GroupName == groupName)
                            .Select(aa => new { id = aa.ArtistId, name = aa.Artist.Name })
                            .Distinct()
                            .ToList()
            }));
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
            // Pobieranie albumów indywidualnych (solowych)
            var artistAlbums = db.Albums
                                 .Include(a => a.ArtistAlbums)
                                     .ThenInclude(aa => aa.Artist)
                                 .Include(a => a.Type)
                                 .Include(a => a.Category)
                                 .Where(a => a.ArtistAlbums.Any(aa => aa.Artist.Name == artistName && aa.GroupName == null))
                                 .OrderBy(a => a.Title)
                                 .ToList();

            // Pobieranie grup, w których artysta występuje
            var groups = db.ArtistAlbums
                           .Where(aa => aa.Artist.Name == artistName && aa.GroupName != null)
                           .Select(aa => aa.GroupName)
                           .Distinct()
                           .ToList();

            // Pobieranie albumów dla każdej grupy, pogrupowanych według typu
            var groupAlbums = new Dictionary<string, List<MusicCollection.Models.Album>>();

            foreach (var group in groups)
            {
                var albumsForGroup = db.Albums
                                       .Include(a => a.ArtistAlbums)
                                           .ThenInclude(aa => aa.Artist)
                                       .Include(a => a.Type)
                                       .Include(a => a.Category)
                                       .Where(a => a.ArtistAlbums.Any(aa => aa.GroupName == group))
                                       .OrderBy(a => a.Title)
                                       .ToList();

                groupAlbums[group] = albumsForGroup;
            }

            // Dodanie danych do ViewBag
            ViewBag.ArtistName = artistName;
            ViewBag.GroupAlbums = groupAlbums;

            return View(artistAlbums);
        }


        public IActionResult GroupAlbums(string groupName)
        {
            if (string.IsNullOrEmpty(groupName))
                return RedirectToAction("Index");

            // Pobieranie albumów powiązanych z grupą
            var albums = db.Albums
                           .Include(a => a.ArtistAlbums)
                           .ThenInclude(aa => aa.Artist)
                           .Include(a=>a.Type)
                           .Include(a=>a.Category)
                           .Where(a => a.ArtistAlbums.Any(aa => aa.GroupName == groupName))
                           .ToList();

            ViewBag.GroupName = groupName;
            return View(albums);
        }

        public IActionResult Search(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                ViewBag.AllAlbums = true;
                return View(new ArtistOrGroupLists
                {
                    Albums = new List<Album>(),
                    ArtistsAndGroups = new List<ArtistOrGroup>()
                });
            }

            // Pobierz wszystkie albumy z tabelami powiązanymi
            IQueryable<Album> albumsQuery = db.Albums
                                              .Include(a => a.ArtistAlbums)
                                                  .ThenInclude(aa => aa.Artist)
                                              .Include(a => a.Type)
                                              .Include(a => a.Category)
                                              .OrderBy(a => a.ArtistAlbums
                                                             .Select(aa => aa.GroupName ?? aa.Artist.Name)
                                                             .FirstOrDefault())
                                              .ThenBy(a => a.Title);

            // Wyszukiwanie albumów po tytule
            IQueryable<Album> albumsByTitleQuery = albumsQuery;
            if (!string.IsNullOrEmpty(text))
            {
                albumsByTitleQuery = albumsByTitleQuery.Where(a => a.Title.ToLower().Contains(text.ToLower()));
            }
            var searchResultsByTitle = albumsByTitleQuery.ToList();

            // Wyszukiwanie artystów i grup
            var searchResults = db.ArtistAlbums
                .Select(aa => new ArtistOrGroup
                {
                    Name = aa.GroupName ?? aa.Artist.Name,
                    IsGroup = !string.IsNullOrEmpty(aa.GroupName)
                })
                .Distinct()
                .Where(sr => sr.Name.ToLower().Contains(text.ToLower()))
                .OrderBy(sr => sr.Name)
                .ToList();

            // Jeśli znaleziono tylko jednego artystę/grupę i nie znaleziono żadnego albumu, przekieruj na odpowiednią stronę
            if (searchResults.Count == 1 && !searchResultsByTitle.Any())
            {
                var result = searchResults.First();
                if (result.IsGroup)
                {
                    return RedirectToAction("GroupAlbums", "Home", new { groupName = result.Name });
                }
                else
                {
                    return RedirectToAction("ArtistAlbums", "Home", new { artistName = result.Name });
                }
            }

            // Utwórz ViewModel
            var viewModel = new ArtistOrGroupLists
            {
                Albums = searchResultsByTitle,
                ArtistsAndGroups = searchResults
            };

            return View(viewModel);
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
            // Przygotowanie danych z priorytetem dla GroupName
            var preparedAlbums = albums.Select(album => new
            {
                Album = album,
                DisplayArtists = album.ArtistAlbums
                                        .Select(aa => !string.IsNullOrEmpty(aa.GroupName) ? aa.GroupName : aa.Artist.Name)
                                        .Distinct() // Usunięcie duplikatów (na wypadek powtarzania)
                                        .OrderBy(name => name) // Sortowanie nazw artystów/grup
            });

            // Sortowanie na podstawie nazw artystów lub grup
            var categoryAlbums = preparedAlbums
                                .OrderBy(a => string.Join(", ", a.DisplayArtists))
                                .ThenBy(a => a.Album.Title)
                                .Select(a => a.Album) // Przywrócenie listy albumów po sortowaniu
                                .ToList();

            return View(categoryAlbums);
        }

        public IActionResult TypeAlbums(string typeName)
        {
            // Pobieranie albumów z powiązanymi artystami i danymi dodatkowymi
            var albums = db.Albums
                            .Include(a => a.ArtistAlbums) // Łączenie z tabelą ArtistAlbums
                            .ThenInclude(aa => aa.Artist) // Łączenie z tabelą Artists
                            .Include(a => a.Type)         // Łączenie z tabelą Type
                            .Include(a => a.Category)     // Łączenie z tabelą Category
                            .Where(a => a.Type.Name == typeName)
                            .ToList(); // Przeniesienie danych do pamięci

            // Przygotowanie danych z priorytetem dla GroupName
            var preparedAlbums = albums.Select(album => new
            {
                Album = album,
                DisplayArtists = album.ArtistAlbums
                                        .Select(aa => !string.IsNullOrEmpty(aa.GroupName) ? aa.GroupName : aa.Artist.Name)
                                        .Distinct() // Usunięcie duplikatów (na wypadek powtarzania)
                                        .OrderBy(name => name) // Sortowanie nazw artystów/grup
            });

            // Sortowanie na podstawie nazw artystów lub grup
            var typeAlbums = preparedAlbums
                                .OrderBy(a => string.Join(", ", a.DisplayArtists))
                                .ThenBy(a => a.Album.Title)
                                .Select(a => a.Album) // Przywrócenie listy albumów po sortowaniu
                                .ToList();

            return View(typeAlbums);
        }

        public IActionResult Stats()
        {
            // Całkowita liczba albumów
            var totalAlbums = db.Albums.Count();


            var artistsWithAlbums = db.Artists
                               .Where(a => a.ArtistAlbums.Any(aa => aa.Album != null))
                               .ToList();

            // Pobranie grup, które mają co najmniej jeden album
            var groupsWithAlbums = db.ArtistAlbums
                                      .Where(aa => aa.GroupName != null && aa.Album != null)
                                      .Select(aa => aa.GroupName)
                                      .Distinct()
                                      .ToList();

            // Liczenie artystów i grup
            var totalArtistsSolo = artistsWithAlbums.Count();
            var totalGroups = groupsWithAlbums.Count();

            // Zliczanie wszystkich artystów i grup (łącznie)
            var totalArtists = totalArtistsSolo + totalGroups;

            // Średnia data wydania albumów
            var averageReleaseYear = (int)Math.Floor(db.Albums.Average(a => a.PublishDate));

            // Liczba albumów w zależności od typu
            var albumsByType = db.Albums
                .GroupBy(a => a.Type.Name)
                .Select(g => new AlbumsByTypeViewModel { TypeName = g.Key, Count = g.Count() })
                .ToList();

            // Liczba albumów dla każdego artysty
            var albumsByArtist = db.ArtistAlbums
                .GroupBy(aa => new { ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName, aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
})
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key.ArtistOrGroup,
                    AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
                })
                .GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
                .Select(g => new AlbumsByArtistViewModel
                {
                    ArtistName = g.Key,
                    AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
                })
                .OrderByDescending(a => a.AlbumCount)
                .Take(8)
                .ToList();


            // Liczba albumów w zależności od gatunku
            var albumsByGenre = db.Albums
                .GroupBy(a => a.Category.Name)
                .Select(g => new AlbumsByTypeViewModel { TypeName = g.Key, Count = g.Count() })
                .ToList();

            // Pobieranie najnowszego albumu
            var newestAlbum = db.Albums
                .Include(a => a.Type)
                .Include(a => a.Category)
                .OrderByDescending(a => a.PublishDate)
                .ThenByDescending(a => a.Id)
                .FirstOrDefault();

            // Pobieranie artystów dla najnowszego albumu (uwzględniając grupy)
            var newestAlbumArtists = db.ArtistAlbums
                .Where(aa => aa.AlbumId == newestAlbum.Id)
                .Select(aa => new Artist
                {
                    Name = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName
                })
                .Distinct()
                .ToList();

            // Pobieranie najstarszego albumu
            var oldestAlbum = db.Albums
                .Include(a => a.Type)
                .Include(a => a.Category)
                .OrderBy(a => a.PublishDate)
                .FirstOrDefault();

            // Pobieranie artystów dla najstarszego albumu (uwzględniając grupy)
            var oldestAlbumArtists = db.ArtistAlbums
                .Where(aa => aa.AlbumId == oldestAlbum.Id)
                .Select(aa => new Artist
                {
                    Name = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName
                })
                .Distinct()
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
    .GroupBy(aa => new {
        ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName,
        aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
    })
    .Select(g => new AlbumsByArtistViewModel
    {
        ArtistName = g.Key.ArtistOrGroup,
        AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
    })
    .GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
    .Select(g => new AlbumsByArtistViewModel
    {
        ArtistName = g.Key,
        AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
    })
    .OrderByDescending(a => a.AlbumCount)
    .Take(8)
    .ToList();
            // Najpopularniejsi artyści dla typu 2
            var topArtistsType2 = db.ArtistAlbums
                 .Where(aa => aa.Album.TypeId == 2)
     .GroupBy(aa => new {
         ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName,
         aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
     })
     .Select(g => new AlbumsByArtistViewModel
     {
         ArtistName = g.Key.ArtistOrGroup,
         AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
     })
     .GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
     .Select(g => new AlbumsByArtistViewModel
     {
         ArtistName = g.Key,
         AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
     })
     .OrderByDescending(a => a.AlbumCount)
     .Take(8)
     .ToList();

            // Najpopularniejsi artyści dla typu 3
            var topArtistsType3 = db.ArtistAlbums
                 .Where(aa => aa.Album.TypeId == 3)
     .GroupBy(aa => new {
         ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName,
         aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
     })
     .Select(g => new AlbumsByArtistViewModel
     {
         ArtistName = g.Key.ArtistOrGroup,
         AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
     })
     .GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
     .Select(g => new AlbumsByArtistViewModel
     {
         ArtistName = g.Key,
         AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
     })
     .OrderByDescending(a => a.AlbumCount)
     .Take(8)
     .ToList();

            // Najpopularniejsi artyści w gatunku "Rap"
            var topArtistsCategoryRap = db.ArtistAlbums
                .Where(aa => aa.Album.CategoryId == 1)
    .GroupBy(aa => new {
        ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName,
        aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
    })
    .Select(g => new AlbumsByArtistViewModel
    {
        ArtistName = g.Key.ArtistOrGroup,
        AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
    })
    .GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
    .Select(g => new AlbumsByArtistViewModel
    {
        ArtistName = g.Key,
        AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
    })
    .OrderByDescending(a => a.AlbumCount)
    .Take(8)
    .ToList();

            // Najpopularniejsi artyści w gatunku "Rock"
            var topArtistsCategoryRock = db.ArtistAlbums
    .Where(aa => aa.Album.CategoryId == 2)
.GroupBy(aa => new {
ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName,
aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
})
.Select(g => new AlbumsByArtistViewModel
{
ArtistName = g.Key.ArtistOrGroup,
AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
})
.GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
.Select(g => new AlbumsByArtistViewModel
{
    ArtistName = g.Key,
    AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
})
.OrderByDescending(a => a.AlbumCount)
.Take(8)
.ToList();

            // Najpopularniejsi artyści w gatunku "Inne"
            var topArtistsCategoryInne = db.ArtistAlbums
    .Where(aa => aa.Album.CategoryId == 3)
.GroupBy(aa => new {
ArtistOrGroup = string.IsNullOrEmpty(aa.GroupName) ? aa.Artist.Name : aa.GroupName,
aa.AlbumId  // Grupa albumu, aby liczyć tylko raz
})
.Select(g => new AlbumsByArtistViewModel
{
ArtistName = g.Key.ArtistOrGroup,
AlbumCount = g.Select(aa => aa.AlbumId).Distinct().Count() // Liczymy unikalne albumy
})
.GroupBy(x => x.ArtistName)  // Grupa po nazwie artysty lub grupy
.Select(g => new AlbumsByArtistViewModel
{
    ArtistName = g.Key,
    AlbumCount = g.Sum(x => x.AlbumCount)  // Suma unikalnych albumów
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

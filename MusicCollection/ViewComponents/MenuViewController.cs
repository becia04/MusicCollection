using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MusicCollection.DAL;
using MusicCollection.Models;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.EntityFrameworkCore;

namespace MusicCollection.ViewComponents
{
    public class MenuViewComponent : ViewComponent
    {
        AlbumContext db;

        public MenuViewComponent(AlbumContext db)
        {
            this.db = db;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            // Pobranie artystów, którzy mają przypisany przynajmniej jeden album
            var artists = await db.Artists
                .Where(a => a.ArtistAlbums.Any()) // Filtrujemy tylko tych artystów, którzy mają albumy
                .OrderBy(a => a.Name)
                .Select(a => new ArtistOrGroup
                {
                    Name = a.Name,
                    IsGroup = false
                })
                .ToListAsync();

            // Pobranie grup, które mają przypisany przynajmniej jeden album
            var groups = await db.ArtistAlbums
                .Where(aa => !string.IsNullOrEmpty(aa.GroupName) && aa.AlbumId != null) // Filtrujemy tylko te grupy, które mają przypisane albumy
                .Select(aa => new ArtistOrGroup
                {
                    Name = aa.GroupName,
                    IsGroup = true
                })
                .Distinct() // Usunięcie duplikatów grup
                .OrderBy(g => g.Name)
                .ToListAsync();

            // Połączenie artystów i grup
            var artistsAndGroups = artists.Concat(groups)
                .OrderBy(a => a.Name) // Sortowanie po nazwie
                .ToList();


            ViewData["Artists"] = artistsAndGroups;

            ViewData["Types"] = await db.Types.Distinct().OrderBy(a => a.Name).ToListAsync();
            ViewData["Categories"] = await db.Categories.Distinct().ToListAsync();

            return View("_Menu");
        }


    }
}

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
            var artists = await db.Artists.Where(a => a.Album.Any()).Distinct().OrderBy(a => a.Name).ToListAsync();
            var types = await db.Types.Distinct().OrderBy(a => a.Name).ToListAsync();
            var categories = await db.Categories.Distinct().ToListAsync();

            ViewData["Artists"] = artists;
            ViewData["Types"] = types;
            ViewData["Categories"] = categories;

            return View("_Menu");
        }

    }
}

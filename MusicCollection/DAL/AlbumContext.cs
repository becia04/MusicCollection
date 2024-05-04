using Microsoft.EntityFrameworkCore;
using MusicCollection.Models;

namespace MusicCollection.DAL
{
    public class AlbumContext : DbContext
    {

        public DbSet<Album> Albums { get; set; }
        public DbSet<Artist> Artists { get; set; }
        public DbSet<Song> Songs { get; set; }
        public DbSet<Models.Type> Types { get; set; }
        public DbSet<ArtistAlbum> ArtistAlbums { get; set; }
        public DbSet<Category> Categories { get; set; }

        public AlbumContext(DbContextOptions<AlbumContext> options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Models.Type>().HasData(
                new Models.Type
                {
                    Id = 1,
                    Name = "CD"
                },
                new Models.Type
                {
                    Id = 2,
                    Name = "LP"
                },
                new Models.Type
                {
                    Id = 3,
                    Name = "Tape"
                });

        }
    }
}

using System;
using System.Collections.Generic;

namespace MusicCollection.Models
{
    public class Album
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int PublishDate { get; set; }
        public string Poster {  get; set; }
        public string ?Date { get; set; }

        //FK
        public int TypeId { get; set; }
        public Type Type { get; set; }

        public int CategoryId { get; set; }
        public Category Category { get; set; }

        public ICollection<ArtistAlbum> ArtistAlbums { get; set; }
    }
}

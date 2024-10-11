using System.Collections.Generic;

namespace MusicCollection.Models
{
    public class Artist
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public ICollection<ArtistAlbum> ArtistAlbums { get; set; }
    }
}

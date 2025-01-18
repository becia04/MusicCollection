using System.Collections.Generic;

namespace MusicCollection.Models
{
    public class ArtistOrGroupLists
    {
        public List<Album> Albums { get; set; } = new List<Album>();
        public List<ArtistOrGroup> ArtistsAndGroups { get; set; } = new List<ArtistOrGroup>();
    }

    public class ArtistOrGroup
    {
        public string Name { get; set; }
        public bool IsGroup { get; set; }
    }
}

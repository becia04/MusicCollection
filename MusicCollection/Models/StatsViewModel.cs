using System.Collections.Generic;

namespace MusicCollection.Models
{
    public class StatsViewModel
    {
            public int TotalAlbums { get; set; }
            public int TotalArtists { get; set; }
            public int AverageReleaseYear { get; set; }
            public List<AlbumsByTypeViewModel> AlbumsByType { get; set; }
            public List<AlbumsByTypeViewModel> AlbumsByGenre { get; set; }
            public List<AlbumsByArtistViewModel> AlbumsByArtist { get; set; }
            public Album OldestAlbum { get; set; }
            public Album NewestAlbum { get; set; }
            public List<AlbumsByArtistViewModel> TopArtistsType1 { get; set; }
            public List<AlbumsByArtistViewModel> TopArtistsType2 { get; set; }

    }

    public class AlbumsByTypeViewModel
    {
        public string TypeName { get; set; }
        public int Count { get; set; }
    }

    public class AlbumsByArtistViewModel
    {
        public string ArtistName { get; set; }
        public int AlbumCount { get; set; }
    }
}

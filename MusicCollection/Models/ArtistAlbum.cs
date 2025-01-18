namespace MusicCollection.Models
{
    public class ArtistAlbum
    {
        public int Id { get; set; }
        public int ArtistId {  get; set; }
        public Artist Artist { get; set; }
        public int AlbumId { get; set; }
        public Album Album { get; set; }
        public string? GroupName { get; set; }
    }
}

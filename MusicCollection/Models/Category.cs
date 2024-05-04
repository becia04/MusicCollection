using System.Collections.Generic;

namespace MusicCollection.Models
{
    public class Category
    {
        public int Id { get; set; }
        public string Name { get; set; }

        public ICollection<Album> Album { get; set; }
    }
}

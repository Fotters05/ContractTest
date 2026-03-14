using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("gender", Schema = "public")]
    public class Gender
    {
        [Key]
        [Column("id")]
        public short Id { get; set; }

        [Column("name")]
        public string Name { get; set; }
    }
}

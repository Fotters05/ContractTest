using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("base_education", Schema = "public")]
    public class BaseEducation
    {
        [Key]
        [Column("id")]
        public short Id { get; set; }

        [Column("name")]
        [Required]
        [MaxLength(100)]
        public string Name { get; set; }
    }
}


using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("education_level", Schema = "public")]
    public class EducationLevel
    {
        [Key]
        [Column("id")]
        public short Id { get; set; }

        [Column("name")]
        [MaxLength(100)]
        public string Name { get; set; }
    }
}



using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("teacher")]
    public class Teacher
    {
        [Key]
        [Column("id")]
        public long Id { get; set; }

        [Column("full_name")]
        [Required]
        [MaxLength(255)]
        public string FullName { get; set; } = "";

        [Column("created_at")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
    }
}

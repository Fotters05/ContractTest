using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("contract_type", Schema = "public")]
    public class ContractType
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Column("name")]
        [Required]
        [MaxLength(200)]
        public string Name { get; set; }

        [Column("file_path")]
        [Required]
        [MaxLength(1000)]
        public string FilePath { get; set; }
    }
}


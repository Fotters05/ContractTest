using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("organization", Schema = "public")]
    public class Organization
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("organization_name")]
        [Required]
        [MaxLength(500)]
        public string OrganizationName { get; set; }

        [Column("director_fio")]
        [Required]
        [MaxLength(300)]
        public string DirectorFio { get; set; }

        [Column("ogrn")]
        [Required]
        [MaxLength(13)]
        public string Ogrn { get; set; }

        [Column("inn")]
        [Required]
        [MaxLength(10)]
        public string Inn { get; set; }

        [Column("kpp")]
        [Required]
        [MaxLength(9)]
        public string Kpp { get; set; }

        [Column("legal_address")]
        [Required]
        [MaxLength(1000)]
        public string LegalAddress { get; set; }

        [Column("email")]
        [MaxLength(254)]
        public string? Email { get; set; }

        [Column("phone")]
        [MaxLength(50)]
        public string? Phone { get; set; }

        [Column("created_at")]
        public DateTime? CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime? UpdatedAt { get; set; }
    }
}

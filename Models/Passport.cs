using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("passport", Schema = "public")]
    public class Passport
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("person_id")]
        [Required]
        public long PersonId { get; set; }

        [ForeignKey("PersonId")]
        public virtual Person? Person { get; set; }

        [Column("series")]
        [MaxLength(10)]
        public string? Series { get; set; }

        [Column("number")]
        [MaxLength(10)]
        public string? Number { get; set; }

        [Column("issuance_date")]
        public DateTime? IssuanceDate { get; set; }

        [Column("issued_by")]
        [MaxLength(500)]
        public string? IssuedBy { get; set; }

        [Column("division_code")]
        [MaxLength(20)]
        public string? DivisionCode { get; set; }

        [Column("registration_date")]
        public DateTime? RegistrationDate { get; set; }

        [Column("passport_valid_from")]
        public DateTime? PassportValidFrom { get; set; }

        [Column("registration_address")]
        [MaxLength(1000)]
        public string? RegistrationAddress { get; set; }

        [Column("created_at")]
        public DateTime? CreatedAt { get; set; }
    }
}


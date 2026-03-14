using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("contacts", Schema = "public")]
    public class Contacts
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("postal_code")]
        [MaxLength(20)]
        public string? PostalCode { get; set; }

        [Column("region")]
        [MaxLength(200)]
        public string? Region { get; set; }

        [Column("city")]
        [MaxLength(200)]
        public string? City { get; set; }

        [Column("residence_address")]
        [MaxLength(1000)]
        public string? ResidenceAddress { get; set; }

        [Column("home_phone")]
        [MaxLength(50)]
        public string? HomePhone { get; set; }

        [Column("contact_phone")]
        [MaxLength(50)]
        public string? ContactPhone { get; set; }

        [Column("work_phone")]
        [MaxLength(50)]
        public string? WorkPhone { get; set; }

        [Column("email")]
        [MaxLength(254)]
        public string? Email { get; set; }

        [Column("created_at")]
        public DateTime? CreatedAt { get; set; }
    }
}


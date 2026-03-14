using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("person", Schema = "public")]
    public class Person
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("last_name")]
        [Required]
        [MaxLength(200)]
        public string LastName { get; set; }

        [Column("first_name")]
        [Required]
        [MaxLength(200)]
        public string FirstName { get; set; }

        [Column("patronymic")]
        [MaxLength(200)]
        public string? Patronymic { get; set; }

        [Column("date_of_birth")]
        public DateTime? DateOfBirth { get; set; }

        [Column("gender_id")]
        public short? GenderId { get; set; }

        [ForeignKey("GenderId")]
        public virtual Gender? Gender { get; set; }

        [Column("place_of_birth")]
        [MaxLength(500)]
        public string? PlaceOfBirth { get; set; }

        [Column("citizenship")]
        [MaxLength(200)]
        public string? Citizenship { get; set; }

        [Column("snils")]
        [MaxLength(11)]
        public string? Snils { get; set; }

        [Column("inn")]
        [MaxLength(12)]
        public string? Inn { get; set; }

        [Column("workplace")]
        [MaxLength(500)]
        public string? Workplace { get; set; }

        [Column("position")]
        [MaxLength(200)]
        public string? Position { get; set; }

        [Column("contacts_id")]
        public long? ContactsId { get; set; }

        [ForeignKey("ContactsId")]
        public virtual Contacts? Contacts { get; set; }

        [Column("created_at")]
        public DateTime? CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime? UpdatedAt { get; set; }

        public virtual System.Collections.Generic.ICollection<Education>? Educations { get; set; }

        [NotMapped]
        public string FullName => $"{LastName} {FirstName} {Patronymic}".Trim();
    }
}


using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    /// <summary>
    /// Модуль программы обучения
    /// </summary>
    [Table("program_module", Schema = "public")]
    public class ProgramModule
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("program_id")]
        [Required]
        public long ProgramId { get; set; }

        [ForeignKey("ProgramId")]
        public virtual LearningProgram? Program { get; set; }

        [Column("module_number")]
        [Required]
        public int ModuleNumber { get; set; }

        [Column("module_name")]
        [Required]
        [MaxLength(500)]
        public string ModuleName { get; set; }

        [Column("description")]
        public string? Description { get; set; }

        [Column("hours")]
        public int? Hours { get; set; }

        [Column("created_at")]
        public DateTime? CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime? UpdatedAt { get; set; }
    }
}

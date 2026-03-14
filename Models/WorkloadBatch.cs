using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("workload_batch", Schema = "public")]
    public class WorkloadBatch
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("program_id")]
        [Required]
        public long ProgramId { get; set; }

        [ForeignKey(nameof(ProgramId))]
        public virtual LearningProgram? Program { get; set; }

        [Column("teacher_id")]
        public long? TeacherId { get; set; }

        [ForeignKey(nameof(TeacherId))]
        public virtual Teacher? Teacher { get; set; }

        [Column("group_name")]
        [MaxLength(255)]
        public string? GroupName { get; set; }

        [Column("is_group")]
        [Required]
        public bool IsGroup { get; set; }

        [Column("created_at")]
        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}

using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("workload_document", Schema = "public")]
    public class WorkloadDocument
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

        [Column("batch_id")]
        public long? BatchId { get; set; }

        [ForeignKey(nameof(BatchId))]
        public virtual WorkloadBatch? Batch { get; set; }

        [Column("contract_id")]
        public long? ContractId { get; set; }

        [ForeignKey(nameof(ContractId))]
        public virtual Contract? Contract { get; set; }

        [Column("listener_id")]
        public long? ListenerId { get; set; }

        [ForeignKey(nameof(ListenerId))]
        public virtual Person? Listener { get; set; }

        [Column("teacher_id")]
        public long? TeacherId { get; set; }

        [ForeignKey(nameof(TeacherId))]
        public virtual Teacher? Teacher { get; set; }

        [Column("program_type")]
        [MaxLength(255)]
        public string? ProgramType { get; set; }

        [Column("group_name")]
        [MaxLength(255)]
        public string? GroupName { get; set; }

        [Column("is_group")]
        [Required]
        public bool IsGroup { get; set; }

        [Column("file_name")]
        [Required]
        [MaxLength(500)]
        public string FileName { get; set; } = string.Empty;

        [Column("file_path")]
        [Required]
        [MaxLength(1000)]
        public string FilePath { get; set; } = string.Empty;

        [Column("generated_at")]
        [Required]
        public DateTime GeneratedAt { get; set; } = DateTime.Now;

        [Column("created_at")]
        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}

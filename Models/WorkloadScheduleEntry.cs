using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("workload_schedule_entry", Schema = "public")]
    public class WorkloadScheduleEntry
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("workload_document_id")]
        [Required]
        public long WorkloadDocumentId { get; set; }

        [ForeignKey(nameof(WorkloadDocumentId))]
        public virtual WorkloadDocument? WorkloadDocument { get; set; }

        [Column("lesson_number")]
        [Required]
        public int LessonNumber { get; set; }

        [Column("module_number")]
        public int? ModuleNumber { get; set; }

        [Column("module_name")]
        [MaxLength(500)]
        public string? ModuleName { get; set; }

        [Column("topic")]
        [Required]
        public string Topic { get; set; } = string.Empty;

        [Column("lesson_date", TypeName = "date")]
        public DateTime? LessonDate { get; set; }

        [Column("day_of_week")]
        [MaxLength(50)]
        public string? DayOfWeek { get; set; }

        [Column("start_time", TypeName = "time without time zone")]
        public TimeSpan? StartTime { get; set; }

        [Column("end_time", TypeName = "time without time zone")]
        public TimeSpan? EndTime { get; set; }

        [Column("hours")]
        public int? Hours { get; set; }

        [Column("created_at")]
        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}

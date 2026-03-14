using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("holiday_calendar_day", Schema = "public")]
    public class HolidayCalendarDay
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("holiday_date", TypeName = "date")]
        [Required]
        public DateTime HolidayDate { get; set; }

        [Column("holiday_name")]
        [MaxLength(255)]
        public string? HolidayName { get; set; }

        [Column("created_at")]
        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }
}

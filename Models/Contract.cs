using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Contract2512.Models
{
    [Table("contract", Schema = "public")]
    public class Contract
    {
        [Key]
        [Column("id")]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Column("contract_number")]
        [Required]
        [MaxLength(200)]
        public string ContractNumber { get; set; }

        [Column("contract_date")]
        [Required]
        public DateTime ContractDate { get; set; }

        [Column("contract_type_id")]
        [Required]
        public int ContractTypeId { get; set; }

        [ForeignKey("ContractTypeId")]
        public virtual ContractType? ContractType { get; set; }

        [Column("program_id")]
        [Required]
        public long ProgramId { get; set; }

        [ForeignKey("ProgramId")]
        public virtual LearningProgram? Program { get; set; }

        [Column("start_date")]
        public DateTime? StartDate { get; set; }

        [Column("end_date")]
        public DateTime? EndDate { get; set; }

        [Column("is_group")]
        [Required]
        public bool IsGroup { get; set; } = false;

        [Column("payer_id")]
        [Required]
        public long PayerId { get; set; }

        [ForeignKey("PayerId")]
        public virtual Person? Payer { get; set; }

        [Column("listener_id")]
        [Required]
        public long ListenerId { get; set; }

        [ForeignKey("ListenerId")]
        public virtual Person? Listener { get; set; }

        [Column("created_at")]
        public DateTime? CreatedAt { get; set; }

        [Column("itog_document_option_key")]
        [MaxLength(50)]
        public string? ItogDocumentOptionKey { get; set; }

        [Column("time_option_key")]
        [MaxLength(50)]
        public string? TimeOptionKey { get; set; }

        [Column("study_option_key")]
        [MaxLength(50)]
        public string? StudyOptionKey { get; set; }

        [Column("signer_id")]
        public int? SignerId { get; set; }

        [Column("payment_option_key")]
        [MaxLength(50)]
        public string? PaymentOptionKey { get; set; }
    }
}


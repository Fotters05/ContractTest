using Microsoft.EntityFrameworkCore;
using Contract2512.Models;

namespace Contract2512.Services
{
    public class AppDbContext : DbContext
    {
        public AppDbContext() { }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Gender> Genders { get; set; }
        public DbSet<Person> Persons { get; set; }
        public DbSet<Passport> Passports { get; set; }
        public DbSet<Contacts> Contacts { get; set; }
        public DbSet<BaseEducation> BaseEducations { get; set; }
        public DbSet<EducationLevel> EducationLevels { get; set; }
        public DbSet<Education> Educations { get; set; }
        public DbSet<ProgramView> ProgramViews { get; set; }
        public DbSet<ContractType> ContractTypes { get; set; }
        public DbSet<LearningProgram> LearningPrograms { get; set; }
        public DbSet<Contract> Contracts { get; set; }
        public DbSet<Organization> Organizations { get; set; }
        public DbSet<ProgramModule> ProgramModules { get; set; }
        public DbSet<Teacher> Teachers { get; set; }
        public DbSet<WorkloadBatch> WorkloadBatches { get; set; }
        public DbSet<WorkloadDocument> WorkloadDocuments { get; set; }
        public DbSet<WorkloadScheduleEntry> WorkloadScheduleEntries { get; set; }
        public DbSet<HolidayCalendarDay> HolidayCalendarDays { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                var connectionString = DbConnectionStringProvider.GetConnectionString();
                
                if (string.IsNullOrWhiteSpace(connectionString))
                {
                    throw new InvalidOperationException(
                        "Строка подключения к базе данных не настроена. " +
                        "Пожалуйста, настройте подключение через окно настроек."
                    );
                }
                
                // Отключаем преобразование DateTime в UTC
                AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);
                
                optionsBuilder.UseNpgsql(connectionString);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            
            // Настройка для PostgreSQL
            modelBuilder.HasDefaultSchema("public");
            
            // Явная конфигурация для Passport - включаем registration_address
            modelBuilder.Entity<Passport>()
                .ToTable("passport", "public")
                .Property(p => p.RegistrationAddress)
                .HasColumnName("registration_address")
                .HasMaxLength(1000)
                .IsRequired(false);
            
            // Настройка связей для Contract - отключаем каскадное удаление
            modelBuilder.Entity<Contract>()
                .HasOne(c => c.ContractType)
                .WithMany()
                .HasForeignKey(c => c.ContractTypeId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Contract>()
                .HasOne(c => c.Program)
                .WithMany()
                .HasForeignKey(c => c.ProgramId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Contract>()
                .HasOne(c => c.Payer)
                .WithMany()
                .HasForeignKey(c => c.PayerId)
                .OnDelete(DeleteBehavior.Restrict);
            
            modelBuilder.Entity<Contract>()
                .HasOne(c => c.Listener)
                .WithMany()
                .HasForeignKey(c => c.ListenerId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<WorkloadBatch>()
                .HasOne(w => w.Program)
                .WithMany()
                .HasForeignKey(w => w.ProgramId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<WorkloadBatch>()
                .HasOne(w => w.Teacher)
                .WithMany()
                .HasForeignKey(w => w.TeacherId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<WorkloadDocument>()
                .HasOne(w => w.Program)
                .WithMany()
                .HasForeignKey(w => w.ProgramId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<WorkloadDocument>()
                .HasOne(w => w.Batch)
                .WithMany()
                .HasForeignKey(w => w.BatchId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<WorkloadDocument>()
                .HasOne(w => w.Contract)
                .WithMany()
                .HasForeignKey(w => w.ContractId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<WorkloadDocument>()
                .HasOne(w => w.Listener)
                .WithMany()
                .HasForeignKey(w => w.ListenerId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<WorkloadDocument>()
                .HasOne(w => w.Teacher)
                .WithMany()
                .HasForeignKey(w => w.TeacherId)
                .OnDelete(DeleteBehavior.SetNull);

            modelBuilder.Entity<WorkloadScheduleEntry>()
                .HasOne(s => s.WorkloadDocument)
                .WithMany()
                .HasForeignKey(s => s.WorkloadDocumentId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<WorkloadBatch>()
                .HasIndex(w => w.ProgramId);

            modelBuilder.Entity<WorkloadBatch>()
                .HasIndex(w => w.TeacherId);

            modelBuilder.Entity<WorkloadDocument>()
                .HasIndex(w => w.ProgramId);

            modelBuilder.Entity<WorkloadDocument>()
                .HasIndex(w => w.TeacherId);

            modelBuilder.Entity<WorkloadDocument>()
                .HasIndex(w => w.BatchId);

            modelBuilder.Entity<WorkloadDocument>()
                .HasIndex(w => w.ContractId);

            modelBuilder.Entity<WorkloadDocument>()
                .HasIndex(w => w.ListenerId);

            modelBuilder.Entity<WorkloadScheduleEntry>()
                .HasIndex(s => s.WorkloadDocumentId);

            modelBuilder.Entity<HolidayCalendarDay>()
                .HasIndex(h => h.HolidayDate)
                .IsUnique();
        }
    }
}

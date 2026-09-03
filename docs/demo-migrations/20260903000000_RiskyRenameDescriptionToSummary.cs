using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TrainingCatalog.Infrastructure.Migrations;

// Artefato deliberadamente arriscado para revisão estática; nunca aplicar.
public partial class RiskyRenameDescriptionToSummary : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropColumn(
            name: "Description",
            table: "Trainings");

        migrationBuilder.AddColumn<string>(
            name: "Summary",
            table: "Trainings",
            type: "TEXT",
            nullable: false,
            defaultValue: "");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropColumn(
            name: "Summary",
            table: "Trainings");

        migrationBuilder.AddColumn<string>(
            name: "Description",
            table: "Trainings",
            type: "TEXT",
            nullable: false,
            defaultValue: "");
    }
}
